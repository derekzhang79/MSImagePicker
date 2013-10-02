//
//  MSImagePicker.m
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import "MSImagePickerController.h"
#import "MSAlbumViewController.h"

@implementation MSImagePickerController


- (id)init
{
    return [self initWithRootViewController:nil];
}


- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    MSAlbumViewController *albumController = [[MSAlbumViewController alloc] initWithStyle:UITableViewStylePlain];
    return [super initWithRootViewController:albumController];
}


- (void)cancelImagePicker
{
    if ([self.delegate respondsToSelector:@selector(MSImagePickerControllerDidCancel:)]) {
        [self.delegate MSImagePickerControllerDidCancel:self];
    }
}



@end
