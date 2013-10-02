//
//  MSImageViewController.m
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import "MSImageViewController.h"


#pragma mark -
#pragma Image View Cell
@interface ImageViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@end


@implementation ImageViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end


#pragma mark -
#pragma Photo View Controller
@interface MSImageViewController () {
    NSMutableArray *_assets;
}

- (void)loadPhotos;

@end


@implementation MSImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select Photos";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneAction)];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentifier"];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(12.0f, 4.0f, 12.0f, 4.0f);
    layout.itemSize = CGSizeMake(75.0f, 75.0f);
    layout.minimumInteritemSpacing = 4.0f;
    layout.minimumLineSpacing = 4.0f;
    
    [self loadPhotos];
}


- (void)loadPhotos
{
    _assets = [[NSMutableArray alloc] init];
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse
                                      usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result == nil) {
            return;
        }
        
        [_assets addObject:result];
    }];
    
    [self.collectionView reloadData];
}


- (void)doneAction
{
    NSLog(@"done action");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - 
#pragma Collection View Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PhotoCellIdentifier = @"PhotoCellIdentifier";
    ImageViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                                                         forIndexPath:indexPath];
    ALAsset *asset = [_assets objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select %@", indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"unselect %@", indexPath);
}



@end
