//
//  GJGCPlaceHolderImageView.h
//  ZYChat
//
//  Created by ZYVincent on 15/7/7.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCPlaceHolderImageView : UIImageView

@property (nonatomic,strong)UIImageView *blankImageView;

- (void)setBlankSize:(CGSize)size;

@end
