//
//  GJGCCreateGroupConst.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
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
             
             @(GJGCCreateGroupContentTypeGroupType) : @"GJGCCreateGroupDetailChooseCell",

             @(GJGCCreateGroupContentTypeDescription) : @"GJGCCreateGroupDetailChooseCell",
             
             @(GJGCCreateGroupContentTypeHeadThumb) : @"GJGCCreateGroupDetailChooseCell",
             
             @(GJGCCreateGroupContentTypeAddress) : @"GJGCCreateGroupDetailChooseCell",

             @(GJGCCreateGroupContentTypeCompany) : @"GJGCCreateGroupInputTextCell",

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

+ (NSString *)levelForGroupMemberCount:(NSInteger )groupMemberCount
{
    NSInteger memberCount = groupMemberCount;
    
    NSString *level = @"1";
    if (memberCount > 0 && memberCount <= 200) {
        
        level = @"1";
    }
    
    if (memberCount > 200 && memberCount <= 400) {
        
        level = @"2";
    }
    
    if (memberCount > 500 && memberCount <= 700) {
        
        level = @"3";
        
    }
    
    if (memberCount > 700 && memberCount <= 1000) {
        
        level = @"4";
    }
    
    return level;
}

@end
