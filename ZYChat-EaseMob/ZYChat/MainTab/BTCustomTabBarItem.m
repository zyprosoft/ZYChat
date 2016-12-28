//
//  BTCustomTabBarItem.m
//  BabyTrip
//
//  Created by ZYVincent on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "BTCustomTabBarItem.h"
#import "GJCFCoreTextFrame.h"

@interface BTCustomTabBarItem ()


@end

@implementation BTCustomTabBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf)];
        [self addGestureRecognizer:tapR];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize iconSize = self.normalIcon.size;
    
    CGFloat originX = (rect.size.width - iconSize.width)/2;
    CGFloat originY = (rect.size.height - iconSize.height)/2;
    
    CGRect iconRect = CGRectMake(originX, originY, iconSize.width, iconSize.height);
    
    if (_selected) {
        
        [self.selectedIcon drawInRect:iconRect];

        return;
    }
    
    [self.normalIcon drawInRect:iconRect];
}

- (GJCFCoreTextAttributedStringStyle *)stringStyle
{
    //当前是选中状态，那返回未选中状态
    if (!_selected) {
        
        GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
        stringStyle.foregroundColor = [UIColor blackColor];
        stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        
        return stringStyle;
    }
    
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle mainThemeColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

- (void)drawTitle:(NSString *)title inRect:(CGRect)rect inContext:(CGContextRef)context
{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:title attributes:[[self stringStyle] attributedDictionary]];
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    [attriString addAttributes:[paragraphStyle paragraphAttributedDictionary] range:GJCFStringRange(title)];
    
    GJCFCoreTextFrame *textFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:attriString withDrawRect:rect isNeedSetupLine:NO];
    
    [textFrame drawInContext:context];
    
}

- (void)setSelected:(BOOL)selected
{
    if (_selected == selected) {
        return;
    }
    _selected = selected;
    
    [self setNeedsDisplay];
}

- (void)tapOnSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customTabBarItemDidTapped:)]) {
        
        [self.delegate customTabBarItemDidTapped:self];
    }
}


@end
