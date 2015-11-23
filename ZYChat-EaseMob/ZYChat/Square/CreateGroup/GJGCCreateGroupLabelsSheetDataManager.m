//
//  GJGCCreateGroupLabelsSheetDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
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
             @"纯技术   宅男    动漫",
             @"80后   90初   老思想",
             @"篮球   运动   户外",
             @"极客   创业   奋斗",
             @"奔3   奔4   奔5",
             @"汽车   山地车   老爷车",
             @"废弃   凋谢   没落",
             @"低迷   巅峰   陨落",
             @"网游   CS   LOL",
             @"GitHub   cocoa  ZYProSoft",
             ];
}

@end
