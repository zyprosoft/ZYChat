//
//  GJCFCoreTextFrame.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-21.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "GJCFCoreTextLine.h"
#import "GJCFCoreTextRun.h"

@interface GJCFCoreTextFrame : NSObject

/* 所有行GJCFCoreTextLine对象 */
@property (nonatomic,readonly)NSArray *linesArray;

/* 读取内容的适配高度 */
@property (nonatomic,readonly)CGFloat suggestHeigh;

/* 读取内容适配的宽度 */
@property (nonatomic,readonly)CGFloat suggestWidth;

/* boundingBox */
@property (nonatomic,readonly)CGRect boundingBox;

/* 内容字符串 */
@property (nonatomic,readonly)NSAttributedString *contentAttributedString;

/* 不带图片标示初始化 */
- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString withDrawRect:(CGRect)textRect isNeedSetupLine:(BOOL)isLineNeed;

/* 带图片标示初始化,带图片的才需要获取line信息 */
- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString withDrawRect:(CGRect)textRect withImageTagArray:(NSArray *)imageTagArray  isNeedSetupLine:(BOOL)isLineNeed;

/* 在目标上下文绘制 */
- (void)drawInContext:(CGContextRef)context;

/* 获取某个点的字符 */
- (CFIndex)stringIndexAtPoint:(CGPoint)point;

/* 获取某个关键字的所有区域 */
- (NSArray *)rectArrayForStringRange:(NSRange)stringRange;

/* 计算可见字符范围 */
- (NSRange)visiableStringRange;

/* 获取限制行数的字符 */
- (NSString *)getLimitNumberOfLineText:(NSInteger)limitLineCount;

/* 获取限制行数的字符范围 */
- (NSRange)getLimitNumberOfLineRange:(NSInteger)limitLineCount;

/**
 *  获取最后一行的最后一个字符
 *
 *  @return 最后一个run对象
 */
- (GJCFCoreTextRun *)getLastTextRun;
@end
