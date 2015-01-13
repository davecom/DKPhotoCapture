//
//  ViewController.m
//  DKPhotoCapture
//
//  Created by David Kopec on 1/4/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

#import "ViewController.h"
#import "DKPhotoCapture.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic) DKPhotoCapture *photoCapture;
-(IBAction)displayPhotoCaptureView:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)displayPhotoCaptureView:(id)sender
{
    self.photoCapture = [[DKPhotoCapture alloc] initWithDelegate:self];
    [self.photoCapture showPickerOnViewController:self];
}
     
#pragma mark - UIImagePickerControllerDelegate
     
     // This method is called when an image has been chosen from the library or taken from the camera.
     - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        //get the image
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
    }
     
     
     - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
    {
        NSLog(@"Called imagePickerControllerDidCancel in root viewcontroller.");
        return;
    }

@end
