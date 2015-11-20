//
//  GJGCCreateGroupMemberCountSheetDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCCreateGroupMemberCountSheetDataManager.h"

@implementation GJGCCreateGroupMemberCountSheetDataManager

- (void)requestContentList
{
    for (NSString *count in [self countArray]) {
        
        BTActionSheetBaseContentModel *contentModel = [[BTActionSheetBaseContentModel alloc]init];
        contentModel.simpleText = count;
        contentModel.userInfo = @{
                                  @"data":count,
                                  };
        [self addContentModel:contentModel];
    }
    [self.delegate dataManagerRequireRefresh:self];
}

- (NSArray *)countArray
{
    return @[
             @"100",
             @"200",
             @"300",
             @"400",
             @"500",
             @"600",
             @"700",
             @"800",
             @"900",
             @"1000",
             ];
}

@end
