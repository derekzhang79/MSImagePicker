//
//  MSViewController.h
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSImagePickerController.h"

@interface MSViewController : UIViewController <MSImagePickerControllerDelegate>

- (IBAction)launchImagePicker:(id)sender;

@end
