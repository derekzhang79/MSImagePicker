//
//  MSTableViewCell.m
//  MSImagePicker
//
//  Created by Peng Gu on 10/2/13.
//  Copyright (c) 2013 Peng Gu. All rights reserved.
//

#import "MSTableViewCell.h"

@implementation MSTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // customize the position of imageview
    self.imageView.frame = CGRectMake( 10, 10, 75, 75 );
}

@end
