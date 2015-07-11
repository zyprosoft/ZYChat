//
//  GJCFCoreTextContentView.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-21.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFCoreTextContentView.h"
#import "GJCFCoreTextFrame.h"
#import "GJCFUitils.h"


@interface GJCFCoreTextContentView ()

@property (nonatomic,strong)GJCFCoreTextFrame *ctFrame;

@property (nonatomic,strong)NSMutableDictionary *eventHanlderDict;

@property (nonatomic,strong)NSMutableArray *innerImageTagArray;

@property (nonatomic,strong)NSMutableDictionary *keywordRangeDict;

@property (nonatomic,strong)NSTimer *longPressTimer;

@property (nonatomic,strong)NSMutableArray *stateRectArray;

@property (nonatomic,strong)NSMutableArray *realImageInfoArray;

@property (nonatomic,assign)BOOL isLongPressing;

@property (nonatomic,assign)BOOL isHasImage;

@property (nonatomic,assign)BOOL isNeedSetupLine;

@property (nonatomic,strong)NSAttributedString *limitLineAttributedString;

/* 
 * 是否需要更新ctFrame,一般只需要在当前的contentAttributedString变化了之后才需要更新，
 * 为了提高效率，在不变的时候，不更新
 */
@property (nonatomic,assign)BOOL isNeedUpdateCTFrame;

/* 是否要支持长按事件 */
@property (nonatomic,assign)BOOL isSupportLongPressAction;

@property (nonatomic,copy)GJCFCoreTextContentViewLongPressHanlder longPressHandler;

@property (nonatomic,copy)GJCFCoreTextContentViewTapHanlder tapHandler;

/* 是否支持点击事件 */
@property (nonatomic,assign)BOOL enableTap;

/* 是否退出长按状态触摸 */
@property (nonatomic,assign)BOOL isTouchCancelLongPressStateNow;

/* 关键字圆角弧度 */
@property (nonatomic,strong)NSMutableDictionary *keywordRadiusDict;

@end

@implementation GJCFCoreTextContentView

- (id)init
{
    if (self = [super init]) {
        
        //默认
        [self initState];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initState];
    }
    return self;
}

- (void)dealloc
{
}

//设定初始化
- (void)initState
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;//默认没有交互

    //默认
    self.isSupportLongPressAction = NO;
    self.selectedStateColor = [UIColor colorWithRed:198/255.f green:198/255.f blue:198/255.f alpha:1.0];
    self.stateRectArray = [[NSMutableArray alloc]init];
    self.eventHanlderDict = [[NSMutableDictionary alloc]init];
    self.innerImageTagArray = [[NSMutableArray alloc]init];
    self.keywordRangeDict = [[NSMutableDictionary alloc]init];
    self.keywordRadiusDict = [[NSMutableDictionary alloc]init];
    self.realImageInfoArray = [[NSMutableArray alloc]init];
    
}

- (void)drawRect:(CGRect)rect
{
    if (!self.contentAttributedString) {
        return;
    }
    
    /* 获取文本绘制图形上下文 */
    CGContextRef context = GJCFContextRefTextMatrixFromView(self);
    
    /* 设置文本阴影 */
    CGContextSetShadowWithColor(context,
                                self.shadowOffset,
                                self.shadowBlurRadius,
                                self.shadowColor.CGColor);
    
    /* 状态背景 */
    for (NSArray *item in self.stateRectArray) {
        
        CGRect stateRect = [[item objectAtIndex:1] CGRectValue];
        UIColor *strokeColor = [item objectAtIndex:0];
        
        CGContextAddRect(context, stateRect);
        CGContextSetFillColorWithColor(context, strokeColor.CGColor);
        CGContextFillRect(context, stateRect);
        CGContextFillPath(context);
    }

    /* 设置ctFrame,只有在内容变化了之后才需要更新这个ctframe,这样可以提高效率,没有contentAttributedString 就不绘制了 */
    if (self.ctFrame && self.isNeedUpdateCTFrame ) {
        self.ctFrame = nil;
        
        if (self.eventHanlderDict.count > 0) {
            self.isNeedSetupLine = YES;
        }
        self.ctFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:self.contentAttributedString withDrawRect:self.bounds withImageTagArray:self.innerImageTagArray isNeedSetupLine:self.isNeedSetupLine];
        self.isNeedUpdateCTFrame = NO;
        
    }else if(!self.ctFrame){
        
        if (self.eventHanlderDict.count > 0) {
            self.isNeedSetupLine = YES;
        }
        //初始化ctFrame
        self.ctFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:self.contentAttributedString withDrawRect:self.bounds withImageTagArray:self.innerImageTagArray isNeedSetupLine:self.isNeedSetupLine];
        self.isNeedUpdateCTFrame = NO;
    }
    
    [self resetFrameByLimitLine];
    
    /* 绘制 */
    [self.ctFrame drawInContext:context];
    
    /* 如果不需要响应关键字点击事件，那么把coreText组件删除，因为已经绘制完成了 */
    if (self.eventHanlderDict.count == 0) {
        self.ctFrame = nil;
    }
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    if (_numberOfLines == numberOfLines - 1) {
        return;
    }
    _numberOfLines = numberOfLines - 1;
}

- (void)resetFrameByLimitLine
{
    if (self.ctFrame.linesArray.count > self.numberOfLines && self.numberOfLines != 0) {
        
        //获取限制行数的多态字符串
        if (!self.limitLineAttributedString) {
            
            NSString *limitString = [self.ctFrame getLimitNumberOfLineText:self.numberOfLines];
            NSRange limitRange = [self.ctFrame getLimitNumberOfLineRange:self.numberOfLines];
            NSRange longestRange = NSMakeRange(0, 0);
            
            NSDictionary *attributesDict = [self.contentAttributedString attributesAtIndex:limitRange.location longestEffectiveRange:&longestRange inRange:limitRange];
            
            NSAttributedString *resetContentString = [[NSAttributedString alloc]initWithString:limitString attributes:attributesDict];
            
            self.limitLineAttributedString = resetContentString;
        }
        
        self.contentAttributedString = self.limitLineAttributedString;
        
        self.isNeedUpdateCTFrame = YES;
        
        /* 设置ctFrame,只有在内容变化了之后才需要更新这个ctframe,这样可以提高效率,没有contentAttributedString 就不绘制了 */
        if (self.ctFrame && self.isNeedUpdateCTFrame ) {
            self.ctFrame = nil;
            
            if (self.eventHanlderDict.count > 0) {
                self.isNeedSetupLine = YES;
            }
            self.ctFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:self.contentAttributedString withDrawRect:self.bounds withImageTagArray:self.innerImageTagArray isNeedSetupLine:self.isNeedSetupLine];
            self.isNeedUpdateCTFrame = NO;
            
        }else if(!self.ctFrame){
            
            if (self.eventHanlderDict.count > 0) {
                self.isNeedSetupLine = YES;
            }
            //初始化ctFrame
            self.ctFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:self.contentAttributedString withDrawRect:self.bounds withImageTagArray:self.innerImageTagArray isNeedSetupLine:self.isNeedSetupLine];
            self.isNeedUpdateCTFrame = NO;
        }
        
    }
}

- (NSRange)visiableStringRange
{
    return [self.ctFrame visiableStringRange];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //清除原来的选中效果
    if (self.selected) {
        self.selected = NO;
        
        /* 直接返回 */
        self.isTouchCancelLongPressStateNow = YES;
        return;
    }
    
    //长按事件检测
    if (self.isSupportLongPressAction) {
        
        if (self.longPressTimer) {
            [self.longPressTimer invalidate];
            self.longPressTimer = nil;
        }
        self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(checkIfIsLongPressAction:) userInfo:nil repeats:NO];
    }
    
    /* 是否点击在关键字上 */
    __block BOOL isTapOnKeyword = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    //变换和CoreText一样的坐标系
    location.y = self.bounds.size.height - location.y;
    
    CFIndex tapStringIndex = [self.ctFrame stringIndexAtPoint:location];
    
    /* 遍历所有关键字range，找到在范围内的range */
    [self.keywordRangeDict enumerateKeysAndObjectsUsingBlock:^(NSString *keyword, NSArray  *rangeArray, BOOL *dictStop) {
        
        for (NSValue *rangeItem in rangeArray) {
            
            NSRange keywordRange = [rangeItem rangeValue];
            
            /* 如果找到了点击的关键字在范围内 */
            if (NSLocationInRange(tapStringIndex, keywordRange)) {
                                
                //绘制状态背景
                NSArray *eventRectArray = [self.ctFrame rectArrayForStringRange:keywordRange];
                [self.stateRectArray removeAllObjects];
                [eventRectArray enumerateObjectsUsingBlock:^(NSValue *rectValue, NSUInteger idx, BOOL *stop) {
                    
                    NSArray *itemArray = @[self.selectedStateColor,rectValue];
                    [self.stateRectArray addObject:itemArray];
                    
                }];
                [self setNeedsDisplay];
                //是点击在关键字上
                isTapOnKeyword = YES;
                *dictStop = YES;
                break;
            }

        }
        
        
    }];
    
    /* 如果支持整体点击事件 */
    if (!isTapOnKeyword && self.enableTap) {
        self.selected = YES;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //停止长按计时
    if (self.isSupportLongPressAction) {
        [self.longPressTimer invalidate];
        self.isLongPressing = NO;
        self.isTouchCancelLongPressStateNow = NO;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* 如果是退出长按的结束，那么直接退出 */
    if (self.isTouchCancelLongPressStateNow) {
        
        self.selected = NO;
        //停止长按计时
        if (self.isSupportLongPressAction) {
            [self.longPressTimer invalidate];
            self.isLongPressing = NO;
        }
        
        self.isTouchCancelLongPressStateNow = NO;
        return;
    }
    
    /* 是否点击在关键字上 */
    __block BOOL isTapOnKeyword = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    //变换和CoreText一样的坐标系
    location.y = self.bounds.size.height - location.y;
    
    CFIndex tapStringIndex = [self.ctFrame stringIndexAtPoint:location];
    
    /* 遍历所有关键字range，找到在范围内的range */
    [self.keywordRangeDict enumerateKeysAndObjectsUsingBlock:^(NSString *keyword, NSArray  *rangeArray, BOOL *dictStop) {
        
        for (NSValue *rangeItem in rangeArray) {
            
            NSRange keywordRange = [rangeItem rangeValue];
            
            /* 如果找到了点击的关键字在范围内 */
            if (NSLocationInRange(tapStringIndex, keywordRange)) {
                
                //不是长按事件才去响应，所以要判定为点击事件
                if (!self.isLongPressing) {
                    
                    GJCFCoreTextContentViewTouchHanlder handler = [self.eventHanlderDict objectForKey:keyword];
                    if (handler) {
                        handler(keyword,keywordRange);
                    }
                    
                    /* 让点击效果有持续时间 */
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //清除点击背景
                        [self.stateRectArray removeAllObjects];
                        [self setNeedsDisplay];
                    });
                    
                }

                //是点击在关键字上
                isTapOnKeyword = YES;
                *dictStop = YES;
                break;
                
            }
            
        }
        
    }];
    
    //响应点击事件 , 但是长按触发的时候，整体点击就要失效
    if (!isTapOnKeyword && self.enableTap && !self.isLongPressing) {
        self.selected = NO;
        
        //触发点击事件
        if (self.tapHandler) {
            self.tapHandler(self);
        }
    }
    
    //停止长按计时
    if (self.isSupportLongPressAction) {
        [self.longPressTimer invalidate];
        self.isLongPressing = NO;
    }
}

/* 检测是否长按事件 */
- (void)checkIfIsLongPressAction:(NSTimer*)timer
{
    //退出点击
    [self touchesCancelled:nil withEvent:nil];
    
    self.isLongPressing = YES;
        
    if (self.isLongPressShowSelectedState) {
        self.selected = YES;
    }
    
    if (self.longPressHandler) {
        
        /* 将图片空字符替换成真实图片字符 */
        NSString *contentString = [self imageInfoOriginSourceString];
        self.longPressHandler(self,contentString);
        
    }
}

#pragma mark - 属性设置
- (void)setContentAttributedString:(NSAttributedString *)contentAttributedString
{
    if (![contentAttributedString.class isSubclassOfClass:[NSAttributedString class]] || contentAttributedString.string.length == 0) {
        return;
    }
    
    if (!contentAttributedString) {
        return;
    }
    if ([_contentAttributedString isEqualToAttributedString:contentAttributedString]) {
        return;
    }
    _contentAttributedString = nil;
    _contentAttributedString = [contentAttributedString copy];

    /* 检测有没有图片 */
    for (NSString *imageTag in self.innerImageTagArray) {
        
        [self.contentAttributedString enumerateAttributesInRange:NSMakeRange(0, self.contentAttributedString.string.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            if ([attrs.allKeys containsObject:imageTag]) {
                
                self.isNeedSetupLine = YES;
                
                *stop = YES;
            }
            
        }];
    }
    
    self.isNeedUpdateCTFrame = YES;
    [self.eventHanlderDict removeAllObjects];
    [self.keywordRangeDict removeAllObjects];
    [self.stateRectArray removeAllObjects];
    [self.realImageInfoArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    if (_selected == selected) {
        return;
    }
    
    _selected = selected;
    
    /* 改变选中背景 */
    if (_selected) {
        [self.stateRectArray removeAllObjects];
        NSArray *itemArray = @[self.selectedStateColor,[NSValue valueWithCGRect:self.bounds]];
        [self.stateRectArray addObject:itemArray];
        [self setNeedsDisplay];
    }else{
        [self.stateRectArray removeAllObjects];
        [self setNeedsDisplay];
    }
}

- (void)setisTailMode:(BOOL)isTailMode
{
    if (_isTailMode == isTailMode) {
        return;
    }
    _isTailMode = isTailMode;
    
    /* 结尾省略号模式 */
    if (_isTailMode) {
        
        GJCFCoreTextParagraphStyle *trailStyle = [[GJCFCoreTextParagraphStyle alloc]init];
        trailStyle.lineBreakMode = kCTLineBreakByTruncatingTail;
        NSMutableAttributedString *contentAttriString = [[NSMutableAttributedString alloc]initWithAttributedString:self.contentAttributedString];
        [contentAttriString addAttributes:[trailStyle lineBreakModeSetting] range:NSMakeRange(0, contentAttriString.length)];
        self.contentAttributedString = contentAttriString;
    }
}

- (NSArray *)supportImageTagArray
{
    return self.innerImageTagArray;
}

- (CGFloat)contentBaseWidth
{
    return self.contentBaseSize.width;
}

- (CGFloat)contentBaseHeight
{
    return self.contentBaseSize.height;
}

- (void)setContentBaseWidth:(CGFloat)contentBaseWidth
{
    if (self.contentBaseSize.width == contentBaseWidth) {
        return;
    }
    self.contentBaseSize = CGSizeMake(contentBaseWidth,self.contentBaseSize.height);
}

- (void)setContentBaseHeight:(CGFloat)contentBaseHeight
{
    if (self.contentBaseSize.height == contentBaseHeight) {
        return;
    }
    self.contentBaseSize = CGSizeMake(self.contentBaseSize.width,contentBaseHeight);
}

#pragma mark - 实现类UILabel的属性设置

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted == highlighted) {
        return;
    }
    _highlighted = highlighted;
    
    if (_highlighted) {
        
        GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
        stringStyle.foregroundColor = self.highlightedTextColor;
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithAttributedString:self.contentAttributedString];
        [attriString addAttributes:[stringStyle foregroundColorAttributedDictionary] range:GJCFStringRange(self.text)];
        self.contentAttributedString = attriString ;
        
    }else{
        
        GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
        stringStyle.foregroundColor = self.textColor;
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithAttributedString:self.contentAttributedString];
        [attriString addAttributes:[stringStyle foregroundColorAttributedDictionary] range:GJCFStringRange(self.text)];
        self.contentAttributedString = attriString;

    }
    
    [self setNeedsDisplay];
}



- (NSString *)text
{
    return self.contentAttributedString.string;
}


- (void)setText:(NSString *)text
{
    if (GJCFStringIsNull(text)) {
        return;
    }
    
    if ([self.contentAttributedString.string isEqualToString:text]) {
        return;
    }
    
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = self.font? self.font:[UIFont systemFontOfSize:14];
    stringStyle.foregroundColor = self.textColor? self.textColor:[UIColor blackColor];
    stringStyle.strokeColor = self.textColor? self.textColor:[UIColor blackColor];
    
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.mutilRowHeight = self.lineHeight;
    
    paragraphStyle.lineBreakMode = kCTLineBreakByCharWrapping;//default
    switch (self.lineBreakMode) {
        case NSLineBreakByCharWrapping:
        {
            paragraphStyle.lineBreakMode = kCTLineBreakByCharWrapping;
        }
            break;
        case NSLineBreakByClipping:
        {
            paragraphStyle.lineBreakMode = kCTLineBreakByClipping;
        }
            break;
        case NSLineBreakByTruncatingHead:
        {
            paragraphStyle.lineBreakMode = kCTLineBreakByTruncatingHead;
        }
            break;
        case NSLineBreakByTruncatingMiddle:
        {
            paragraphStyle.lineBreakMode = kCTLineBreakByTruncatingMiddle;
        }
            break;
        case NSLineBreakByTruncatingTail:
        {
            paragraphStyle.lineBreakMode = kCTLineBreakByTruncatingTail;
        }
            break;
        case NSLineBreakByWordWrapping:
        {
            paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        }
            break;
        default:
            break;
    }
    
    if (self.numberOfLines != 0) {
        paragraphStyle.lineBreakMode = kCTLineBreakByTruncatingTail;
    }
    
    paragraphStyle.alignment = kCTTextAlignmentLeft;//default
    switch (self.alignment) {
        case NSTextAlignmentCenter:
        {
            paragraphStyle.alignment = kCTTextAlignmentCenter;
        }
            break;
        case NSTextAlignmentJustified:
        {
            paragraphStyle.alignment = kCTTextAlignmentJustified;
        }
            break;
        case NSTextAlignmentLeft:
        {
            paragraphStyle.alignment = kCTTextAlignmentLeft;
        }
            break;
        case NSTextAlignmentNatural:
        {
            paragraphStyle.alignment = kCTTextAlignmentNatural;
        }
            break;
        case NSTextAlignmentRight:
        {
            paragraphStyle.alignment = kCTTextAlignmentRight;
        }
            break;
        default:
            break;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttributes:[stringStyle attributedDictionary] range:GJCFStringRange(text)];
    [attributedString addAttributes:[paragraphStyle paragraphAttributedDictionary] range:GJCFStringRange(text)];
    
    self.contentAttributedString = nil;
    self.contentAttributedString = attributedString;
    
    //自动调整frame
    [self sizeToFit];
}


#pragma mark 公开接口

/* 计算高度 */
+ (CGFloat)contentHeightForAttributedString:(NSAttributedString *)attributedString forContentSize:(CGSize)contentSize;
{
    if (!attributedString) {
        return 0.f;
    }
    GJCFCoreTextFrame *ctFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:attributedString withDrawRect:(CGRect){0,0,contentSize.width,contentSize.height} isNeedSetupLine:NO];

    return ctFrame.suggestHeigh;
}

/* 计算内容一行情况下的真实宽度 */
+ (CGFloat)contentWidthForAttributedString:(NSAttributedString *)attributedString forContentSize:(CGSize)contentSize
{
    if (!attributedString) {
        return 0.f;
    }
    GJCFCoreTextFrame *ctFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:attributedString withDrawRect:(CGRect){0,0,contentSize.width,contentSize.height} isNeedSetupLine:NO];

    return ctFrame.suggestWidth;
}

/* 为某个特定的字符串设定 */
- (void)appenTouchObserverForKeyword:(NSString *)keyword withHanlder:(GJCFCoreTextContentViewTouchHanlder)handler
{
    if (!keyword) {
        return;
    }
    
    /* 记录所有位置 */
    if (self.eventHanlderDict.count == 0) {
         self.isNeedUpdateCTFrame = YES;
    }
    
    NSArray *keywordRangeArray = [GJCFCoreTextKeywordAttributedStringStyle getAllKeywordRangeFromString:self.contentAttributedString.string forKeyword:keyword];
    [self.keywordRangeDict setObject:keywordRangeArray forKey:keyword];
    
    if (handler) {
        [self.eventHanlderDict setObject:handler forKey:keyword];
    }
    
    self.userInteractionEnabled = YES;
    [self setNeedsDisplay];

}

/* 为一个关键设定所有的关键范围 */
- (void)appendKeywordRangeArray:(NSArray *)keywordRangeArray forKeyword:(NSString *)keyword
{
    if (!keywordRangeArray || keyword) {
        return;
    }
    
    [self.keywordRangeDict setObject:keywordRangeArray forKey:keyword];
}

- (void)appendImageTag:(NSString *)imageTagName
{
    if (!imageTagName) {
        return;
    }
    [self.innerImageTagArray addObject:imageTagName];
}

/* 记录一个图片标记被插入的图片的真实字符串内容 */
- (void)appendImageInfo:(NSDictionary *)imageInfo
{
    if (!imageInfo) {
        return;
    }
    
    /* 如果没有包含必须的两个key，那么是非法数据 */
    if (![imageInfo.allKeys containsObject:kGJCFCoreTextImageInfoRangeKey] || ![imageInfo.allKeys containsObject:kGJCFCoreTextImageInfoStringKey]) {
        return;
    }
    
    [self.realImageInfoArray addObject:imageInfo];
    
    if (self.realImageInfoArray.count > 0) {
        self.isNeedSetupLine = YES;
    }
}

/* 替换所有的图片信息成新的 */
- (void)replaceAllImageInfosWithArray:(NSArray *)newImageInfos
{
    if (!newImageInfos) {
        return;
    }
    
    if (self.realImageInfoArray && [self.realImageInfoArray count] > 0) {
        [self.realImageInfoArray removeAllObjects];
    }
    
    [self.realImageInfoArray addObjectsFromArray:newImageInfos];
    
    if (self.realImageInfoArray.count > 0) {
        self.isNeedSetupLine = YES;
    }
}

- (void)setLongPressEventHandler:(GJCFCoreTextContentViewLongPressHanlder)longPressBlock
{
    if (!longPressBlock) {
        return;
    }
    
    if (self.longPressHandler) {
        self.longPressHandler = nil;
    }
    
    self.longPressHandler = longPressBlock;
    self.isSupportLongPressAction = YES;//观察的话，默认就要允许长按事件执行
}

- (void)setTapActionHandler:(GJCFCoreTextContentViewTapHanlder)tapBlock
{
    if (!tapBlock) {
        return;
    }
    
    if (self.tapHandler) {
        self.tapHandler = nil;
    }
    
    self.tapHandler = tapBlock;
    self.enableTap = YES;
}

/* 自动根据内容调整大小 */
- (void)sizeToFit
{
    if (!self.contentAttributedString) {
        return;
    }
    
    CGFloat contentConstriantWidth = self.contentBaseWidth >0? self.contentBaseWidth:self.gjcf_width;
    CGFloat contentConstriantHeight = self.contentBaseHeight >0? self.contentBaseHeight:self.gjcf_height;
    
    /* 先判断当前的高度是否够 */
    CGFloat suggestHeight = [GJCFCoreTextContentView contentHeightForAttributedString:self.contentAttributedString forContentSize:CGSizeMake(contentConstriantWidth, CGFLOAT_MAX)];
    
    //高度小于当前视图的高度
    if (suggestHeight <= contentConstriantHeight) {
        
        //判断宽度是否不到现在视图的宽度
        CGFloat suggestWidth = [GJCFCoreTextContentView contentWidthForAttributedString:self.contentAttributedString forContentSize:CGSizeMake(CGFLOAT_MAX, contentConstriantHeight)];
        
        //如果不到目前视图的宽度，说明宽也太长了，需要宽高都变紧凑
        if (suggestWidth < contentConstriantWidth) {
            
            self.gjcf_width = suggestWidth;
        }
        
        //高度调整
        self.gjcf_height = suggestHeight;
        
    }else{
        
        //如果不是省略号模式
        if (!self.isTailMode) {
            
            //高度调整
            self.gjcf_height = suggestHeight;
            
        }
    }
}

/* 获取一个基于基础的Size的自适应大小 */
+ (CGSize)contentSuggestSizeWithAttributedString:(NSAttributedString *)attributedString forBaseContentSize:(CGSize)contentSize
{
    if (!attributedString || attributedString.string.length == 0) {
        return contentSize;
    }
    
    /* 先判断当前的高度是否够 */
    CGFloat suggestHeight = [GJCFCoreTextContentView contentHeightForAttributedString:attributedString forContentSize:CGSizeMake(contentSize.width, CGFLOAT_MAX)];
    
    //高度小于当前视图的高度
    if (suggestHeight <= contentSize.height) {
        
        //高度调整
        contentSize.height = suggestHeight;
        
        //判断宽度是否不到现在视图的宽度
        CGFloat suggestWidth = [GJCFCoreTextContentView contentWidthForAttributedString:attributedString forContentSize:CGSizeMake(CGFLOAT_MAX, contentSize.height)];
        
        //如果不到目前视图的宽度，说明宽也太长了，需要宽高都变紧凑
        if (suggestWidth < contentSize.width) {
            
            contentSize.width = suggestWidth;
        }
        
    }else{
        
        contentSize.height = suggestHeight;
        
        //判断宽度是否不到现在视图的宽度
        CGFloat suggestWidth = [GJCFCoreTextContentView contentWidthForAttributedString:attributedString forContentSize:CGSizeMake(CGFLOAT_MAX, contentSize.height)];
        
        //如果不到目前视图的宽度，说明宽也太长了，需要宽高都变紧凑
        if (suggestWidth < contentSize.width) {
            
            contentSize.width = suggestWidth;
        }
    }
    
    return contentSize;
}

+ (CGSize)contentSuggestSizeWithAttributedString:(NSAttributedString *)attributedString forBaseContentSize:(CGSize)contentSize maxNumberOfLine:(NSInteger)lineCount
{
    if (!attributedString || attributedString.string.length == 0) {
        return contentSize;
    }
    
    if (!attributedString) {
        return CGSizeMake(contentSize.width, 0);
    }
    
    /* 先判断当前的高度是否够 */
    CGFloat suggestHeight = [GJCFCoreTextContentView contentHeightForAttributedString:attributedString forContentSize:CGSizeMake(contentSize.width, CGFLOAT_MAX)];
    
    //高度小于当前视图的高度
    if (suggestHeight <= contentSize.height) {
        
        //高度调整
        contentSize.height = suggestHeight;
        
        //判断宽度是否不到现在视图的宽度
        CGFloat suggestWidth = [GJCFCoreTextContentView contentWidthForAttributedString:attributedString forContentSize:CGSizeMake(CGFLOAT_MAX, contentSize.height)];
        
        //如果不到目前视图的宽度，说明宽也太长了，需要宽高都变紧凑
        if (suggestWidth < contentSize.width) {
            
            contentSize.width = suggestWidth;
        }
        
    }else{
        
        contentSize.height = suggestHeight;
        
        //判断宽度是否不到现在视图的宽度
        CGFloat suggestWidth = [GJCFCoreTextContentView contentWidthForAttributedString:attributedString forContentSize:CGSizeMake(CGFLOAT_MAX, contentSize.height)];
        
        //如果不到目前视图的宽度，说明宽也太长了，需要宽高都变紧凑
        if (suggestWidth < contentSize.width) {
            
            contentSize.width = suggestWidth;
        }
    }
    
    //根据最大行数来返回自适应高度,先计算出最大行数的字符串
    GJCFCoreTextFrame *ctFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:attributedString withDrawRect:(CGRect){0,0,contentSize.width,contentSize.height} isNeedSetupLine:YES];
    
    if (ctFrame.linesArray.count > lineCount) {
        
        NSString *limitString = [ctFrame getLimitNumberOfLineText:lineCount];
        NSRange limitRange = [ctFrame getLimitNumberOfLineRange:lineCount];
        NSRange longestRange = NSMakeRange(0, 0);
        
        NSDictionary *attributesDict = [ctFrame.contentAttributedString attributesAtIndex:limitRange.location longestEffectiveRange:&longestRange inRange:limitRange];
        
        NSAttributedString *resetContentString = [[NSAttributedString alloc]initWithString:limitString attributes:attributesDict];
        
        attributedString = resetContentString;
        
        contentSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:attributedString forBaseContentSize:contentSize];
        
    }
    
    return contentSize;
}

/* 清除关键字观察事件 */
- (void)clearKeywordTouchEventHanlder
{
    [self.eventHanlderDict removeAllObjects];
}

- (NSString *)imageInfoOriginSourceString
{
    if (self.contentAttributedString) {
        
        NSMutableString *contentString = [NSMutableString stringWithString:self.contentAttributedString.string];
        
        /* 位置增长游标,因为每次替换一个图片的原字符之后，下一个图片标记的的位置就要增长了，所以设置一个游标来记录增长 */
        __block NSInteger rangeIncreaseCursor = 0;
        [self.realImageInfoArray enumerateObjectsUsingBlock:^(NSDictionary *imageInfo, NSUInteger idx, BOOL *stop) {
            NSRange imageRange = [[imageInfo objectForKey:kGJCFCoreTextImageInfoRangeKey]rangeValue];
            NSString *imageSourceString = [imageInfo objectForKey:kGJCFCoreTextImageInfoStringKey];
            
            /* 重新计算range */
            imageRange = NSMakeRange(imageRange.location + rangeIncreaseCursor, imageRange.length);
            
            [contentString replaceCharactersInRange:imageRange withString:imageSourceString];
            rangeIncreaseCursor = rangeIncreaseCursor + imageSourceString.length -1;
        }];
        
        return contentString;
    }
    return nil;
}


- (CGPoint)lastCharPostion:(BOOL)isCharTop
{
    
    if (!self.ctFrame) {
        self.ctFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:self.contentAttributedString withDrawRect:self.bounds withImageTagArray:self.innerImageTagArray isNeedSetupLine:self.isNeedSetupLine];
    }
    GJCFCoreTextRun *run = [self.ctFrame getLastTextRun];
    
    CGFloat positionY =  self.frame.size.height - run.runRect.origin.y - run.runRect.size.height;
    if (!isCharTop) {
        positionY =  self.frame.size.height - run.runRect.origin.y;
    }
    CGFloat positionX =  run.runRect.origin.x + run.runRect.size.width;
    return CGPointMake(positionX, positionY);
}
@end
