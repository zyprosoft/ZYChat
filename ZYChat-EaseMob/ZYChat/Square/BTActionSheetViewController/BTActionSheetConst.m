//
//  BTActionSheetConst.m
//  ZYChat
//
//  Created by ZYVincent on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "BTActionSheetConst.h"

@implementation BTActionSheetConst

+ (NSDictionary *)contentTypeToClass
{
    
    return @{
             @(BTActionSheetContentTypeSimpleText) : @"BTActionSheetSimpleTextCell",
             
             @(BTActionSheetContentTypeNameAndDetail) : @"BTActionSheetNameAndDetailCell",
             
             };
    
}

+ (NSDictionary *)classToIdentifier
{
    return @{
             
             @"BTActionSheetSimpleTextCell" : @"BTActionSheetSimpleTextCellIdentifier",
             
             @"BTActionSheetNameAndDetailCell" : @"BTActionSheetNameAndDetailCellIdentifier",
             
             };
}
+ (Class)cellClassForContentType:(BTActionSheetContentType )contentType
{
    NSString *className = [[BTActionSheetConst contentTypeToClass] objectForKey:@(contentType)];
    
    return NSClassFromString(className);
}

+ (NSString *)cellIdentifierForContentType:(BTActionSheetContentType)contentType
{
    NSString *className = [[BTActionSheetConst contentTypeToClass] objectForKey:@(contentType)];
    
    return [[BTActionSheetConst classToIdentifier] objectForKey:className];
}

@end
