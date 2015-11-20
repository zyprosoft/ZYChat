//
//  GJGCCreateGroupConst.m
//  ZYChat
//
//  Created by ZYVincent on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCCreateGroupConst.h"

@implementation GJGCCreateGroupConst


+ (NSDictionary *)contentTypeToClass
{
    return @{
             @(GJGCCreateGroupContentTypeLocation) : @"GJGCCreateGroupDetailChooseCell",
             
             @(GJGCCreateGroupContentTypeSubject) : @"GJGCCreateGroupInputTextCell",
             
             @(GJGCCreateGroupContentTypeLabels) : @"GJGCCreateGroupDetailChooseCell",
             
             @(GJGCCreateGroupContentTypeMemberCount) : @"GJGCCreateGroupDetailChooseCell",

             @(GJGCCreateGroupContentTypeDescription) : @"GJGCCreateGroupDetailChooseCell",
             
             @(GJGCCreateGroupContentTypeHeadThumb) : @"GJGCCreateGroupDetailChooseCell",
             
             @(GJGCCreateGroupContentTypeAddress) : @"GJGCCreateGroupInputTextCell",

             };
    
}

+ (NSDictionary *)classToIdentifier
{
    return @{
             
             @"GJGCCreateGroupDetailChooseCell" : @"GJGCCreateGroupDetailChooseCellIdentifier",
             
             @"GJGCCreateGroupInputTextCell" : @"GJGCCreateGroupInputTextCellIdentifier",
             
             };
}

+ (Class)cellClassForContentType:(GJGCCreateGroupContentType )contentType
{
    NSString *className = [[GJGCCreateGroupConst contentTypeToClass] objectForKey:@(contentType)];
    
    return NSClassFromString(className);
}

+ (NSString *)cellIdentifierForContentType:(GJGCCreateGroupContentType)contentType
{
    NSString *className = [[GJGCCreateGroupConst contentTypeToClass] objectForKey:@(contentType)];
    
    return [[GJGCCreateGroupConst classToIdentifier] objectForKey:className];
}

@end
