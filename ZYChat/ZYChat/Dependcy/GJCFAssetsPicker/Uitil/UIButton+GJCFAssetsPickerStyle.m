//
//  UIButton+GJAssetsPickerStyle.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "UIButton+GJCFAssetsPickerStyle.h"

@implementation UIButton (GJCFAssetsPickerStyle)

- (void)setCommonStyleDescription:(GJCFAssetsPickerCommonStyleDescription *)aDescription
{
    //是否需要隐藏
    if (aDescription.hidden) {
        self.hidden = aDescription.hidden;
        return;
    }
    
    UIImage *cancelBtnNormal = aDescription.normalStateImage;
    
    //坐标点
    CGPoint originPoint = aDescription.originPoint;
    
    //frame
    if (cancelBtnNormal) {
        self.frame = (CGRect){originPoint.x,originPoint.y,cancelBtnNormal.size.width,cancelBtnNormal.size.height};
    }else{
        if (CGSizeEqualToSize(aDescription.frameSize, CGSizeZero)) {
            
            self.frame = CGRectMake(originPoint.x, originPoint.y, 40, 20);
            
        }else{
            
            self.frame = (CGRect){originPoint.x,originPoint.y,aDescription.frameSize.width,aDescription.frameSize.height};
            
        }
    }
    
    //状态图片
    [self setBackgroundImage:cancelBtnNormal forState:UIControlStateNormal];
    [self setBackgroundImage:aDescription.selectedStateImage forState:UIControlStateSelected];
    [self setBackgroundImage:aDescription.highlightStateImage forState:UIControlStateHighlighted];
    
    //标题
    if (aDescription.normalStateTitle) {
        [self setTitle:aDescription.normalStateTitle forState:UIControlStateNormal];
    }else{
        if (aDescription.title) {
            [self setTitle:aDescription.title forState:UIControlStateNormal];
        }
    }
    
    //标题状态颜色
    [self setTitle:aDescription.selectedStateTitle forState:UIControlStateSelected];
    [self setTitleColor:aDescription.normalStateTextColor forState:UIControlStateNormal];
    [self setTitleColor:aDescription.highlightStateTextColor forState:UIControlStateHighlighted];
    [self setTitleColor:aDescription.selectedStateTextColor forState:UIControlStateSelected];
     self.titleLabel.font = aDescription.font;
}

@end
