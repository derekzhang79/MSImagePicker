//
//  MSImageViewController.h
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MSImageViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) UIImage *selectionImage;

@end
