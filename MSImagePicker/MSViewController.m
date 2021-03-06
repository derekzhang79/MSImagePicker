//
//  MSViewController.m
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import "MSViewController.h"
#import "MSImagePickerController.h"


@implementation MSViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)launchImagePicker:(id)sender
{
    
    MSImagePickerController *picker = [[MSImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)MSImagePickerControllerDidCancel:(MSImagePickerController *)picker
{
    NSLog(@"image picker controller did cancel");
}


- (void)MSImagePickerController:(MSImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:info.count];
    for (NSDictionary *dict in info) {
        UIImage *image = [dict valueForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
    }

    [self dismissViewControllerAnimated:YES completion:^{
        self.imageView.images = images;
    }];
}


- (void)MSImagePickerController:(MSImagePickerController *)picker didFailAccessingALAssetsLibraryWithError:(NSError *)error
{
    NSLog(@"did fail accesing asset library: %@", error.localizedFailureReason);
}


- (void)MSImagePickerController:(MSImagePickerController *)picker didSelectMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"selected %@", info);
}


- (void)MSImagePickerController:(MSImagePickerController *)picker didDeselectMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Deselected %@", info);
}



@end
