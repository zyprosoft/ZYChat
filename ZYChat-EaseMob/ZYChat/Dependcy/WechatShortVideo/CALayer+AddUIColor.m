//
//  CALayer+AddUIColor.m
//  SCRecorderPack
//
//  Created by AliThink on 15/8/17.
//  Copyright (c) 2015年 AliThink. All rights reserved.
//

#import "CALayer+AddUIColor.h"


@implementation CALayer (AddUIColor)

- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
