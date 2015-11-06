//
//  GJCFCoreTextRun.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-21.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import "GJCFCoreTextRun.h"

@interface GJCFCoreTextRun ()
{
    CTRunRef _run;
    
    /* 因为Run是Line的组成部分，所以，为了避免循环引用，我们用weak声明变量 */
    __weak GJCFCoreTextLine *_line;
}

@end

@implementation GJCFCoreTextRun

- (instancetype)initWithRun:(CTRunRef)ctRun withLine:(GJCFCoreTextLine *)ctLine
{
    if (self = [super init]) {
        
        _run = CFRetain(ctRun);
        
        _line = ctLine;
        
        [self setupRun];
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_run);
}

- (void)setupRun
{
    if (!_line) {
        return;
    }
    
    /* 获取当前行的起始位置 */
    CGFloat lineOffset;
    
    /* 获取上行，下行，行距 */
    _runRect.size.width = CTRunGetTypographicBounds(_run, CFRangeMake(0, 0), &_ascent, &_descent, &_leading);
    
    /* 获取字形的起始位置 */
    _lineOffsetX = CTLineGetOffsetForStringIndex([_line getLineRef], CTRunGetStringRange(_run).location, &lineOffset);
    _runRect.origin.x = _line.origin.x + _lineOffsetX;
    _runRect.origin.y = _line.origin.y - _descent;//基准线
    _runRect.size = (CGSize){_runRect.size.width,_ascent+_descent};
    
    _attributesDictionary = (NSDictionary *)CTRunGetAttributes(_run);
    
}


@end
