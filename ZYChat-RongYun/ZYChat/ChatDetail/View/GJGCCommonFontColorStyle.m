//
//  GJGCCommonColorStyle.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCCommonFontColorStyle.h"

@implementation GJGCCommonFontColorStyle

#pragma mark - 导航栏

+ (UIFont *)navigationBarTitleViewFont
{
    return [UIFont boldSystemFontOfSize:19];
}

+ (UIFont *)navigationBarItemFont
{
    return [UIFont boldSystemFontOfSize:16];
}

+ (UIColor *)navigationBarTitleColor
{
    return [UIColor whiteColor];
}

#pragma mark - 详情大标题

+ (UIFont *)detailBigTitleFont
{
    return [UIFont systemFontOfSize:16];
}

+ (UIColor *)detailBigTitleColor
{
    return GJCFQuickRGBColor(38, 38, 38);
}

#pragma mark - 全局字号 列表标题 详情正文

+ (UIFont *)listTitleAndDetailTextFont
{
    return [UIFont systemFontOfSize:14];
}

+ (UIColor *)listTitleAndDetailTextColor
{
    return [GJGCCommonFontColorStyle detailBigTitleColor];
}

#pragma mark - 基本字号 标题下的辅助文字

+ (UIFont *)baseAndTitleAssociateTextFont
{
    return [UIFont systemFontOfSize:12];
}

+ (UIColor *)baseAndTitleAssociateTextColor
{
    return GJCFQuickRGBColor(153, 153, 153);
}

#pragma mark - 主题色彩  辅助色彩  页面底色

+ (UIColor *)mainThemeColor
{
    return GJCFQuickHexColor(@"13a2dd");
}

+ (UIColor *)mainAssociateColor
{
    return GJCFQuickRGBColor(255, 114, 0);
}

+ (UIColor *)mainBackgroundColor
{
    return GJCFQuickRGBColor(242, 242, 242);
}

#pragma mark - 点击态

+ (UIColor *)tapHighlightColor
{
    return GJCFQuickRGBColor(229, 229, 229);
}

#pragma mark - 分割线

+ (UIColor *)mainSeprateLineColor
{
    return GJCFQuickRGBColor(216, 216, 216);
}

#pragma mark - 男士 女士 年龄颜色

+ (UIColor *)manAgeColor
{
    return GJCFQuickHexColor(@"7ecef4");
}

+ (UIColor *)womenAgeColor
{
    return GJCFQuickHexColor(@"ffa9c5");
}

#pragma mark - 返回一个箭头view
+ (UIImageView*)accessoryIndicatorView
{
    UIImageView *res = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"按钮箭头"]];
    res.frame = CGRectMake(0, 0, 7, 12);
    return res;
}

@end
