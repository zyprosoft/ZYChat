//
//  BTActionSheetBaseContentModel.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetBaseContentModel.h"

@implementation BTActionSheetBaseContentModel

- (instancetype)init
{
    if (self = [super init]) {
        
        self.contentHeight = 44.f;
    }
    return self;
}

- (BOOL)isEqual:(BTActionSheetBaseContentModel *)object
{
    return [self.userInfo isEqual:object.userInfo];
}

@end
