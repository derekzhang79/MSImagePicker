//
//  MSMultiImageView.h
//  MSMultiImageView
//
//  Created by Peng Gu on 10/4/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MSMultiImageView;


@protocol MSMultiImageViewDelegate <NSObject>

- (void)MSMultiImageView:(MSMultiImageView *)imageView
       didScrollFromPage:(NSUInteger)prevIndex
                  ToPage:(NSUInteger)currIndex;

@end


@interface MSMultiImageView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL hidePageControl;
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, assign) NSUInteger spacing;
@property (nonatomic, strong, readwrite) NSArray *images;
@property (nonatomic, strong, readonly) NSArray *imageViews;

@property (nonatomic, weak) id<MSMultiImageViewDelegate> delegate;

- (id)initWithImages:(NSArray *)images;

@end
