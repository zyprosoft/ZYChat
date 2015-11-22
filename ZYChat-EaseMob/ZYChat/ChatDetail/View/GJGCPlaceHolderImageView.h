//
//  GJGCPlaceHolderImageView.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/7/7.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCPlaceHolderImageView : UIImageView

@property (nonatomic,strong)UIImageView *blankImageView;

- (void)setBlankSize:(CGSize)size;

@end
