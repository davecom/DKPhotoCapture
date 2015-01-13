//
//  DKEditorView.h
//  DKPhotoCapture
//
//  Created by David Kopec on 1/6/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKVerticalColorPicker.h"

@interface DKEditorView : UIView <DKVerticalColorPickerDelegate, UITextFieldDelegate>

@property(nonatomic) UIImage *image;
@property (nonatomic) UITextField *textField;

-(void)colorPicked:(UIColor *)color;

@end
