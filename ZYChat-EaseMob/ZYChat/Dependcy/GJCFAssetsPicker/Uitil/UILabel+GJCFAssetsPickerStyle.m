//
//  UILabel+GJAssetsPickerStyle.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "UILabel+GJCFAssetsPickerStyle.h"

@implementation UILabel (GJCFAssetsPickerStyle)

- (void)setCommonStyleDescription:(GJCFAssetsPickerCommonStyleDescription *)aDescription
{
    self.textAlignment = NSTextAlignmentCenter;
    
    if (aDescription.hidden) {
        self.hidden = aDescription.hidden;
        return;
    }
    
    if (CGSizeEqualToSize(aDescription.frameSize, CGSizeZero)) {
        self.frame = CGRectMake(0, 0, 100, 35);
    }else{
        self.frame = (CGRect){aDescription.originPoint.x,aDescription.originPoint.y,
            aDescription.frameSize.width,aDescription.frameSize.height};
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.font = aDescription.font;
    self.textColor = aDescription.titleColor;
    self.text = aDescription.title;
}

@end
