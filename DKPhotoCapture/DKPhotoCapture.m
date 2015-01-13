//
//  DKPhotoCapture.m
//  DKPhotoCapture
//
//  Created by David Kopec on 1/4/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

#import "DKPhotoCapture.h"
#import "DKEditorView.h"

@interface DKPhotoCapture ()

//overlay outlets
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIButton *flashButton;

//editor outlets
@property (nonatomic) UIViewController *editorViewController;
@property (nonatomic) IBOutlet DKEditorView *editorView;
@property (nonatomic) IBOutlet UIButton *checkButton;
@property (nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) IBOutlet UIButton *xButton;
@property (nonatomic) IBOutlet UIButton *crayonButton;
@property (nonatomic) IBOutlet UIButton *textButton;
@property (nonatomic) IBOutlet DKVerticalColorPicker *verticalImagePicker;

//critical properties
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic) NSMutableDictionary *infoDictionary;  //for passing to delegate

-(IBAction)capture:(id)sender;
-(IBAction)flipCamera:(id)sender;
-(IBAction)toggleFlash:(id)sender;
-(IBAction)dismiss:(id)sender;

-(IBAction)addText:(id)sender;
-(IBAction)addScribble:(id)sender;
-(IBAction)backToCapture:(id)sender;
-(IBAction)confirm:(id)sender;

@end

@implementation DKPhotoCapture

-(id)initWithDelegate:(id<UIImagePickerControllerDelegate>)delegate
{
    if (self = [super init]) {
        
        self.delegate = delegate;
    }
    return self;
}


-(BOOL)showPickerOnViewController:(UIViewController *)viewController
{
    //class must be used on devices with cameras (i.e. this class will not work in the simulator)
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return NO;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    imagePickerController.delegate = self;
    
    //Based on http://stackoverflow.com/a/20228332/281461
    CGSize screenBounds = [UIScreen mainScreen].bounds.size;
    
    CGFloat cameraAspectRatio = 4.0f/3.0f;
    
    CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
    CGFloat scale = screenBounds.height / camViewHeight;
    
    imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
    imagePickerController.cameraViewTransform = CGAffineTransformScale(imagePickerController.cameraViewTransform, scale, scale);
    
    /*
     The user wants to use the camera interface. Set up our custom overlay view for the camera.
     */
    imagePickerController.showsCameraControls = NO;
    
    /*
     Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
     */
    [[NSBundle mainBundle] loadNibNamed:@"DKImagePickerOverlay" owner:self options:nil];
    self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
    imagePickerController.cameraOverlayView = self.overlayView;
    self.overlayView = nil;
    
    self.imagePickerController = imagePickerController;
    self.viewController = viewController;
    [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    
    return YES;
}

#pragma mark - Overlay IB Actions

-(IBAction)capture:(id)sender
{
    [self.imagePickerController takePicture];
}

-(IBAction)flipCamera:(id)sender
{
    if (self.imagePickerController.cameraDevice  == UIImagePickerControllerCameraDeviceFront) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
    } else {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            if (![UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront]) {
                self.flashButton.selected = NO;
                self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            }
            self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
}

-(IBAction)toggleFlash:(id)sender
{
    if (self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        if ([UIImagePickerController isFlashAvailableForCameraDevice:self.imagePickerController.cameraDevice]) {
            self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
            self.flashButton.selected = YES;
        }
    } else {
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        self.flashButton.selected = NO;
    }
}

-(IBAction)dismiss:(id)sender
{
    [self imagePickerControllerDidCancel:self.imagePickerController];
}

#pragma mark - Edit IB Actions

-(IBAction)addText:(id)sender
{
    return;
}

-(IBAction)addScribble:(id)sender
{
    return;
    //DKEditorView *dkev = (DKEditorView *)self.editorViewController.view;
    //[dkev crayon]
}

-(IBAction)backToCapture:(id)sender
{
    [self.imagePickerController dismissViewControllerAnimated:NO completion:nil];
    self.infoDictionary = nil;
    self.editorViewController = nil;
}

-(IBAction)confirm:(id)sender
{
    //manipulate it into an edited image (stored by the edited image key)
    /*
    DKEditorView *dkev = (DKEditorView *)self.editorViewController.view;
    UIGraphicsBeginImageContext(dkev.frame.size);
    [dkev.image drawAtPoint:CGPointMake(0.0, 0.0)];
    if (dkev.textField != nil) {
         [dkev.textField.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     */
    self.backButton.hidden = YES;
    self.xButton.hidden = YES;
    self.checkButton.hidden = YES;
    self.verticalImagePicker.hidden = YES;
    self.textButton.hidden = YES;
    self.crayonButton.hidden = YES;
    DKEditorView *dkev = (DKEditorView *)self.editorViewController.view;
    UIGraphicsBeginImageContext(dkev.frame.size);
    [dkev.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //modify the info dictionary (add edited image, and a new key for the string)
    [self.infoDictionary setValue:temp forKey:UIImagePickerControllerOriginalImage];
    
    //call delegate methods of the same name
    [self.delegate imagePickerController:self.imagePickerController didFinishPickingMediaWithInfo:[NSDictionary dictionaryWithDictionary:self.infoDictionary]];
    [self.imagePickerController dismissViewControllerAnimated:NO completion:nil];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    self.editorViewController = nil;
    self.infoDictionary = nil;
    self.imagePickerController = nil;  // so released
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //get the image
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.editorViewController = [[UIViewController alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"DKImageEdit" owner:self options:nil];
    self.editorView.frame = self.imagePickerController.cameraOverlayView.frame;
    self.editorViewController.view = self.editorView;
    self.editorView.image = image;
    self.editorView = nil;
    
    self.infoDictionary = [NSMutableDictionary dictionaryWithDictionary:info];
    
    [self.imagePickerController presentViewController:self.editorViewController animated:NO completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //hide the UIImagePickerView
    [self.viewController dismissViewControllerAnimated:YES completion:NULL];
    //call delegate methods of the same
    [self.delegate imagePickerControllerDidCancel:picker];
    self.editorViewController = nil;
    self.infoDictionary = nil;
    self.imagePickerController = nil;  // so released
    
    
}

@end