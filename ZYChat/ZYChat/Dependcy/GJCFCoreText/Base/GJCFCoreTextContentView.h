//
//  GJCFCoreTextContentView.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-21.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFCoreTextKeywordAttributedStringStyle.h"
#import "GJCFCoreTextImageAttributedStringStyle.h"
#import "GJCFCoreTextCommonDefine.h"
#import "GJCFCoreTextImageScriptParser.h"
#import "GJCFCoreTextParagraphStyle.h"
#import "NSMutableAttributedString+GJCFCoreText.h"
#import "UIView+GJCFViewFrameUitil.h"

#define kGJCFCoreTextContentViewAdjustHeightNSCachePreFix @"kGJCFCoreTextContentViewAdjustHeightNSCachePreFix"

@class GJCFCoreTextContentView;

/* 记住block内的对象会被retain */
typedef void (^GJCFCoreTextContentViewTouchHanlder) (NSString *keyword,NSRange keywordRange);

/* 长按事件捕捉 */
typedef void (^GJCFCoreTextContentViewLongPressHanlder) (GJCFCoreTextContentView *textView, NSString *contentString);

/* 整体点击事件捕捉 */
typedef void (^GJCFCoreTextContentViewTapHanlder) (GJCFCoreTextContentView *textView);

@interface GJCFCoreTextContentView : UIView

//============= 支持类UILabel的属性 ============//

/**
 *  设置字体
 */
@property (nonatomic,strong)UIFont *font;

/**
 *  文本内容
 */
@property (nonatomic,copy)NSString *text;

/**
 *  是否高亮
 */
@property (nonatomic,assign)BOOL highlighted;

/**
 *  高亮文本颜色
 */
@property (nonatomic,strong)UIColor *highlightedTextColor;

/**
 *  行高 1.0为基础进行scale
 */
@property (nonatomic,assign)CGFloat lineHeight;

/**
 *  文本颜色
 */
@property (nonatomic,strong)UIColor *textColor;

/**
 *  文本对齐形式
 */
@property (nonatomic,assign)NSTextAlignment alignment;

/**
 *  是否多行模式
 */
@property (nonatomic,assign)NSInteger numberOfLines;

/**
 *  换行模式
 */
@property (nonatomic,assign)NSLineBreakMode lineBreakMode;


/* 支持转成图片的标记 */
@property (nonatomic,readonly)NSArray *supportImageTagArray;

/* 多态字符串内容 */
@property (nonatomic,copy)NSAttributedString *contentAttributedString;

/* 长按的时候是否让全部文字显示选中效果 */
@property (nonatomic,assign)BOOL isLongPressShowSelectedState;

/* 当前是否全部选中状态 */
@property (nonatomic,assign)BOOL selected;

/* 选中点击时候的背景颜色效果 */
@property (nonatomic,strong)UIColor *selectedStateColor;

/* 用户设置一些自己的信息 */
@property (nonatomic,strong)NSDictionary *userInfo;

/* 省略号模式 */
@property (nonatomic,assign)BOOL isTailMode;

/**
 *  该标签的基础宽度，设置之后，每次自适应的时候都以这个宽度为基础宽度自适应
 *  如果不设置，默认使用 self.frame.width 作为基准
 */
@property (nonatomic,assign)CGFloat contentBaseWidth;

/**
 *  该标签内容的基础高度，设置之后，每次自适应的时候都以这个高度为基础宽度自适应
 *  如果不设置，默认使用 self.frame.height 作为基准
 */
@property (nonatomic,assign)CGFloat contentBaseHeight;

/**
 *  内容的基础限定大小
 */
@property (nonatomic,assign)CGSize contentBaseSize;

//阴影颜色
@property (nonatomic,strong)UIColor *shadowColor;

//阴影大小
@property (nonatomic,assign)CGSize shadowOffset;

//阴影半径
@property (nonatomic,assign)CGFloat shadowBlurRadius;


/* 
 * 省略号单行模式，如果这个设置为YES，那么最终只会保留一行然后省略号
 * 如果为NO，那么会计算当前view的frame下能显示多少文字，显示不了的
 * 用省略号表示,默认是NO
 */
@property (nonatomic,assign)BOOL isOneLineTailMode;

/*
 * 当前视图能够显示的可见字符范围
 */
@property (nonatomic,readonly)NSRange visiableStringRange;

///////////////////////////////////////////////  公开接口    ////////////////////////////////////////////

/* 记录一个图片标记被插入的图片的真实字符串内容 */
- (void)appendImageInfo:(NSDictionary *)imageInfo;

/* 替换所有的图片信息成新的 */
- (void)replaceAllImageInfosWithArray:(NSArray *)newImageInfos;

/* 添加一个图片标记 */
- (void)appendImageTag:(NSString *)imageTagName;

/* 为某个特定的字符串设定响应事件 */
- (void)appenTouchObserverForKeyword:(NSString *)keyword withHanlder:(GJCFCoreTextContentViewTouchHanlder)handler;

///* 为某个特定的关键字设定圆角背景 */
//- (void)appendRoundCorner:(CGFloat)cornerRadius backgroundColor:(UIColor *)backColor forKeyword:(NSString *)keyword;

/* 计算内容高度 */
+ (CGFloat)contentHeightForAttributedString:(NSAttributedString *)attributedString forContentSize:(CGSize)contentSize;

/* 计算内容一行情况下的真实宽度 */
+ (CGFloat)contentWidthForAttributedString:(NSAttributedString *)attributedString forContentSize:(CGSize)contentSize;

/* 获取一个基于基础的Size的自适应大小 */
+ (CGSize)contentSuggestSizeWithAttributedString:(NSAttributedString *)attributedString forBaseContentSize:(CGSize)contentSize;

/* 获取一个最大行数下自适应的大小 */
+ (CGSize)contentSuggestSizeWithAttributedString:(NSAttributedString *)attributedString forBaseContentSize:(CGSize)contentSize maxNumberOfLine:(NSInteger)lineCount;

/* 设置一个外部可以监测coreText 长按事件的block */
- (void)setLongPressEventHandler:(GJCFCoreTextContentViewLongPressHanlder)longPressBlock;

/* 设置一个整体点击事件观察 */
- (void)setTapActionHandler:(GJCFCoreTextContentViewTapHanlder)tapBlock;

/* 自动根据内容调整大小 */
- (void)sizeToFit;

/* 清除关键字观察事件 */
- (void)clearKeywordTouchEventHanlder;

/* 替换图片的原始文字信息 */
- (NSString *)imageInfoOriginSourceString;

/**
 *  最后一个字符的位置右下角的位置，或者右上角在整个view中的位置
 *
 *  @param isCharTop YES 右上角 NO 右下角
 *
 *  @return 位置
 */
- (CGPoint)lastCharPostion:(BOOL)isCharTop;

@end
