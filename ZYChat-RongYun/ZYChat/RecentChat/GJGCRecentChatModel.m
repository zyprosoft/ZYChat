//
//  GJGCRecentChatModel.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCRecentChatModel.h"

@implementation GJGCRecentChatModel

+ (NSAttributedString *)formateName:(NSString *)name
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    stringStyle.font = [UIFont boldSystemFontOfSize:16];
    
    return [[NSAttributedString alloc]initWithString:name attributes:[stringStyle attributedDictionary]];
}

+ (NSAttributedString *)formateTime:(NSString *)time
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
    
    return [[NSAttributedString alloc]initWithString:time attributes:[stringStyle attributedDictionary]];
}

+ (NSAttributedString *)formateContent:(NSString *)content
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return [[NSAttributedString alloc]initWithString:content attributes:[stringStyle attributedDictionary]];
}

@end
