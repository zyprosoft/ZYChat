//
//  GJGCChatInputRecordAudioTipView.m
//  ZYChat
//
//  Created by ZYVincent on 14-10-29.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatInputRecordAudioTipView.h"
#import "GJCFCoreTextFrame.h"

@interface GJGCChatInputRecordAudioTipView ()

@property (nonatomic,strong)GJCFCoreTextAttributedStringStyle *stringStyle;

@property (nonatomic,strong)GJCFCoreTextFrame *textFrame;

@end

@implementation GJGCChatInputRecordAudioTipView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setupStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupStyle];
    }
    return self;
}

- (void)dealloc
{
    [GJCFNotificationCenter removeObserver:self];
}

- (void)setupStyle
{
    self.voiceCancelImage = GJCFQuickImage(@"聊天语音-icon-取消.png");
    self.voiceMicImage = GJCFQuickImage(@"聊天语音-icon-话筒.png");
    self.voiceSoundMeterImage = GJCFQuickImage(@"聊天语音-icon-音量.png");
    
    self.minRecordTimeErrorTitle = @"说话时间太短";
    self.maxRecordTimeErrorTitle = @"说话时间超长";
    self.upToCancelRecordTitle = @"手指上滑,取消发送";
    self.releaseToCancelRecordTitle = @"手指松开,取消发送";
    
    self.backgroundColor = GJCFQuickRGBColorAlpha(0, 0, 0, 0.5);
    self.gjcf_height = 178;
    self.gjcf_width = 178;
    self.center = (CGPoint){GJCFSystemScreenWidth/2,GJCFSystemScreenHeight/2};
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    
    self.leftMargin = (self.gjcf_width - self.voiceMicImage.size.width - self.voiceMicImage.size.width)/3;
    
    self.stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    self.stringStyle.foregroundColor = [UIColor whiteColor];
    self.stringStyle.strokeColor = [UIColor whiteColor];
    self.stringStyle.font = [UIFont boldSystemFontOfSize:14];
    
    /* 观察程序进入后台了 */
    [GJCFNotificationCenter addObserver:self selector:@selector(observeAppResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeAppResignActive:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)drawRect:(CGRect)rect
{
    
    /* 录音时间太短 */
    if (self.isTooShortRecordDuration || self.isTooLongRecordDuration) {
        
        NSString *errorText = @" ！";
        
        CGContextRef context = GJCFContextRefTextMatrixFromView(self);
        
        CGFloat errorWidth = 50;
        CGFloat tipHeight = 30;
        CGFloat tipWidth = 100;
        
        CGRect errorTextRect = CGRectMake((self.gjcf_width - errorWidth)/2,(self.gjcf_height - errorWidth )/2 - tipHeight, errorWidth, errorWidth);
        
        self.stringStyle.font = [UIFont boldSystemFontOfSize:35];
        
        [self drawTitle:errorText inRect:errorTextRect inContext:context];
        
        CGRect tipRect = CGRectMake((self.gjcf_width - tipWidth)/2, errorTextRect.origin.y+errorTextRect.size.height, tipWidth, tipHeight);
        
        self.stringStyle.font = [UIFont boldSystemFontOfSize:16];

        if (self.isTooShortRecordDuration) {
            
            [self drawTitle:self.minRecordTimeErrorTitle  inRect:tipRect inContext:context];
        }
        
        if (self.isTooLongRecordDuration){
            
            [self drawTitle:self.maxRecordTimeErrorTitle inRect:tipRect inContext:context];
        }

        return;
    }
    
    /* 录音状态 */
    CGRect micRect = CGRectZero;
    if (!self.willCancel) {
        
        if (self.voiceMicImage) {
            
            CGSize micSize = self.voiceMicImage.size;
            
            CGFloat topMargin = (self.bounds.size.height-micSize.height)/2;
            
            micRect = (CGRect){self.leftMargin,topMargin,micSize.width,micSize.height};
            
            [self.voiceMicImage drawInRect:micRect];
            
        }
        
        if (self.voiceSoundMeterImage) {
            
            if (self.soundMeter > 0) {
                
                CGRect rect = CGRectMake(0, self.voiceSoundMeterImage.size.height * self.voiceSoundMeterImage.scale * (1 - self.soundMeter), self.voiceSoundMeterImage.size.width * self.voiceSoundMeterImage.scale,  self.voiceSoundMeterImage.size.height * self.voiceSoundMeterImage.scale * self.soundMeter );
                
                
                CGImageRef imager = CGImageCreateWithImageInRect([self.voiceSoundMeterImage CGImage], rect);
                
                UIImage *image = [UIImage imageWithCGImage:imager scale:self.voiceSoundMeterImage.scale orientation:UIImageOrientationUp];
                
                CGImageRelease(imager);
                
                CGRect imageRect = (CGRect){self.leftMargin + self.voiceMicImage.size.width + self.leftMargin,micRect.origin.y+micRect.size.height-image.size.height,image.size.width,image.size.height};
                
                [image drawInRect:imageRect];
            }
            
        }
        
    }
    
    /* 准备取消录音 */
    CGRect cancleRect = CGRectZero;
    if (self.willCancel) {
        
        CGSize cancelSize = self.voiceCancelImage.size;
        
        CGFloat originX = (self.bounds.size.width - cancelSize.width)/2;
        
        CGFloat originY = (self.bounds.size.height - cancelSize.height)/2;
        
        cancleRect = (CGRect){originX,originY,cancelSize.width,cancelSize.height};
        
        [self.voiceCancelImage drawInRect:cancleRect];
        
    }
    
    /* 获取文本图形上下文 */
    CGContextRef context = GJCFContextRefTextMatrixFromView(self);
    
    if (self.willCancel) {
        
        CGRect textRect = CGRectMake(self.leftMargin, 5, self.bounds.size.width - 2*self.leftMargin, 30);
        
        [self drawTitle:self.releaseToCancelRecordTitle inRect:textRect inContext:context];
        
    }else{
        
        CGRect textRect = CGRectMake(self.leftMargin, 5, self.bounds.size.width - 2*self.leftMargin, 30);
        
        [self drawTitle:self.upToCancelRecordTitle inRect:textRect inContext:context];
    }
}

- (void)drawTitle:(NSString *)title inRect:(CGRect)rect inContext:(CGContextRef)context
{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:title attributes:[self.stringStyle attributedDictionary]];
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    [attriString addAttributes:[paragraphStyle paragraphAttributedDictionary] range:GJCFStringRange(title)];
    
    self.textFrame = [[GJCFCoreTextFrame alloc]initWithAttributedString:attriString withDrawRect:rect isNeedSetupLine:NO];
    
    [self.textFrame drawInContext:context];
    
    self.textFrame = nil;
}

#pragma mark - 设置属性影响
- (void)setSoundMeter:(CGFloat)soundMeter
{
    if (_soundMeter == soundMeter) {
        return;
    }
    _soundMeter = soundMeter;
    [self setNeedsDisplay];
}

- (void)setWillCancel:(BOOL)willCancel
{
    if (_willCancel == willCancel) {
        return;
    }
    _willCancel = willCancel;
    [self setNeedsDisplay];
}

- (void)setIsTooLongRecordDuration:(BOOL)isTooLongRecordDuration
{
    if (_isTooLongRecordDuration == isTooLongRecordDuration) {
        return;
    }
    _isTooLongRecordDuration = isTooLongRecordDuration;
    [self setNeedsDisplay];
}

- (void)setIsTooShortRecordDuration:(BOOL)isTooShortRecordDuration
{
    if (_isTooShortRecordDuration == isTooShortRecordDuration) {
        return;
    }
    _isTooShortRecordDuration = isTooShortRecordDuration;
    [self setNeedsDisplay];
}

#pragma mark - 观察程序进入后台

- (void)observeAppResignActive:(NSNotification *)noti
{
    [self removeFromSuperview];
}


@end
