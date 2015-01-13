//
//  DKPhotoCapture.h
//  DKPhotoCapture
//
//  Created by David Kopec on 1/4/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DKPhotoCapture : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) id<UIImagePickerControllerDelegate> delegate;

-(id)initWithDelegate:(id<UIImagePickerControllerDelegate>)delegate;

/*! Display the photo capture view.
 @param viewController The UIViewController on which the photo capture view will be overlaid.
 @returns a boolean that only returns False if the device has no camera
 */
-(BOOL)showPickerOnViewController:(UIViewController *)viewController;

@end
