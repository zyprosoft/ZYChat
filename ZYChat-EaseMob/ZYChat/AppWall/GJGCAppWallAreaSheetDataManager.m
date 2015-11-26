//
//  GJGCAppWallAreaSheetDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/26.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCAppWallAreaSheetDataManager.h"

@implementation GJGCAppWallAreaSheetDataManager

- (void)requestContentList
{
    NSDictionary *areDict = [self areaDict];
    for (NSString *name in areDict.allKeys) {
        
        BTActionSheetBaseContentModel *item = [[BTActionSheetBaseContentModel alloc]init];
        item.simpleText = name;
        item.userInfo = @{
                          @"name":name,
                          @"data":areDict[name],
                          };
        
        [self addContentModel:item];
    }
    
    [self.delegate dataManagerRequireRefresh:self];
}

- (NSDictionary *)areaDict
{
    return @{
             @"中国":@"cn",
             @"台湾":@"tw",
             @"香港":@"hk",
             @"美国":@"us",
             @"日本":@"jp",
             @"韩国":@"kr",
             };
}

@end
