//
//  GJCFCoreTextLine.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-21.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class GJCFCoreTextRun,GJCFCoreTextFrame;
@interface GJCFCoreTextLine : NSObject

/* 所有字形数组 */
@property (nonatomic,readonly)NSArray *glyphsArray;

/* 字形个数 */
@property (nonatomic,readonly)NSInteger numberOfGlyphs;

/* 行的起始点 */
@property (nonatomic,readonly)CGPoint origin;

/* 上行高度 */
@property (nonatomic,readonly)CGFloat ascent;

/* 下行高度 */
@property (nonatomic,readonly)CGFloat descent;

/* 行距 */
@property (nonatomic,readonly)CGFloat leading;

/* 整行高 */
@property (nonatomic,readonly)CGFloat lineHeight;

/* frame */
@property (nonatomic,readonly)CGRect lineRect;

/* 携带的文字在字符串中的range */
@property (nonatomic,readonly)CFRange stringRange;

- (instancetype)initWithLine:(CTLineRef)ctLine withFrame:(GJCFCoreTextFrame *)frame withLineOrigin:(CGPoint)lineOrigin;

/* 获取指定点的字符 */
- (CFIndex)getStringForPosition:(CGPoint)position;

/* 获取当前的line */
- (CTLineRef)getLineRef;

/* 获取某个索引位置的具体字形run */
- (GJCFCoreTextRun *)glyphRunAtIndex:(NSInteger)glyphIndex;

/* 获取字符串指定位置的区域 */
- (CGRect)rectForStringRange:(NSRange)range;

@end
