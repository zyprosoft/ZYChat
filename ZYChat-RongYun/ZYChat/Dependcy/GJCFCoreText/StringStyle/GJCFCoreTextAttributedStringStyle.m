//
//  GJCFAttributedStringStyle.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-22.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFCoreTextAttributedStringStyle.h"

@implementation GJCFCoreTextAttributedStringStyle

- (id)init
{
    if (self = [super init]) {
        
        //设置一些默认值
        self.isVertical = NO;
        self.strokeWidth = 0.f;
        self.isForegoundColorContext = NO;
    }
    return self;
}

- (NSDictionary *)fontAttributedDictionary
{
    if (self.font) {
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
        
        NSDictionary *dict = @{(__bridge  id)kCTFontAttributeName: (__bridge id)fontRef};
        
        CFRelease(fontRef);
        
        return dict;
    }
    return nil;
}

- (NSDictionary *)characterGapAttributedDictionary
{
    if (self.characterGap > 0) {
        
        long gap = self.characterGap;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&gap);

        NSDictionary *dict = @{(__bridge id)kCTKernAttributeName: (__bridge id)num};
        
        CFRelease(num);
        
        return dict;
        
    }
    return nil;
}

- (NSDictionary *)charaterShapeAttributedDictionary
{
    if (self.characterShape > 0) {
        
        long shape = self.characterShape;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&shape);
        
        NSDictionary *dict = @{(__bridge id)kCTCharacterShapeAttributeName: (__bridge id)num};
        
        CFRelease(num);
        
        return dict;
    }
    return nil;
}

- (NSDictionary *)ligatureAttributedDictionary
{
    if (self.isLigature) {
        return @{(__bridge id)kCTLigatureAttributeName:(__bridge id)kCFBooleanTrue};
    }else{
        return @{(__bridge id)kCTLigatureAttributeName:(__bridge id)kCFBooleanFalse};
    }
}

- (NSDictionary *)foregroundColorAttributedDictionary
{
    if (self.foregroundColor) {
        
        return @{(__bridge id)kCTForegroundColorAttributeName: (__bridge id)self.foregroundColor.CGColor};
        
    }
    return nil;
}

- (NSDictionary *)foregroundColorFromContextAttributedDictionary
{
    if (self.isForegoundColorContext) {
        
        return @{(__bridge id)kCTForegroundColorFromContextAttributeName:(__bridge id)kCFBooleanTrue};
        
    }else{
        
        return @{(__bridge id)kCTForegroundColorFromContextAttributeName:(__bridge id)kCFBooleanFalse};

    }
}

- (NSDictionary *)strokeWidthAttributedDictionary
{
    CGFloat strokWidth = self.strokeWidth;
    CFNumberRef strokeNumber = CFNumberCreate(kCFAllocatorDefault, kCFNumberCGFloatType, &strokWidth);
    NSDictionary *dict = @{(__bridge id)kCTStrokeWidthAttributeName:(__bridge id)strokeNumber};
    CFRelease(strokeNumber);
    
    return dict;
}

- (NSDictionary *)strokeColorAttributedDictionary
{
    if (self.strokeColor) {
        
        return @{(__bridge id)kCTStrokeColorAttributeName: (__bridge id)self.strokeColor.CGColor};
    }
    return nil;
}

- (NSDictionary *)superScriptAttributedDictionary
{
    NSUInteger scriptIndex = self.superScript;
    CFNumberRef scriptNum = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &scriptIndex);
    NSDictionary *dict = @{(__bridge id)kCTSuperscriptAttributeName:(__bridge id)scriptNum};
    CFRelease(scriptNum);
    
    return dict;
}

- (NSDictionary *)underLineColorAttributedDictionary
{
    if (self.underLineColor) {
        
        return @{(__bridge id)kCTUnderlineColorAttributeName:(__bridge id)self.underLineColor.CGColor};
    }
    return nil;
}

- (NSDictionary *)underLineStyleAttributedDictionary
{
    int32_t style = self.underLineStyle;
    
    CFNumberRef styleNum = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &style);
    
    NSDictionary *dict = @{(__bridge id)kCTUnderlineStyleAttributeName: (__bridge id)styleNum};
    
    CFRelease(styleNum);
    
    return dict;
}

- (NSDictionary *)isVerticalAttributedDictionary
{
    if (self.isVertical) {
        
        return @{(__bridge id)kCTVerticalFormsAttributeName:(__bridge id)kCFBooleanTrue};
        
    }else{
        
        return @{(__bridge id)kCTVerticalFormsAttributeName:(__bridge id)kCFBooleanFalse};
        
    }
}

//阴影属性
- (NSDictionary *)shadowAttributedDictionary
{
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = self.shadowColor;
    shadow.shadowBlurRadius = self.shadowBlurRadius;
    shadow.shadowOffset = self.shadowOffset;
    
    return @{NSShadowAttributeName:shadow};
}

- (NSDictionary*)attributedDictionary
{
    NSMutableDictionary *allAttributedDictionary = [NSMutableDictionary dictionary];
    
    /* 字形 */
    if ([self charaterShapeAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self charaterShapeAttributedDictionary]];
    }
    
    /* 字体 */
    if ([self fontAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self fontAttributedDictionary]];
    }
    
    /* 字间距 */
    if ([self characterGapAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self characterGapAttributedDictionary]];
    }
    
    /* 连字属性 */
    if ([self ligatureAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self ligatureAttributedDictionary]];
    }
    
    /* 前景色 */
    if ([self foregroundColorAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self foregroundColorAttributedDictionary]];
    }
    
    /* 上下文前景色 */
    if ([self foregroundColorFromContextAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self foregroundColorFromContextAttributedDictionary]];
    }
    
    /* 笔画粗度 */
    if ([self strokeWidthAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self strokeWidthAttributedDictionary]];
    }
    
    /* 笔画颜色 */
    if ([self strokeColorAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self strokeColorAttributedDictionary]];
    }
    
    /* 上下角标 */
    if ([self superScriptAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self superScriptAttributedDictionary]];
    }
    
    /* 下划线颜色 */
    if ([self underLineColorAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self underLineColorAttributedDictionary]];
    }
    
    /* 下划线风格 */
    if ([self underLineStyleAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self underLineStyleAttributedDictionary]];
    }
    
    /* 是否垂直属性 */
    if ([self isVerticalAttributedDictionary]) {
        [allAttributedDictionary addEntriesFromDictionary:[self isVerticalAttributedDictionary]];
    }
    
    /* 阴影属性 */
    if ([self shadowAttributedDictionary]) {
        
        [allAttributedDictionary addEntriesFromDictionary:[self shadowAttributedDictionary]];
    }
    
    return allAttributedDictionary;
}


@end
