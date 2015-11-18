//
//  GJGCCommonColorStyle.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCCommonFontColorStyle : NSObject

#pragma mark - 导航栏

+ (UIFont *)navigationBarTitleViewFont;

+ (UIFont *)navigationBarItemFont;

+ (UIColor *)navigationBarTitleColor;

#pragma mark - 详情大标题

+ (UIFont *)detailBigTitleFont;

+ (UIColor *)detailBigTitleColor;

#pragma mark - 全局字号 列表标题 详情正文

+ (UIFont *)listTitleAndDetailTextFont;

+ (UIColor *)listTitleAndDetailTextColor;

#pragma mark - 基本字号 标题下的辅助文字

+ (UIFont *)baseAndTitleAssociateTextFont;

+ (UIColor *)baseAndTitleAssociateTextColor;

#pragma mark - 主题色彩  辅助色彩  页面底色

+ (UIColor *)mainThemeColor;

+ (UIColor *)mainAssociateColor;

+ (UIColor *)mainBackgroundColor;

#pragma mark - 点击态

+ (UIColor *)tapHighlightColor;

#pragma mark - 分割线

+ (UIColor *)mainSeprateLineColor;

#pragma mark - 男士 女士 年龄颜色

+ (UIColor *)manAgeColor;

+ (UIColor *)womenAgeColor;

#pragma mark - 返回一个箭头view
+ (UIImageView*)accessoryIndicatorView;

@end
