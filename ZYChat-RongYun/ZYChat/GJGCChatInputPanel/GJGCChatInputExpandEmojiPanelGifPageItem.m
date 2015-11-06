//
//  GJGCChatInputExpandEmojiPanelGifPageItem.m
//  ZYChat
//
//  Created by ZYVincent on 15/6/3.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatInputExpandEmojiPanelGifPageItem.h"
#import "GJGCChatInputConst.h"
#import "GJGCChatInputExpandEmojiPanelGifSubItem.h"
#import "GJGCChatInputGifFloatView.h"
#import "GJGCChatInputPanel.h"

#define GJGCChatInputExpandEmojiPanelPageItemSubIconTag 3987652

@interface GJGCChatInputExpandEmojiPanelGifPageItem ()

@property (nonatomic,strong)NSMutableArray *emojiNamesArray;

@property (nonatomic,strong)GJGCChatInputGifFloatView *gifFloatView;

@property (nonatomic,strong)NSTimer *touchTimer;

@property (nonatomic,assign)BOOL isLongPress;

@property (nonatomic,assign)CGPoint longPressPoint;

@end

@implementation GJGCChatInputExpandEmojiPanelGifPageItem

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withEmojiNameArray:(NSArray *)emojiArray
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViewsWithEmojiNames:emojiArray];
    }
    return self;
}

- (void)initSubViewsWithEmojiNames:(NSArray *)emojiArray
{
    NSInteger rowCount = 2;
    NSInteger cloumnCount = 4;
    CGFloat emojiHeight = 69;
    CGFloat emojiWidth = GJCFSystemScreenWidth/4;
    
    CGFloat emojiMarginY = (self.bounds.size.height - rowCount * emojiHeight)/(rowCount + 1);
    
    for (int i = 0; i < emojiArray.count; i++) {
        
        NSInteger rowIndex = i/cloumnCount;
        NSInteger cloumnIndex = i%cloumnCount;
        
        NSString *iconName = [emojiArray objectAtIndex:i];
        
        GJGCChatInputExpandEmojiPanelGifSubItem *emojiView = [[GJGCChatInputExpandEmojiPanelGifSubItem alloc]initWithIconImageName:iconName withTitle:iconName];
        emojiView.gjcf_width = emojiWidth;
        emojiView.gjcf_height = emojiHeight;
        emojiView.gjcf_left = cloumnIndex*emojiWidth;
        emojiView.gjcf_top = (rowIndex+1)*emojiMarginY + rowIndex*emojiHeight;
        emojiView.tag = GJGCChatInputExpandEmojiPanelPageItemSubIconTag + i;
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnEmojiButton:)];
        [emojiView addGestureRecognizer:tapGesture];
        
        [self addSubview:emojiView];
        
    }
}

- (void)tapOnEmojiButton:(UITapGestureRecognizer *)tapR
{
    if (self.isLongPress) {
        return;
    }
    
    GJGCChatInputExpandEmojiPanelGifSubItem *item = (GJGCChatInputExpandEmojiPanelGifSubItem *)tapR.view;
    
    [item showHighlighted:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [item showHighlighted:NO];
        
    });
    
    NSString *emoji = item.iconNameLabel.text;
    
    NSDictionary *relationDict = [NSDictionary dictionaryWithContentsOfFile:GJCFMainBundlePath(@"gifCode.plist")];

    NSString *gifLocalId = [relationDict objectForKey:emoji];
    
    NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputExpandEmojiPanelChooseGIFEmojiNoti formateWithIdentifier:self.panelIdentifier];
    
    GJCFNotificationPostObj(formateNoti, gifLocalId);
}

- (GJGCChatInputGifFloatViewPosition)positionForItemIndex:(NSInteger)index
{
    if (index % 4 == 0) {
        
        return GJGCChatInputGifFloatViewPositionLeft;
    }
    
    if (index % 4 == 3) {
        
        return GJGCChatInputGifFloatViewPositionRight;
    }
    
    return GJGCChatInputGifFloatViewPositionCenter;
}

#pragma mark - longPress Item

- (void)longPressOnEmoji
{
    [self removeEmojiFloatViewFromPanelView];
    
    GJGCChatInputExpandEmojiPanelGifSubItem *emojiView = [self emojiViewByTouchPoint:self.longPressPoint];
    
    [emojiView showHighlighted:YES];
    
    NSInteger index = emojiView.tag - GJGCChatInputExpandEmojiPanelPageItemSubIconTag;

    NSString *gifName = [NSString stringWithFormat:@"%@.gif",emojiView.iconNameLabel.text];
    
    GJGCChatInputGifFloatViewPosition position = [self positionForItemIndex:index];
    
    CGRect convertToPanelRect = [emojiView convertRect:emojiView.iconFrame toView:self.panelView];
    
    GJGCChatInputGifFloatView *floatView = [[GJGCChatInputGifFloatView alloc]initWithPosition:position withGifName:gifName];
    floatView.gjcf_bottom = convertToPanelRect.origin.y - 3.f;
    
    switch (position) {
        case GJGCChatInputGifFloatViewPositionLeft:
        {
            floatView.gjcf_left = convertToPanelRect.origin.x;
        }
            break;
        case GJGCChatInputGifFloatViewPositionCenter:
        {
            floatView.gjcf_centerX = convertToPanelRect.origin.x+convertToPanelRect.size.width/2;
        }
            break;
        case GJGCChatInputGifFloatViewPositionRight:
        {
            floatView.gjcf_right = convertToPanelRect.origin.x+convertToPanelRect.size.width;
        }
            break;
        default:
            break;
    }
    
    [self.panelView addSubview:floatView];
}

- (void)removeEmojiFloatViewFromPanelView
{
    for (UIView *subView in self.panelView.subviews) {
        
        if ([subView.class isSubclassOfClass:[GJGCChatInputGifFloatView class]]) {
            
            [subView removeFromSuperview];
        }
    }
    
    for (UIView *subView in self.subviews) {
        
        if ([subView.class isSubclassOfClass:[GJGCChatInputExpandEmojiPanelGifSubItem class]]) {
            
            GJGCChatInputExpandEmojiPanelGifSubItem *item = (GJGCChatInputExpandEmojiPanelGifSubItem *)subView;
            
            [item showHighlighted:NO];
        }
    }
}

- (GJGCChatInputExpandEmojiPanelGifSubItem *)emojiViewByTouchPoint:(CGPoint)touchPoint
{
    for (UIView *subView in self.subviews) {
        
        if (CGRectContainsPoint(subView.frame, touchPoint)) {
            
            return (GJGCChatInputExpandEmojiPanelGifSubItem *)subView;
        }
    }
    
    return nil;
}

- (void)cancelLongPressOnEmoji
{
    [self removeEmojiFloatViewFromPanelView];
}

- (BOOL)isEmojiPressMoved:(CGPoint)moveToPoint
{
    GJGCChatInputExpandEmojiPanelGifSubItem *moveToItem = [self emojiViewByTouchPoint:moveToPoint];
    
    GJGCChatInputExpandEmojiPanelGifSubItem *currentItem = [self emojiViewByTouchPoint:self.longPressPoint];
    
    if (moveToItem.tag == currentItem.tag) {
        
        return NO;
        
    }
    
    return YES;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self startLongPressTimer];
    
    self.longPressPoint = [[touches anyObject] locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint anyPoint = [[touches anyObject] locationInView:self];
    
    if ([self isEmojiPressMoved:anyPoint]) {
        
        [self longPressOnEmoji];

    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopLongPressTimer];
    
    if (self.isLongPress) {
        
        [self cancelLongPressOnEmoji];
        
        self.isLongPress = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopLongPressTimer];

    if (self.isLongPress) {
        
        [self cancelLongPressOnEmoji];
        
        self.isLongPress = NO;
    }
}

-  (void)startLongPressTimer
{
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerCheckGestureRecognizer:) userInfo:nil repeats:NO];
}

- (void)stopLongPressTimer
{
    [self.touchTimer invalidate];
    
    self.touchTimer = nil;
}

- (void)timerCheckGestureRecognizer:(NSTimer *)timer
{
    [self stopLongPressTimer];
    
    self.isLongPress = YES;
    
    [self longPressOnEmoji];
}

@end
