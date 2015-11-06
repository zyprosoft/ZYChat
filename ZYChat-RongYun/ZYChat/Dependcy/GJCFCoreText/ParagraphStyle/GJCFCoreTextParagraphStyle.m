//
//  GJCFCoreTextParagraphStyle.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-22.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFCoreTextParagraphStyle.h"
#import <CoreText/CoreText.h>

@implementation GJCFCoreTextParagraphStyle

- (id)init
{
    if (self = [super init]) {
        
        //默认属性
        self.alignment = kCTTextAlignmentLeft;
        self.firstLineHeadIndent = 0.f;
        self.paragraphHeadIndent = 0.f;
        self.paragraphTailIndent = 0.f;
        self.lineBreakMode = kCTLineBreakByCharWrapping;
        self.tabWidth = 5.f;
        self.mutilRowHeight = 0.f;
        self.lineSpace = 0.f;
        self.paragraphBeforeSpace = 0.f;
        self.paragraphSpace = 0.f;
        self.writeDirection = kCTWritingDirectionNatural;
        self.maxRowHeight = 0.f;
        self.minRowHeight = 0.f;
        self.maxLineSpace = 0.f;
        self.minLineSpace = 0.f;
        
    }
    return self;
}

- (NSDictionary *)alignmentSetting
{
    CTParagraphStyleSetting alignSetting;
    alignSetting.spec = kCTParagraphStyleSpecifierAlignment;
    uint8_t align = self.alignment;
    alignSetting.value = &align;
    alignSetting.valueSize = sizeof(CTTextAlignment);
    
    CTParagraphStyleSetting settings[] = {
        
        alignSetting,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;

}

- (NSDictionary * )firstLineHeadIndentSetting
{
    CTParagraphStyleSetting firstLineHeadSetting;
    firstLineHeadSetting.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    CGFloat align = self.firstLineHeadIndent;
    firstLineHeadSetting.value = &align;
    firstLineHeadSetting.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        firstLineHeadSetting,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )paragraphHeadIndentSetting
{
    CTParagraphStyleSetting paragraphHeadSetting;
    paragraphHeadSetting.spec = kCTParagraphStyleSpecifierHeadIndent;
    CGFloat align = self.paragraphHeadIndent;
    paragraphHeadSetting.value = &align;
    paragraphHeadSetting.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        paragraphHeadSetting,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )paragraphTailIndentSetting
{
    CTParagraphStyleSetting paragraphTailSetting;
    paragraphTailSetting.spec = kCTParagraphStyleSpecifierTailIndent;
    CGFloat align = self.paragraphTailIndent;
    paragraphTailSetting.value = &align;
    paragraphTailSetting.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        paragraphTailSetting,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )tabWidthStyleSetting
{
    CTTextAlignment tabalignment = kCTJustifiedTextAlignment;
    CGFloat tWidth = self.tabWidth;
    CTTextTabRef texttab = CTTextTabCreate(tabalignment, tWidth, NULL);
    CTParagraphStyleSetting tab;
    tab.spec = kCTParagraphStyleSpecifierTabStops;
    tab.value = &texttab;
    tab.valueSize = sizeof(CTTextTabRef);
    
    CTParagraphStyleSetting settings[] = {
        
        tab,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )lineBreakModeSetting
{
    CTParagraphStyleSetting lineBreakMode;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    uint8_t align = self.lineBreakMode;
    lineBreakMode.value = &align;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting settings[] = {
        
        lineBreakMode,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
        
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )mutilRowHeightSetting
{
    CTParagraphStyleSetting mutilRowHeight;
    mutilRowHeight.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    CGFloat align = self.mutilRowHeight;
    mutilRowHeight.value = &align;
    mutilRowHeight.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        mutilRowHeight,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )lineSpaceSetting
{
    CTParagraphStyleSetting lineSpaceSet;
    lineSpaceSet.spec = kCTParagraphStyleSpecifierLineSpacing;
    CGFloat align = self.lineSpace;
    lineSpaceSet.value = &align;
    lineSpaceSet.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        lineSpaceSet,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )paragraphBeforeSpaceSetting
{
    CTParagraphStyleSetting paragraphBeforeSet;
    paragraphBeforeSet.spec = kCTParagraphStyleSpecifierParagraphSpacingBefore;
    CGFloat align = self.paragraphBeforeSpace;
    paragraphBeforeSet.value = &align;
    paragraphBeforeSet.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        paragraphBeforeSet,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )paragraphSpaceSetting
{
    CTParagraphStyleSetting paragraphBeforeSet;
    paragraphBeforeSet.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    CGFloat align = self.paragraphSpace;
    paragraphBeforeSet.value = &align;
    paragraphBeforeSet.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        paragraphBeforeSet,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )writeDirectionSetting
{
    CTParagraphStyleSetting writeDirection;
    writeDirection.spec = kCTParagraphStyleSpecifierBaseWritingDirection;
    int8_t align = self.writeDirection;
    writeDirection.value = &align;
    writeDirection.valueSize = sizeof(CTWritingDirection);
    
    CTParagraphStyleSetting settings[] = {
        
        writeDirection,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )maxRowHeightSetting
{
    CTParagraphStyleSetting maxRowHeight;
    maxRowHeight.spec = kCTParagraphStyleSpecifierMaximumLineHeight;
    CGFloat align = self.maxRowHeight;
    maxRowHeight.value = &align;
    maxRowHeight.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        maxRowHeight,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )minRowHeightSetting
{
    CTParagraphStyleSetting minRowHeight;
    minRowHeight.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    CGFloat align = self.minRowHeight;
    minRowHeight.value = &align;
    minRowHeight.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        minRowHeight,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )maxLineSpaceSetting
{
    CTParagraphStyleSetting maxLineSpace;
    maxLineSpace.spec = kCTParagraphStyleSpecifierMaximumLineSpacing;
    CGFloat align = self.maxLineSpace;
    maxLineSpace.value = &align;
    maxLineSpace.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        maxLineSpace,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary * )minLineSpaceSetting
{
    CTParagraphStyleSetting minLineSpace;
    minLineSpace.spec = kCTParagraphStyleSpecifierMinimumLineSpacing;
    CGFloat align = self.minLineSpace;
    minLineSpace.value = &align;
    minLineSpace.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        minLineSpace,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

- (NSDictionary *)paragraphAttributedDictionary
{
    /* 对齐 */
    CTParagraphStyleSetting alignSetting;
    alignSetting.spec = kCTParagraphStyleSpecifierAlignment;
    uint8_t align = self.alignment;
    alignSetting.value = &align;
    alignSetting.valueSize = sizeof(CTTextAlignment);
    
    /* 首行缩进 */
    CTParagraphStyleSetting firstLineHeadSetting;
    firstLineHeadSetting.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    CGFloat firstLineIndent = self.firstLineHeadIndent;
    firstLineHeadSetting.value = &firstLineIndent;
    firstLineHeadSetting.valueSize = sizeof(CGFloat);
    
    /* 换行模式 */
    CTParagraphStyleSetting lineBreakMode;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    uint8_t linebreak = self.lineBreakMode;
    lineBreakMode.value = &linebreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting paragraphHeadSetting;
    paragraphHeadSetting.spec = kCTParagraphStyleSpecifierHeadIndent;
    CGFloat paragrapHeadIndent = self.paragraphHeadIndent;
    paragraphHeadSetting.value = &paragrapHeadIndent;
    paragraphHeadSetting.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting paragraphTailSetting;
    paragraphTailSetting.spec = kCTParagraphStyleSpecifierTailIndent;
    CGFloat paragraphTailIndent = self.paragraphTailIndent;
    paragraphTailSetting.value = &paragraphTailIndent;
    paragraphTailSetting.valueSize = sizeof(CGFloat);
    
    CTTextAlignment tabalignment = kCTJustifiedTextAlignment;
    CGFloat tWidth = self.tabWidth;
    CTTextTabRef texttab = CTTextTabCreate(tabalignment, tWidth, NULL);
    CTParagraphStyleSetting tab;
    tab.spec = kCTParagraphStyleSpecifierTabStops;
    tab.value = &texttab;
    tab.valueSize = sizeof(CTTextTabRef);
    CFRelease(texttab);
    
    CTParagraphStyleSetting mutilRowHeight;
    mutilRowHeight.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    CGFloat mutilHeight = self.mutilRowHeight;
    mutilRowHeight.value = &mutilHeight;
    mutilRowHeight.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting lineSpaceSet;
    lineSpaceSet.spec = kCTParagraphStyleSpecifierLineSpacing;
    CGFloat lspace = self.lineSpace;
    lineSpaceSet.value = &lspace;
    lineSpaceSet.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting paragraphBeforeSet;
    paragraphBeforeSet.spec = kCTParagraphStyleSpecifierParagraphSpacingBefore;
    CGFloat paragraphBefSpace = self.paragraphBeforeSpace;
    paragraphBeforeSet.value = &paragraphBefSpace;
    paragraphBeforeSet.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting paragraphSpaceSet;
    paragraphSpaceSet.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    CGFloat paragraphSpa = self.paragraphSpace;
    paragraphSpaceSet.value = &paragraphSpa;
    paragraphSpaceSet.valueSize = sizeof(CGFloat);

    CTParagraphStyleSetting writeDirection;
    writeDirection.spec = kCTParagraphStyleSpecifierBaseWritingDirection;
    int8_t writeDirect = self.writeDirection;
    writeDirection.value = &writeDirect;
    writeDirection.valueSize = sizeof(CTWritingDirection);
    
    CTParagraphStyleSetting maxRowHeight;
    maxRowHeight.spec = kCTParagraphStyleSpecifierMaximumLineHeight;
    CGFloat mRowHeight = self.maxRowHeight;
    maxRowHeight.value = &mRowHeight;
    maxRowHeight.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting minRowHeight;
    minRowHeight.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    CGFloat minRoHeight = self.minRowHeight;
    minRowHeight.value = &minRoHeight;
    minRowHeight.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting maxLineSpace;
    maxLineSpace.spec = kCTParagraphStyleSpecifierMaximumLineSpacing;
    CGFloat maxlSpace = self.maxLineSpace;
    maxLineSpace.value = &maxlSpace;
    maxLineSpace.valueSize = sizeof(CGFloat);
    
    
    CTParagraphStyleSetting minLineSpace;
    minLineSpace.spec = kCTParagraphStyleSpecifierMinimumLineSpacing;
    CGFloat minlSpace = self.minLineSpace;
    minLineSpace.value = &minlSpace;
    minLineSpace.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {
        
        alignSetting,
        
        firstLineHeadSetting,
        
        paragraphHeadSetting,
        
        paragraphTailSetting,
        
        lineBreakMode,
        
        mutilRowHeight,
        
        lineSpaceSet,

        paragraphBeforeSet,
        
        paragraphSpaceSet,
        
        writeDirection,
        
        maxRowHeight,
        
        minRowHeight,
        
        maxLineSpace,
        
        minLineSpace,
        
    };

    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 14);
    
    NSDictionary *attributedDict = @{(__bridge id)kCTParagraphStyleAttributeName: (__bridge id)style};
    
    CFRelease(style);
    
    return attributedDict;
}

@end
