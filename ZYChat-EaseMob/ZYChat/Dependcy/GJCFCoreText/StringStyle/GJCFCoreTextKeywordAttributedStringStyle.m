//
//  GJCFCoreTextKeywordAttributedStringStyle.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-23.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFCoreTextKeywordAttributedStringStyle.h"

@implementation GJCFCoreTextKeywordAttributedStringStyle

- (void)setKeywordColor:(UIColor *)keywordColor
{
    self.foregroundColor = keywordColor;
}

- (void)setKeywordFont:(UIFont *)keywordFont
{
    self.font = keywordFont;
}

- (NSDictionary *)keywordAttributedDictionary
{
    NSMutableDictionary *allAttributedDictionary = [NSMutableDictionary dictionaryWithDictionary:[self attributedDictionary]];
    [allAttributedDictionary removeObjectForKey:(__bridge id)kCTKernAttributeName];
    
    return allAttributedDictionary;
}

- (void)setPreGapForString:(NSMutableAttributedString *)destString withKeywordRange:(NSRange)keywordRange
{
    long gap = self.preGap;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&gap);
    
    NSInteger totalLength = destString.string.length;
    
    if (totalLength == 0) {
        return;
    }
    
    if (totalLength == 1) {
        [destString addAttribute:(__bridge id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, 1)];
        return;
    }
    
    [destString addAttribute:(__bridge id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(keywordRange.location > 0? keywordRange.location-1:keywordRange.location, 1)];
    CFRelease(num);
}

- (void)setEndGapForString:(NSMutableAttributedString *)destString withKeywordRange:(NSRange)keywordRange;
{
    long gap = self.endGap;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&gap);
    
    NSInteger totalLength = destString.string.length;

    if (totalLength == 0) {
        return;
    }
    
    if (keywordRange.location + keywordRange.length > totalLength - 1) {
        return;
    }
    
    [destString addAttribute:(__bridge id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(keywordRange.location+keywordRange.length-1, 1)];
    CFRelease(num);
}

- (void)setInnerGapForString:(NSMutableAttributedString *)destString withKeywordRange:(NSRange)keywordRange
{
    long gap = self.innerGap;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&gap);
    
    [destString addAttribute:(__bridge id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(keywordRange.location, keywordRange.length-1)];
    CFRelease(num);
}

+ (NSArray *)getAllKeywordRangeFromString:(NSString *)destString forKeyword:(NSString *)keyword
{
    if (!destString) {
        return nil;
    }
    if (!keyword) {
        return nil;
    }
    
   __block NSMutableArray *allRangeArray = [NSMutableArray array];
    
    BOOL isFindAllRange = NO;
    NSMutableString *mutalbeString = [NSMutableString stringWithString:destString];
    NSInteger totalRemoveKeywordLength = 0;
    
    while (!isFindAllRange) {
        
        NSRange keywordRange = [mutalbeString rangeOfString:keyword];
        
        if (keywordRange.location != NSNotFound) {
            
            NSRange realRange = NSMakeRange(totalRemoveKeywordLength+keywordRange.location, keywordRange.length);
            
            [allRangeArray addObject:[NSValue valueWithRange:realRange]];
            
            [mutalbeString deleteCharactersInRange:keywordRange];
            totalRemoveKeywordLength = totalRemoveKeywordLength + keywordRange.length;
            
        }else{
            
            isFindAllRange = YES;
        }
    }
    
    return allRangeArray;
}

- (void)setKeywordEffectForString:(NSMutableAttributedString*)destString
{
    if (!destString) {
        
        return ;
    }
    
    if (!self.keyword) {
        return;
    }
    
    NSString *normalString = [destString string];
    
    NSArray *keywordRangeArray = [GJCFCoreTextKeywordAttributedStringStyle getAllKeywordRangeFromString:normalString forKeyword:self.keyword];
        
    [keywordRangeArray enumerateObjectsUsingBlock:^(NSValue *rangeValue, NSUInteger idx, BOOL *stop) {
        
        NSRange keywordRange = [rangeValue rangeValue];
        
        [destString addAttributes:[self keywordAttributedDictionary] range:keywordRange];
        [self setPreGapForString:destString withKeywordRange:keywordRange];
        [self setEndGapForString:destString withKeywordRange:keywordRange];
        [self setInnerGapForString:destString withKeywordRange:keywordRange];
        
    }];
}

/* 直接为指定字符串范围设置一些关键字相关的属性,这个时候需要有destKeywordRange */
- (void)setKeywordEffectByKeywordRangeForString:(NSMutableAttributedString*)destString
{
    if (self.destKeywordRange.location == NSNotFound || !destString) {
        return;
    }
    
    [self setPreGapForString:destString withKeywordRange:self.destKeywordRange];
    [self setEndGapForString:destString withKeywordRange:self.destKeywordRange];
    [self setInnerGapForString:destString withKeywordRange:self.destKeywordRange];
}

@end
