//
//  NSMutableAttributedString+GJCFCoreText.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-12.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "NSMutableAttributedString+GJCFCoreText.h"

@implementation NSMutableAttributedString (GJCFCoreText)

/* 整个字符串范围 */
- (NSRange)range
{
    return NSMakeRange(0, self.length);
}

/* 插入图片标记 */
- (NSDictionary *)insertImageAttributedStringStyle:(GJCFCoreTextImageAttributedStringStyle*)imageAttributedString atIndex:(NSInteger)index
{
    if (index > self.length-1) {
        return nil;
    }
    NSAttributedString *imageAttiString = [imageAttributedString imageAttributedString];
    
    [self insertAttributedString:imageAttiString atIndex:index];
    
    NSRange imageRange = NSMakeRange(index, 1);
    NSDictionary *resultImageInfo = @{kGJCFCoreTextImageInfoRangeKey:[NSValue valueWithRange:imageRange],kGJCFCoreTextImageInfoStringKey:imageAttributedString.imageSourceString};
    
    return resultImageInfo;
}

- (NSDictionary *)replaceImageAttributedStringStyle:(GJCFCoreTextImageAttributedStringStyle*)imageAttributedString withImageRange:(NSRange)imageRange
{
    NSAttributedString *imageAttiString = [imageAttributedString imageAttributedString];

    [self insertAttributedString:imageAttiString atIndex:imageRange.location];
    NSRange emojiRange = NSMakeRange(imageRange.location, 1);
    imageRange = NSMakeRange(imageRange.location+1,imageRange.length);
    [self replaceCharactersInRange:imageRange withString:@""];
    
    NSDictionary *resultImageInfo = @{kGJCFCoreTextImageInfoRangeKey:[NSValue valueWithRange:emojiRange],kGJCFCoreTextImageInfoStringKey:imageAttributedString.imageSourceString};
    
    return resultImageInfo;
}

/* 插入多态字符串风格 */
- (void)insertAttributedStringStyle:(GJCFCoreTextAttributedStringStyle *)aStyle range:(NSRange)range
{
    if (!aStyle || range.location == NSNotFound) {
        return;
    }
    [self addAttributes:[aStyle attributedDictionary] range:range];
}

/* 插入关键字风格 */
- (void)setKeywordEffectByStyle:(GJCFCoreTextKeywordAttributedStringStyle *)aStyle
{
    if (!aStyle) {
        return;
    }
    [aStyle setKeywordEffectForString:self];
}

/* 指定范围关键字风格设定 */
- (void)setKeywordRangeEffectByStyle:(GJCFCoreTextKeywordAttributedStringStyle *)aStyle
{
    if (!aStyle) {
        return;
    }
    [aStyle setKeywordEffectByKeywordRangeForString:self];
}

/* 插入段落风格 */
- (void)insertParagraphStyle:(GJCFCoreTextParagraphStyle *)aStyle range:(NSRange)range
{
    if (!aStyle || range.location == NSNotFound) {
        return;
    }
    [self addAttributes:[aStyle paragraphAttributedDictionary] range:range];
}

@end
