//
//  MSAlbumViewController.m
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import "MSAlbumViewController.h"
#import "MSImagePickerController.h"
#import "MSImageViewController.h"
#import "MSTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MSAlbumViewController () {
    ALAssetsLibrary *_assetsLibrary;
    NSMutableArray *_albums;
}

- (void)loadAlbums;

@end


@implementation MSAlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MSImagePickerController *picker = (MSImagePickerController *)self.navigationController;

    self.navigationItem.title = @"Album";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:picker
                                                                                           action:@selector(cancelImagePicker)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadAlbums];
}


- (void)loadAlbums
{
    _albums = [[NSMutableArray alloc] init];
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group == nil) {
            return;
        }
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];

        [_albums addObject:group];
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        NSString *msg = [NSString stringWithFormat:@"Album Error: %@ - %@",
                         [error localizedDescription],
                         [error localizedRecoverySuggestion]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}


#pragma mark -
#pragma Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albums.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AlbumCellIdentifier = @"AlbumCellIdentifier";
    
    MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumCellIdentifier];
    if (cell == nil) {
        cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AlbumCellIdentifier];
    }
    
    ALAssetsGroup *group = [_albums objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%ld", group.numberOfAssets];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[_albums objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}


#pragma mark -
#pragma Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = [_albums objectAtIndex:indexPath.row];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    MSImageViewController *controller = [[MSImageViewController alloc] initWithCollectionViewLayout:layout];
    controller.assetsGroup = group;
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end









