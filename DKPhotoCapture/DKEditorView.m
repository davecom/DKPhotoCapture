//
//  DKEditorView.m
//  DKPhotoCapture
//
//  Created by David Kopec on 1/6/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

#import "DKEditorView.h"
#import "UIImage+Scale.h"
#import "ForwardingTextField.h"

@interface DKEditorView ()

//drawing vars
@property (nonatomic) UIColor *drawColor;
@property (nonatomic) BOOL isDrawing;
@property (nonatomic, weak) IBOutlet DKVerticalColorPicker *dkvcp;
@property (nonatomic) CGPoint lastPoint;

//added text vars
@property (nonatomic) CGFloat textFieldY;
@property (nonatomic) BOOL isMovingText;

-(IBAction)crayonPushed:(id)sender;
-(IBAction)textButtonPushed:(id)sender;

@end

@implementation DKEditorView

//drawing pseudo constants
CGFloat brush = 5.0;

-(void)setImage:(UIImage *)image
{
    _image = [image imageByScalingAndCroppingForSize:self.frame.size];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isDrawing = NO;
        self.multipleTouchEnabled = YES;
        self.drawColor = [UIColor redColor];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.isDrawing = NO;
        self.multipleTouchEnabled = YES;
        self.drawColor = [UIColor redColor];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                    name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self.image drawAtPoint:CGPointMake(0.0, 0.0)];
    // Drawing code
}

-(IBAction)crayonPushed:(id)sender
{
    self.isDrawing = YES;
    self.dkvcp.hidden = !self.dkvcp.hidden;
}

-(IBAction)textButtonPushed:(id)sender
{
    self.isDrawing = NO;
    if (self.textField == nil) {
        self.textFieldY = 80.0;
        self.textField = [[ForwardingTextField alloc] initWithFrame:CGRectMake(0.0, self.textFieldY, self.frame.size.width, 40.0)];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.backgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        //self.textField.alpha = 0.4;
        self.textField.textColor = [UIColor whiteColor];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.delegate = self;
        self.textField.multipleTouchEnabled = YES;
        self.textField.exclusiveTouch = NO;
        self.textField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textField];
    }
    if (self.textField.hidden == YES) {
        self.textField.hidden = NO;
    }
    [self.textField becomeFirstResponder];
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.textField.frame = CGRectMake(0.0, self.textFieldY, self.textField.frame
                                      .size.width, self.textField.frame.size.height);
    if ([self.textField.text isEqualToString:@""]) {
        self.textField.hidden = YES;
    }
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard Notification

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.textFieldY = self.textField.frame.origin.y;
    //if text field below keyboard, move it up temporarily
    if (self.textFieldY > (self.frame.size.height - kbSize.height - self.textField.frame.size.height)) {
        self.textField.frame = CGRectMake(0.0, (self.frame.size.height - kbSize.height - self.textField.frame.size.height), self.textField.frame.size.width, self.textField.frame.size.height);
    }
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    /*CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }*/
}

#pragma mark - DKVerticalColorPicker delegate

-(void)colorPicked:(UIColor *)color
{
    self.drawColor = color;
}

#pragma mark - Touch Code

//Following three methods are modified, but based on https://github.com/gianlucatursi/GTImageViewDraw
//Copyright (c) 2014 Gianluca Tursi (http://www.gianlucatursi.com)                                   
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //NSLog(@"touchesBegan");
    CGPoint point = [touch locationInView:self];
    if (self.textField != nil && CGRectContainsPoint(self.textField.frame, point) && !self.textField.hidden) {
        NSLog(@"touched textfield");
        self.isMovingText = YES;
    }
    if(self.isDrawing){
        self.lastPoint = point;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isMovingText) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        self.textFieldY = point.y;
        self.textField.frame = CGRectMake(0.0, point.y, self.textField.frame.size.width, self.textField.frame.size.height);
        [self setNeedsDisplay];
    }
    if(self.isDrawing){
        //NSLog(@"touchmoved");
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
        
        UIGraphicsBeginImageContext(self.frame.size);
        [self.image drawAtPoint:CGPointMake(0.0, 0.0)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [self.drawColor CGColor]);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.lastPoint = currentPoint;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isMovingText) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        self.textFieldY = point.y;
        self.textField.frame = CGRectMake(0.0, point.y, self.textField.frame.size.width, self.textField.frame.size.height);
        [self setNeedsDisplay];
        self.isMovingText = NO;
    }
    if(self.isDrawing){
        //NSLog(@"touchended");
        UIGraphicsBeginImageContext(self.frame.size);
        [self.image drawAtPoint:CGPointMake(0.0, 0.0)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [self.drawColor CGColor]);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setNeedsDisplay];
    }
}

@end
