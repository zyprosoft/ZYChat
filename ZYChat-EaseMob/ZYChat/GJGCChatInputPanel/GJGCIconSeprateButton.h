//
//  GJGCIconSeprateButton.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-26.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCIconSeprateImageView.h"

@class GJGCIconSeprateButton;
typedef void (^GJGCIconSeprateButtonDidTapedBlock) (GJGCIconSeprateButton *button);

@interface GJGCIconSeprateButton : UIView

@property (nonatomic,strong)UIButton *backButton;

@property (nonatomic,strong)GJGCIconSeprateImageView *iconView;

@property (nonatomic,getter=isSelected)BOOL selected;

@property (nonatomic,copy)GJGCIconSeprateButtonDidTapedBlock tapBlock;

- (instancetype)initWithFrame:(CGRect)frame withSelectedIcon:(UIImage *)selectIcon withNormalIcon:(UIImage *)normalIcon;

/**
 *  选中态图片
 */
@property (nonatomic,strong)UIImage *selectedStateImage;

/**
 *  常态图片
 */
@property (nonatomic,strong)UIImage *normalStateImage;

@end
