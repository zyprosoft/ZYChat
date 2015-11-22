//
//  GJGCInfoBaseListConst.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCInfoBaseListConst.h"

@implementation GJGCInfoBaseListConst

+ (NSDictionary *)contentTypeToCellDict
{
    return @{
             @(GJGCInfoBaseListContentTypeUserRole):@"GJGCInfoUserRoleContentCell",
             @(GJGCInfoBaseListContentTypeGroupRole):@"GJGCInfoGroupRoleContentCell",
             };
}

+ (NSDictionary *)cellClassToIdentifierDict
{
    return @{
             @"GJGCInfoUserRoleContentCell":@"GJGCInfoUserRoleContentCellIdentifier",
             @"GJGCInfoGroupRoleContentCell":@"GJGCInfoGroupRoleContentCellIdentifier",
             };
}


+ (Class)cellClassForContentType:(GJGCInfoBaseListContentType)contentType
{
    NSString *className = [[GJGCInfoBaseListConst contentTypeToCellDict]objectForKey:@(contentType)];
    
    return NSClassFromString(className);
}

+ (NSString *)cellIdentifierForContentType:(GJGCInfoBaseListContentType)contentType
{
    NSString *className = [[GJGCInfoBaseListConst contentTypeToCellDict]objectForKey:@(contentType)];

    return [[GJGCInfoBaseListConst cellClassToIdentifierDict]objectForKey:className];
}

@end
