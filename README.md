# DKPhotoCapture
A camera capture class like UIImagePickerController that also allows for scribbles and overlayed text. DKPhotoCapture is a replacement for using UIImagePickerController to capture photos with an iOS device's built-in cameras. The interface is presented as two views: the first for capturing with controls for flash & front vs rear camera; and the second for scribbling (in any color) on the image and adding text to it in a vein similar to SnapChat.

![DKPhotoCapture1](https://raw.githubusercontent.com/davecom/DKPhotoCapture/master/dkphotocapture1.png)
![DKPhotoCapture2](https://raw.githubusercontent.com/davecom/DKPhotoCapture/master/dkphotocapture2.png)

## Todo
* This is an initial open sourcing and still lacks some polish
* Documentation
* Better Commenting
* Clean-up code
* Better modularize

## Features
* Uses the same delegate (`UIImagePickerControllerDelegate`) as `UIImagePickerController`
* Scribbling on captured images and picking colors similar to SnapChat
* Adding SnapChat like text to captured images

## Installation
No Cocoapod yet. Your project will need the following files:
* `DKEditorView.h` & `DKEditorView.m`
* `DKPhotoCapture.h` & `DKPhotoCapture.m`
* `DKVerticalColorPicker.h` & `DKVerticalColorPicker.m` (DKVerticalColorPicker)[https://github.com/davecom/DKVerticalColorPicker]
* `ForwardingTextField.h` & `ForwardingTextField.m`
* `UIImage+Scale.h` & `UIImage+Scale.m`
* `DKImageEdit.xib`
* `DKImagePickerOverlay.xib`

## Usage
Import `DKPhotoCapture.h`. Create a new `DKPhotoCapture` using `initWithDelegate:` passing an object that conforms to `UIImagePIckerControllerDelegate`. Call `showPickerOnViewController:` to actually display DKPhotoCapture. Get the resulting image with the key `UIImagePickerControllerOriginalImage` from the info NSDictionary in the delegate method `imagePIckerController: didFinishPickingMediaWithInfo:`.

## License and Authorship
Released under the MIT License.  Copyright 2015 David Kopec. Please open issues on GitHub.
