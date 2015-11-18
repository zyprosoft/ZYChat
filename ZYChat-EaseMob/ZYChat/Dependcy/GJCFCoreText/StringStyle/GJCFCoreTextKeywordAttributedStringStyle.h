//
//  GJCFCoreTextKeywordAttributedStringStyle.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-23.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFCoreTextAttributedStringStyle.h"

@interface GJCFCoreTextKeywordAttributedStringStyle : GJCFCoreTextAttributedStringStyle

/* 起始位置前间距 */
@property (nonatomic,assign)CGFloat preGap;

/* 结束位置后间距 */
@property (nonatomic,assign)CGFloat endGap;

/* 关键字内间距 */
@property (nonatomic,assign)CGFloat innerGap;

/* 关键字 */
@property (nonatomic,strong)NSString *keyword;

/* 关键字颜色 */
@property (nonatomic,strong)UIColor  *keywordColor;

/* 关键字字体 */
@property (nonatomic,strong)UIFont   *keywordFont;

/* 直接指定关键字的范围 */
@property (nonatomic,assign)NSRange  destKeywordRange;

/* 获取一个关键词在目标字符串中的所有range */
+ (NSArray *)getAllKeywordRangeFromString:(NSString *)destString forKeyword:(NSString *)keyword;

/* 设置关键字效果 */
- (void)setKeywordEffectForString:(NSMutableAttributedString*)destString;

/* 直接为指定字符串范围设置一些关键字相关的属性,这个时候需要有destKeywordRange */
- (void)setKeywordEffectByKeywordRangeForString:(NSMutableAttributedString*)destString;

@end
