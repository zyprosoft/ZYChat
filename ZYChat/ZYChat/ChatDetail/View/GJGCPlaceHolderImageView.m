//
//  GJGCPlaceHolderImageView.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/7.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCPlaceHolderImageView.h"

@implementation GJGCPlaceHolderImageView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.blankImageView = [[UIImageView alloc]init];
        [self addSubview:self.blankImageView];
        
    }
    return self;
}

- (void)setBlankSize:(CGSize)size
{
    self.blankImageView.gjcf_size = size;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.blankImageView.gjcf_centerX = self.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.gjcf_height/2;
}

@end
