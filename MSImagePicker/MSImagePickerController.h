//
//  MSImagePicker.h
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSImagePickerController;


@protocol MSImagePickerControllerDelegate <UINavigationControllerDelegate>

- (void)MSImagePickerController:(MSImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)MSImagePickerControllerDidCancel:(MSImagePickerController *)picker;

@end


@interface MSImagePickerController : UINavigationController

@property (nonatomic, weak) id<MSImagePickerControllerDelegate> delegate;

- (void)cancelImagePicker;

@end
