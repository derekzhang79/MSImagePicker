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
#import <AssetsLibrary/AssetsLibrary.h>


#pragma mark -
#pragma Table View Cell

@interface MSTableViewCell : UITableViewCell
@end

@implementation MSTableViewCell
- (void)layoutSubviews
{
    [super layoutSubviews];
    // customize the position of imageview
    self.imageView.frame = CGRectMake( 10, 10, 75, 75 );
}

@end


#pragma mark -
#pragma Album View Controller

#define DEFAULT_ROW_HEIGHT 95.0f

@interface MSAlbumViewController () {
    ALAssetsLibrary *_assetsLibrary;
    NSMutableArray *_albums;
}

- (void)loadAlbums;
- (void)cancelPickingMedia;

@end


@implementation MSAlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Album";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(cancelPickingMedia)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = DEFAULT_ROW_HEIGHT;
    
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
        MSImagePickerController *picker = (MSImagePickerController *)self.navigationController;
        if (picker.delegate &&
            [picker.delegate respondsToSelector:@selector(MSImagePickerController:didFailAccessingALAssetsLibraryWithError:)]) {
            [picker.delegate MSImagePickerController:picker didFailAccessingALAssetsLibraryWithError:error];
        }
    }];
}


- (void)cancelPickingMedia
{
    [self dismissViewControllerAnimated:YES completion:^{
        MSImagePickerController *picker = (MSImagePickerController *)self.navigationController;
        if (picker.delegate &&
            [picker.delegate respondsToSelector:@selector(MSImagePickerControllerDidCancel:)]) {
            [picker.delegate MSImagePickerControllerDidCancel:picker];
        }
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


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    MSImageViewController *controller = [[MSImageViewController alloc] initWithCollectionViewLayout:layout];
    
    controller.assetsGroup = [_albums objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end









