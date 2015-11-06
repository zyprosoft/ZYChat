//
//  GJCFCoreTextImageAttributedString.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-23.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFCoreTextKeywordAttributedStringStyle.h"

@interface GJCFCoreTextImageAttributedStringStyle : GJCFCoreTextKeywordAttributedStringStyle

/* 图片标记 */
@property (nonatomic,strong)NSString *imageTag;

/* 图片名字 */
@property (nonatomic,strong)NSString *imageName;

/* 运行时回调 */
@property (nonatomic, readonly) CTRunDelegateCallbacks callbacks;

/* 插入到目标字符串的位置 */
@property (nonatomic,assign)NSRange  imageRange;

/* 原始未解析的图片代表字符串 */
@property (nonatomic,strong)NSString *imageSourceString;

/* 运行时的字典 */
@property (nonatomic,readonly)NSDictionary *runDelegateDict;

/* 
 * 图片后间隔,图片的前间隔需要设置图片在字符串中的前置距离
 * 后间隔的原理只是在要求绘制区域的时候要求更宽一点
 * 实际绘制的还是图片的大小而已
 */

/* 返回图片标记字符串 */
- (NSAttributedString *)imageAttributedString;

@end
