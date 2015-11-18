//
//  GJCFCoreTextFrame.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-21.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import "GJCFCoreTextFrame.h"
#import "GJCFCoreTextKeywordAttributedStringStyle.h"

@interface GJCFCoreTextFrame ()
{
    CTFramesetterRef _frameSetter;
    CTFrameRef       _frame;
    CGRect           _textFrame;
    
    NSArray          *_imageTagArray;
    NSArray          *_keywordTagArray;
    
}
@property (nonatomic,assign)BOOL needLineSetup;
@end

@implementation GJCFCoreTextFrame

- (id)initWithAttributedString:(NSAttributedString *)attributedString withDrawRect:(CGRect)textRect isNeedSetupLine:(BOOL)isLineNeed;
{
    return [self initWithAttributedString:attributedString withDrawRect:textRect withImageTagArray:nil isNeedSetupLine:isLineNeed];
}

- (id)initWithAttributedString:(NSAttributedString *)attributedString withDrawRect:(CGRect)textRect withImageTagArray:(NSArray *)imageTagArray isNeedSetupLine:(BOOL)isLineNeed;
{
    if (self = [super init]) {
        
        self.needLineSetup = isLineNeed;
        
        _contentAttributedString = [attributedString copy];
        
        _textFrame = textRect;
        
        _imageTagArray = imageTagArray;
        
        if (_contentAttributedString && !CGRectEqualToRect(_textFrame, CGRectZero)) {
            
            [self setupFrame];
        }
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_frame);
    CFRelease(_frameSetter);
}

- (void)setupFrame
{
    if (_frameSetter) {
        CFRelease(_frameSetter);
    }
    _frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_contentAttributedString);
    
    /* 创建绘制路径 */
    CGMutablePathRef textPath = CGPathCreateMutable();
    CGPathAddRect(textPath, NULL, _textFrame);
    
    if (_frame) {
        CFRelease(_frame);
    }
    _linesArray = nil;
    _frame = CTFramesetterCreateFrame(_frameSetter, CFRangeMake(0,0), textPath, NULL);
    
    //图形路径要用这个释放
    CGPathRelease(textPath);
    
    /* 如果没有图文混排和点击事件检测的需求，是不需要初始化下面每一条Line的信息的 */
    if (!self.needLineSetup) {
        
        [self setupSuggest];
        
//        NSLog(@"setup ctFrame No need setup Line ++++");
        
        return;
    }
    
//    NSLog(@"setup ctFrame need setup Line ----");

    /* 得到所有行数组 */
    CFArrayRef ctLinesArray = CTFrameGetLines(_frame);
    CFIndex lineTotal = CFArrayGetCount(ctLinesArray);
    
    /* 所有行的起始点 */
    CGPoint lineOriginArray[lineTotal];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), lineOriginArray);
    
    NSMutableArray *gjLineArray = [NSMutableArray array];
    for (CFIndex lineIndex = 0; lineIndex < lineTotal; lineIndex++) {
        
        CTLineRef line = CFArrayGetValueAtIndex(ctLinesArray, lineIndex);
        
        GJCFCoreTextLine *gjLine = [[GJCFCoreTextLine alloc]initWithLine:line withFrame:self withLineOrigin:lineOriginArray[lineIndex]];
        
        [gjLineArray addObject:gjLine];
        
    }
    
    _linesArray = gjLineArray;
    [self setupSuggest];
}

- (void)drawInContext:(CGContextRef)context
{
    if (!context) {
        return;
    }
    if (_frame) {
        CTFrameDraw(_frame, context);
    }
    
    /* 只有有图片的时候才需要这个信息 */
    if (_imageTagArray && _imageTagArray.count > 0) {
        [self drawImagesInContext:context];
    }
}

- (void)drawImagesInContext:(CGContextRef)context
{
    [_linesArray enumerateObjectsUsingBlock:^(GJCFCoreTextLine *aLine, NSUInteger idx, BOOL *stop) {
        
        [aLine.glyphsArray enumerateObjectsUsingBlock:^(GJCFCoreTextRun *aRun, NSUInteger idx, BOOL *stop) {
           
            NSDictionary *attributesDict = aRun.attributesDictionary;
                        
            /* 绘制图片 */
            for (NSString *imageTag in _imageTagArray) {
                
                NSString *imageName = [attributesDict objectForKey:imageTag];
                
                if (imageName) {
                    
                    UIImage *image = [UIImage imageNamed:imageName];
                    
                    if (image) {
                        CGRect imageDrawRect;
                        imageDrawRect.size = image.size;
                        imageDrawRect.origin.x = aRun.runRect.origin.x;
                        imageDrawRect.origin.y = aRun.runRect.origin.y;
                        CGContextDrawImage(context, imageDrawRect, image.CGImage);
                    }
                    
                }
            }
            
         }];
    }];
}

- (CGRect)boundingBox
{
    CGPathRef boundPath = CTFrameGetPath(_frame);
    
    return CGPathGetBoundingBox(boundPath);
}

- (CFIndex)stringIndexAtPoint:(CGPoint)point;
{
     __block CFIndex resultIndex = 0;
    [self.linesArray enumerateObjectsUsingBlock:^(GJCFCoreTextLine *aLine, NSUInteger idx, BOOL *stop) {
                
        if (point.y>aLine.origin.y && point.y <aLine.origin.y+aLine.ascent+aLine.descent+aLine.leading) {
            
            CFIndex stringIndex = [aLine getStringForPosition:point];
            
//            NSLog(@"tapIndex:%ld",stringIndex);
            
            resultIndex = stringIndex;
        }
        
    }];
    
    return resultIndex;
}

/* 获取某个关键字的所有区域 */
- (NSArray *)rectArrayForStringRange:(NSRange)stringRange
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    [self.linesArray enumerateObjectsUsingBlock:^(GJCFCoreTextLine *aLine, NSUInteger idx, BOOL *stop) {
        
        CGRect rect =  [aLine rectForStringRange:stringRange];
        
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            
            [resultArray addObject:[NSValue valueWithCGRect:rect]];
        }
        
    }];
    
    return resultArray;
}

- (NSRange)visiableStringRange
{
    CFRange visiableRange = CTFrameGetVisibleStringRange(_frame);
    
    return NSMakeRange(visiableRange.location, visiableRange.length);
}

- (NSString *)getLimitNumberOfLineText:(NSInteger)limitLineCount
{
    if (self.linesArray.count < limitLineCount) {
        return _contentAttributedString.string;
    }
    
    NSMutableString *resultString = [NSMutableString string];
    
    for (NSInteger index = 0 ; index < limitLineCount ; index ++) {
        
        GJCFCoreTextLine *line = [self.linesArray objectAtIndex:index];
        
        NSRange subStringRange = NSMakeRange(line.stringRange.location, line.stringRange.length);
        
        NSString *subString = [_contentAttributedString.string substringWithRange:subStringRange];
        
        [resultString appendString:subString];
     
        if (index == limitLineCount - 1 ) {
            
            NSMutableString *mSubStringLast = [NSMutableString stringWithString:subString];
            
            [mSubStringLast replaceCharactersInRange:NSMakeRange(subStringRange.length - 1, 1) withString:@"..."];
            
            [resultString appendString:mSubStringLast];
        }
    }
    
    return resultString;
}

- (NSRange)getLimitNumberOfLineRange:(NSInteger)limitLineCount
{
    NSMutableString *resultString = [NSMutableString string];
    
    for (NSInteger index = 0 ; index < limitLineCount ; index ++) {
        
        GJCFCoreTextLine *line = [self.linesArray objectAtIndex:index];
        
        NSRange subStringRange = NSMakeRange(line.stringRange.location, line.stringRange.length);
        
        NSString *subString = [_contentAttributedString.string substringWithRange:subStringRange];
        
        [resultString appendString:subString];
    }

    return [_contentAttributedString.string rangeOfString:resultString];
}

- (void)setupSuggest
{
    CGSize constraitSize = CTFramesetterSuggestFrameSizeWithConstraints(_frameSetter, CFRangeMake(0, _contentAttributedString.length), NULL, _textFrame.size, NULL);
    _suggestHeigh = constraitSize.height;
    _suggestWidth = constraitSize.width;
}


- (GJCFCoreTextRun *)getLastTextRun
{
    GJCFCoreTextRun *run = nil;
    if (self.linesArray && [self.linesArray count] > 0) {
        GJCFCoreTextLine *line = [self.linesArray lastObject];
        if (line.numberOfGlyphs > 0) {
            run = [line glyphRunAtIndex:line.numberOfGlyphs - 1];
        }
        return run;
    }
    return run;
}
@end
