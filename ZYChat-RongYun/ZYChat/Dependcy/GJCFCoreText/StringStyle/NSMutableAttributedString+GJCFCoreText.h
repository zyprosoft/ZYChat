//
//  NSMutableAttributedString+GJCFCoreText.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-12.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFCoreTextImageAttributedStringStyle.h"
#import "GJCFCoreTextAttributedStringStyle.h"
#import "GJCFCoreTextKeywordAttributedStringStyle.h"
#import "GJCFCoreTextParagraphStyle.h"

#define kGJCFCoreTextImageInfoRangeKey  @"kGJCFCoreTextImageInfoRangeKey"
#define kGJCFCoreTextImageInfoStringKey @"kGJCFCoreTextImageInfoStringKey"

@interface NSMutableAttributedString (GJCFCoreText)

/* 插入图片标记 */
- (NSDictionary *)insertImageAttributedStringStyle:(GJCFCoreTextImageAttributedStringStyle*)imageAttributedString atIndex:(NSInteger)index;

/* 替换图片 */
- (NSDictionary *)replaceImageAttributedStringStyle:(GJCFCoreTextImageAttributedStringStyle*)imageAttributedString withImageRange:(NSRange)imageRange;

/* 插入多态字符串风格 */
- (void)insertAttributedStringStyle:(GJCFCoreTextAttributedStringStyle *)aStyle range:(NSRange)range;

/* 插入关键字风格 */
- (void)setKeywordEffectByStyle:(GJCFCoreTextKeywordAttributedStringStyle *)aStyle;

/* 指定范围关键字风格设定 */
- (void)setKeywordRangeEffectByStyle:(GJCFCoreTextKeywordAttributedStringStyle *)aStyle;

/* 插入段落风格 */
- (void)insertParagraphStyle:(GJCFCoreTextParagraphStyle *)aStyle range:(NSRange)range;

/* 整个字符串范围 */
- (NSRange)range;

@end
