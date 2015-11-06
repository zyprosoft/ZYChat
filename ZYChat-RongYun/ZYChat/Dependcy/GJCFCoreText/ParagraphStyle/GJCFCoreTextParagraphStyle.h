//
//  GJCFCoreTextParagraphStyle.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-22.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
//kCTParagraphStyleSpecifierAlignment = 0,
//kCTParagraphStyleSpecifierFirstLineHeadIndent = 1,
//kCTParagraphStyleSpecifierHeadIndent = 2,
//kCTParagraphStyleSpecifierTailIndent = 3,
//kCTParagraphStyleSpecifierTabStops = 4,
//kCTParagraphStyleSpecifierDefaultTabInterval = 5,
//kCTParagraphStyleSpecifierLineBreakMode = 6,
//kCTParagraphStyleSpecifierLineHeightMultiple = 7,
//kCTParagraphStyleSpecifierMaximumLineHeight = 8,
//kCTParagraphStyleSpecifierMinimumLineHeight = 9,
//kCTParagraphStyleSpecifierLineSpacing = 10,			/* deprecated */
//kCTParagraphStyleSpecifierParagraphSpacing = 11,
//kCTParagraphStyleSpecifierParagraphSpacingBefore = 12,
//kCTParagraphStyleSpecifierBaseWritingDirection = 13,
//kCTParagraphStyleSpecifierMaximumLineSpacing = 14,
//kCTParagraphStyleSpecifierMinimumLineSpacing = 15,
//kCTParagraphStyleSpecifierLineSpacingAdjustment = 16,
//kCTParagraphStyleSpecifierLineBoundsOptions = 17,

@interface GJCFCoreTextParagraphStyle : NSObject

/* 对齐属性 */
//kCTLeftTextAlignment = 0,                //左对齐
//kCTRightTextAlignment = 1,               //右对齐
//kCTCenterTextAlignment = 2,              //居中对齐
//kCTJustifiedTextAlignment = 3,           //文本对齐
//kCTNaturalTextAlignment = 4              //自然文本对齐
@property (nonatomic,assign)CTTextAlignment alignment;

/* 首行缩进 */
@property (nonatomic,assign)CGFloat firstLineHeadIndent;

/* 段落缩进 */
@property (nonatomic,assign)CGFloat paragraphHeadIndent;

/* 段尾缩进 */
@property (nonatomic,assign)CGFloat paragraphTailIndent;

/* 制表符距离 */
@property (nonatomic,assign)CGFloat tabWidth;

/* 换行模式 */
//kCTLineBreakByWordWrapping = 0,        //出现在单词边界时起作用，如果该单词不在能在一行里显示时，整体换行。此为段的默认值。
//kCTLineBreakByCharWrapping = 1,        //当一行中最后一个位置的大小不能容纳一个字符时，才进行换行。
//kCTLineBreakByClipping = 2,            //超出画布边缘部份将被截除。
//kCTLineBreakByTruncatingHead = 3,      //截除前面部份，只保留后面一行的数据。前部份以...代替。
//kCTLineBreakByTruncatingTail = 4,      //截除后面部份，只保留前面一行的数据，后部份以...代替。
//kCTLineBreakByTruncatingMiddle = 5     //在一行中显示段文字的前面和后面文字，中间文字使用...代替。
@property (nonatomic,assign)CTLineBreakMode lineBreakMode;

/* 多行高 */
@property (nonatomic,assign)CGFloat mutilRowHeight;

/* 行距  这个属性在iOS7下面已经不起效果了，要用上面那个多行高*/
@property (nonatomic,assign)CGFloat lineSpace;

/* 段前间隔 */
@property (nonatomic,assign)CGFloat paragraphBeforeSpace;

/* 段落间隔 */
@property (nonatomic,assign)CGFloat paragraphSpace;

/* 书写方向 */
//kCTWritingDirectionNatural = -1,            //普通书写方向，一般习惯是从左到右写
//kCTWritingDirectionLeftToRight = 0,         //从左到右写
//kCTWritingDirectionRightToLeft = 1          //从右到左写
@property (nonatomic,assign)CTWritingDirection writeDirection;

/* 最大行高 */
@property (nonatomic,assign)CGFloat maxRowHeight;

/* 最小行高 */
@property (nonatomic,assign)CGFloat minRowHeight;

/* 最大行距 */
@property (nonatomic,assign)CGFloat maxLineSpace;

/* 最小行距 */
@property (nonatomic,assign)CGFloat minLineSpace;

- (NSDictionary *)paragraphAttributedDictionary;


/* 
 * ===== 单独属性,设置下面这种单独属性会覆盖替代之前的段落属性 =====
 * ===== 需要设置对应的属性值 =====
 */

/* 对齐属性 */
- (NSDictionary *)alignmentSetting;

/* 首行缩进 */
- (NSDictionary * )firstLineHeadIndentSetting;

/* 段落缩进 */
- (NSDictionary * )paragraphHeadIndentSetting;

/* 段尾缩进 */
- (NSDictionary * )paragraphTailIndentSetting;

/* 制表符距离 */
- (NSDictionary * )tabWidthStyleSetting;

/* 换行模式 */
- (NSDictionary * )lineBreakModeSetting;

/* 多行高 */
- (NSDictionary * )mutilRowHeightSetting;

/* 行距  这个属性在iOS7下面已经不起效果了，要用上面那个多行高*/
- (NSDictionary * )lineSpaceSetting;

/* 段前间隔 */
- (NSDictionary * )paragraphBeforeSpaceSetting;

/* 段落间隔 */
- (NSDictionary * )paragraphSpaceSetting;

/* 书写方向 */
- (NSDictionary * )writeDirectionSetting;

/* 最大行高 */
- (NSDictionary * )maxRowHeightSetting;

/* 最小行高 */
- (NSDictionary * )minRowHeightSetting;

/* 最大行距 */
- (NSDictionary * )maxLineSpaceSetting;

/* 最小行距 */
- (NSDictionary * )minLineSpaceSetting;

@end
