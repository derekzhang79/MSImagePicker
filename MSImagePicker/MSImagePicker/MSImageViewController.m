//
//  MSImageViewController.m
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import "MSImageViewController.h"
#import "MSImagePickerController.h"

#pragma mark -
#pragma Image View Cell
@interface ImageViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *overlayImageView;

@end


@implementation ImageViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }
    return self;
}


- (void)setOverlayImageView:(UIImageView *)overlayImageView
{
    if (overlayImageView == nil) {
        [self.overlayImageView removeFromSuperview];
    }
    else {
        _overlayImageView = overlayImageView;
        [self.imageView addSubview:overlayImageView];
    }
}

@end


#pragma mark -
#pragma Photo View Controller
@interface MSImageViewController () {
    NSMutableArray *_assets;
    NSMutableArray *_selectedAssets;
}

- (void)loadPhotos;
- (void)finishPickingMedia;
- (NSDictionary *)makeMediaInfoWithAsset:(ALAsset *)asset;

@end


@implementation MSImageViewController

static NSString *PhotoCellIdentifier = @"PhotoCellIdentifier";

- (UIImage *)selectionImage
{
    if (!_selectionImage) {
        _selectionImage = [UIImage imageNamed:@"overlay"];
    }
    return _selectionImage;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Photos";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(finishPickingMedia)];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(12.0f, 4.0f, 12.0f, 4.0f);
    layout.itemSize = CGSizeMake(75.0f, 75.0f);
    layout.minimumInteritemSpacing = 4.0f;
    layout.minimumLineSpacing = 4.0f;
    
    _assets = [[NSMutableArray alloc] init];
    _selectedAssets = [[NSMutableArray alloc] init];
    [self loadPhotos];
}


- (void)loadPhotos
{
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse
                                      usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            [_assets addObject:result];
        }
    }];
    
    [self.collectionView reloadData];
}


- (void)finishPickingMedia
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (ALAsset *asset in _selectedAssets) {
        [returnArray addObject:[self makeMediaInfoWithAsset:asset]];
    }

    MSImagePickerController *picker = (MSImagePickerController *)self.navigationController;
    if (picker.delegate &&
        [picker.delegate respondsToSelector:@selector(MSImagePickerController:didFinishPickingMediaWithInfo:)]) {
        [picker.delegate MSImagePickerController:picker didFinishPickingMediaWithInfo:returnArray];
    }
}


- (NSDictionary *)makeMediaInfoWithAsset:(ALAsset *)asset
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    
    UIImage *img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage
                                       scale:[[UIScreen mainScreen] scale]
                                 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
    info[UIImagePickerControllerOriginalImage] = img;
    info[UIImagePickerControllerMediaType] = [asset valueForProperty:ALAssetPropertyType];
    info[UIImagePickerControllerReferenceURL] = [asset valueForProperty:ALAssetPropertyAssetURL];
    
    return info;
}


#pragma mark -
#pragma Collection View Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                                                         forIndexPath:indexPath];
    ALAsset *asset = [_assets objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = (ImageViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.overlayImageView = [[UIImageView alloc] initWithImage:self.selectionImage];
    
    ALAsset *asset = [_assets objectAtIndex:indexPath.row];
    [_selectedAssets addObject:asset];
    
    MSImagePickerController *picker = (MSImagePickerController *)self.navigationController;
    if (picker.delegate &&
        [picker.delegate respondsToSelector:@selector(MSImagePickerController:didSelectMediaWithInfo:)]) {
        [picker.delegate MSImagePickerController:picker didSelectMediaWithInfo:[self makeMediaInfoWithAsset:asset]];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = (ImageViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell.overlayImageView removeFromSuperview];

    ALAsset *asset = [_assets objectAtIndex:indexPath.row];
    [_selectedAssets removeObject:asset];
    
    MSImagePickerController *picker = (MSImagePickerController *)self.navigationController;
    if (picker.delegate &&
        [picker.delegate respondsToSelector:@selector(MSImagePickerController:didDeselectMediaWithInfo:)]) {
        [picker.delegate MSImagePickerController:picker didDeselectMediaWithInfo:[self makeMediaInfoWithAsset:asset]];
    }
}



@end
