//
//  GJCFCoreTextRun.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-21.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "GJCFCoreTextLine.h"

@interface GJCFCoreTextRun : NSObject

/* 上行高度 */
@property (nonatomic,readonly)CGFloat ascent;

/* 下行高度 */
@property (nonatomic,readonly)CGFloat descent;

/* 行距 */
@property (nonatomic,readonly)CGFloat leading;

/* 原点 */
@property (nonatomic,readonly)CGPoint origin;

/* 获取字形的frame */
@property (nonatomic,readonly)CGRect runRect;

/* 距离行的起始位置的长度 */
@property (nonatomic,readonly)CGFloat lineOffsetX;

/* 当前字形的属性字典 */
@property (nonatomic,readonly)NSDictionary *attributesDictionary;

/* 用这个初始化 */
- (instancetype)initWithRun:(CTRunRef)ctRun withLine:(GJCFCoreTextLine *)ctLine;

@end
