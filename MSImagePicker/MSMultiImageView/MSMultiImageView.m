//
//  MSMultiImageView.m
//  MSMultiImageView
//
//  Created by Peng Gu on 10/4/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import "MSMultiImageView.h"

#define DEFAULT_SPACING 4

@interface MSMultiImageView () {
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    NSArray *_imageViews;           // Array of image views
    
    NSUInteger _prevIndex;
    CGFloat _draggingBeginScrollViewOffsetX;
}

- (void)setupScrollView;
- (void)setupImageViews;
- (void)setupPageControl;

@end


@implementation MSMultiImageView

#pragma mark - 
#pragma mark - Init methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupScrollView];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScrollView];
    }
    return self;
}


- (id)initWithImages:(NSArray *)images
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.images = images;
    }
    return self;
}


#pragma mark -
#pragma mark - Properties
- (void)setImages:(NSArray *)images
{
    for (id img in images) {
        if ([img isKindOfClass:[UIImage class]] ) {
            continue;
        }
        
        NSException *exception = [NSException exceptionWithName:@"InvalidValueException"
                                                         reason:@"Contain Non UIImage objects in images"
                                                       userInfo:nil];
        @throw exception;
    }
    
    _prevIndex = _index = 0;
    _images = images;
    
    [self setupImageViews];
    [self setupPageControl];
}


- (void)setHidePageControl:(BOOL)hidePageControl
{
    _hidePageControl = hidePageControl;
    [self setupPageControl];
}


- (NSUInteger)spacing
{
    if (!_spacing) {
        _spacing = DEFAULT_SPACING;
    }
    return _spacing;
}


#pragma mark -
#pragma mark - Private Setup Methods
- (void)setupScrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.pagingEnabled = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.delegate = self;
    }
    
    [self addSubview:_scrollView];
}


- (void)setupImageViews
{
    if (!_images || _images.count == 0) {
        return;
    }
    
    CGFloat imageviewMaxWidth = _scrollView.frame.size.width - 2 * self.spacing;
    CGSize contentSize = CGSizeMake(self.spacing, _scrollView.frame.size.height);
    
    NSMutableArray *imageViews = [[NSMutableArray alloc] initWithCapacity:_images.count];
    for (UIImage *image in _images) {
        // calculate the width of this image view
        CGFloat ratio = image.size.width / image.size.height;
        CGFloat width = floor(contentSize.height * ratio);
        if (width > imageviewMaxWidth) {
            width = imageviewMaxWidth;
        }
        
        // make the view for this image
        CGRect frame = CGRectMake(contentSize.width, 0, width, contentSize.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        [imageViews addObject:imageView];
        [_scrollView addSubview:imageView];
        
        contentSize.width += width + self.spacing;
    }
    
    _imageViews = imageViews;
    _scrollView.contentSize = contentSize;
}


- (void)setupPageControl
{
    if (self.hidePageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
        return;
    }
    
    if ( ! _pageControl) {
        CGRect frame = CGRectMake(0, self.frame.size.height - 37.0f, self.frame.size.width, 37.0f);
        _pageControl = [[UIPageControl alloc] initWithFrame:frame];
    }
    
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = self.images.count;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    
    [self addSubview:_pageControl];
}


#pragma mark -
#pragma mark - Scroll View Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _draggingBeginScrollViewOffsetX = scrollView.contentOffset.x;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = *targetContentOffset;
    if (targetOffset.x <= 0 || targetOffset.x >= _scrollView.contentSize.width) {
        return;
    }
    
    for (NSUInteger i=0; i<_imageViews.count; i++) {
        UIImageView *imageView = _imageViews[i];
        CGFloat imageOffsetX = imageView.frame.origin.x + imageView.frame.size.width / 2;
        
        if (imageOffsetX >= targetOffset.x) {
            targetOffset = imageView.frame.origin;
            targetOffset.x -= self.spacing;
            
            // if scroll to the last imageview, adjust the targetOffset
            if (i == _imageViews.count - 1) {
                targetOffset.x = scrollView.contentSize.width - scrollView.frame.size.width;
            }
            
            *targetContentOffset = targetOffset;
            
            _prevIndex = _index;
            _index = i;
            _pageControl.currentPage = i;
            
            return;
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(MSMultiImageView:didScrollFromPage:ToPage:)]) {
        [self.delegate MSMultiImageView:self didScrollFromPage:_prevIndex ToPage:_index];
    }
}


@end
