//
//  GJGCCommonAttributedStringStyle.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14/11/25.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCCommonAttributedStringStyle.h"

@implementation GJGCCommonAttributedStringStyle

+ (NSAttributedString *)getGroupAttributedString:(NSString *)content;
{
    GJCFCoreTextAttributedStringStyle *style = [[GJCFCoreTextAttributedStringStyle alloc] init];
    style.font = [UIFont systemFontOfSize:10];
    style.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    
    
    return [[NSAttributedString alloc]initWithString:content attributes:[style attributedDictionary]];
}


+ (NSAttributedString *)getGroupTypeAttributedString:(NSString *)content;
{
    GJCFCoreTextAttributedStringStyle *style = [[GJCFCoreTextAttributedStringStyle alloc] init];
    style.font = [UIFont systemFontOfSize:10];
    style.foregroundColor = GJCFQuickHexColor(@"ffffff");
    
    
    return [[NSAttributedString alloc]initWithString:content attributes:[style attributedDictionary]];
}


+ (NSAttributedString *)getFolksTypeAttributedString:(NSString *)content;
{
    GJCFCoreTextAttributedStringStyle *style = [[GJCFCoreTextAttributedStringStyle alloc] init];
    style.font = [UIFont systemFontOfSize:11];
    style.foregroundColor = GJCFQuickHexColor(@"ffffff");
    
    
    return [[NSAttributedString alloc]initWithString:content attributes:[style attributedDictionary]];
}
@end
