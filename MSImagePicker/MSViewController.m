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
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)launchImagePicker:(id)sender
{
    MSImagePickerController *picker = [[MSImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


- (void)MSImagePickerControllerDidCancel:(MSImagePickerController *)picker
{
    NSLog(@"image picker controller did cancel");
}


- (void)MSImagePickerController:(MSImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    for (NSDictionary *dict in info) {
        NSLog(@"%@", dict);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
