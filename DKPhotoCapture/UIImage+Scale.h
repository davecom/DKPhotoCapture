//
//  UIImage+Scale.h
//  DKPhotoCapture
//
//  Created by David Kopec on 1/11/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
