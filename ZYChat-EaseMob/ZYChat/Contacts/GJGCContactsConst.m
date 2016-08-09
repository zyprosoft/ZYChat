//
//  GJGCContactsConst.m
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCContactsConst.h"

@implementation GJGCContactsConst

+ (NSDictionary *)cellClassToTypeDict
{
    return @{
             @(GJGCContactsContentTypeHeader):@"GJGCContactsHeaderCell",
             @(GJGCContactsContentTypeName):@"GJGCContactsNameCell",
             @(GJGCContactsContentTypeUser):@"GJGCContactsUserCell",
             };
}

+ (NSDictionary *)identiferToTypeDict
{
    return @{
             @"GJGCContactsHeaderCell":@"GJGCContactsHeaderCellIdentifier",
             @"GJGCContactsNameCell":@"GJGCContactsNameCellIdentifier",
             @"GJGCContactsUserCell":@"GJGCContactsUserCellIdentifier",
             };
}

+ (Class)cellClassForContentType:(GJGCContactsContentType)contentType
{
    return NSClassFromString([GJGCContactsConst cellClassToTypeDict][@(contentType)]);
}

+ (NSString *)cellIdentifierForContentType:(GJGCContactsContentType)contentType
{
    NSString *cellClass = [GJGCContactsConst cellClassToTypeDict][@(contentType)];
    return [GJGCContactsConst identiferToTypeDict][cellClass];
}

@end
