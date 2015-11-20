//
//  GJGCCreateGroupLabelsSheetDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCCreateGroupLabelsSheetDataManager.h"

@implementation GJGCCreateGroupLabelsSheetDataManager

- (void)requestContentList
{
    for (NSString *label in [self labelsArray]) {
        
        BTActionSheetBaseContentModel *contentModel = [[BTActionSheetBaseContentModel alloc]init];
        contentModel.simpleText = label;
        contentModel.userInfo = @{
                                  @"data":label,
                                  };
        [self addContentModel:contentModel];
    }
    [self.delegate dataManagerRequireRefresh:self];
}

- (NSArray *)labelsArray
{
    return @[
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             @"纯技术 宅男 动漫",
             ];
}

@end
