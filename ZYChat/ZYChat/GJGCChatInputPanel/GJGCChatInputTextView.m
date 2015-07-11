//
//  GJGCInputTextView.m
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatInputTextView.h"
#import "GJGCChatInputConst.h"
#import "GJGCChatInputRecordAudioTipView.h"
#import <AVFoundation/AVFoundation.h>

#define kTextInsetX 2
#define kTextInsetBottom 0

@interface GJGCChatInputTextView ()<UITextViewDelegate>

/**
 *  文本输入
 */
@property (nonatomic,strong)UITextView *textView;

/**
 *  录音时按住的按钮
 */
@property (nonatomic,strong)UIButton   *recordButton;

/**
 *  背景图片
 */
@property (nonatomic,strong)UIImageView *inputBackgroundImageView;

/**
 *  frame变化
 */
@property (nonatomic,copy)GJGCChatInputTextViewFrameDidChangeBlock frameChangeBlock;

/**
 *  录音动作变化
 */
@property (nonatomic,copy)GJGCChatInputTextViewRecordActionChangeBlock actionChangeBlock;

/**
 *  完成输入
 */
@property (nonatomic,copy)GJGCChatInputTextViewFinishInputTextBlock finishInputBlock;

/**
 *  录音提示视图
 */
@property (nonatomic,strong)GJGCChatInputRecordAudioTipView *recordTipView;

@property (nonatomic,copy)GJGCChatInputTextViewDidBecomeFirstResponseBlock responseBlock;

@property (nonatomic,strong)NSTimer *minRecordActionTimer;

@property (nonatomic,assign)BOOL isRecordStartRight;

@property (nonatomic,assign)NSInteger selectCharIndex;

@property (nonatomic,strong)NSTextContainer *textContainer;

@property (nonatomic,strong)UILabel *placeHolderLabel;

@end

@implementation GJGCChatInputTextView

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViewsWithFrame:frame];
    }
    return self;
}

- (void)dealloc
{
    [self removeRecordTipView];
    [GJCFNotificationCenter removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /* 当前显示状态 */
    if (_recordState) {
        self.textView.hidden = YES;
        self.inputBackgroundImageView.hidden = YES;
        self.recordButton.hidden = NO;
    }else{
        self.recordButton.hidden = YES;
        self.textView.hidden = NO;
        self.inputBackgroundImageView.hidden = NO;
    }
    
    /*  */
    self.inputBackgroundImageView.frame = self.bounds;
    self.placeHolderLabel.frame = self.textView.frame;
    self.placeHolderLabel.gjcf_left = self.textView.gjcf_left + 4.f;
    
    /* */
    self.recordButton.frame = self.bounds;
    
}

#pragma mark - 内部接口

- (void)initSubViewsWithFrame:(CGRect)frame
{
    _inputTextStateHeight = self.gjcf_height;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGRect backgroundFrame = self.frame;
    backgroundFrame.origin.y = 0;
    backgroundFrame.origin.x = 0;
    
    self.inputBackgroundImageView = [[UIImageView alloc]init];
    self.inputBackgroundImageView.frame = backgroundFrame;
    self.inputBackgroundImageView.userInteractionEnabled = YES;
    [self addSubview:self.inputBackgroundImageView];
    
    CGRect textViewFrame = CGRectInset(backgroundFrame, kTextInsetX, kTextInsetX);
    textViewFrame.size.height = self.frame.size.height - 2*kTextInsetX;
    
    //http://stackoverflow.com/questions/18826199/uitextview-contentsize-changes-and-nslayoutmanager-in-ios7/19113421#19113421
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        NSTextStorage* textStorage = [[NSTextStorage alloc] initWithString:@""];
        NSLayoutManager* layoutManager = [NSLayoutManager new];
        [textStorage addLayoutManager:layoutManager];
        self.textContainer = [[NSTextContainer alloc] initWithSize:textViewFrame.size];
        [layoutManager addTextContainer:self.textContainer];
        
        self.textView = [[UITextView alloc] initWithFrame:textViewFrame textContainer:self.textContainer];
        
    }else{
        
        self.textView = [[UITextView alloc] initWithFrame:textViewFrame];

    }

    self.textView.delegate        = self;
    self.textView.font            = [UIFont systemFontOfSize:16.0];
    self.textView.contentInset    = UIEdgeInsetsMake(-4,0,-4,0);
    self.textView.opaque          = NO;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    [self addSubview:self.textView];
    
    self.placeHolderLabel = [[UILabel alloc]init];
    self.placeHolderLabel.frame = self.textView.frame;
    self.placeHolderLabel.gjcf_left = self.textView.gjcf_left + 4.f;
    self.placeHolderLabel.backgroundColor = [UIColor clearColor];
    self.placeHolderLabel.textColor = GJCFQuickHexColor(@"909090");
    self.placeHolderLabel.font = self.textView.font;
    [self addSubview:self.placeHolderLabel];
    self.placeHolderLabel.hidden = YES;
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = self.bounds;
    self.recordButton.backgroundColor = [UIColor clearColor];
    self.recordButton.layer.cornerRadius = 2.f;
    self.recordButton.layer.masksToBounds = YES;
    [self.recordButton setTitleColor:[GJGCChatInputPanelStyle mainThemeColor] forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[GJGCChatInputPanelStyle mainThemeColor] forState:UIControlStateHighlighted];
    [self.recordButton setBackgroundImage:GJCFQuickImageByColorWithSize([UIColor colorWithWhite:0 alpha:0.1], self.recordButton.gjcf_size) forState:UIControlStateHighlighted];
    [self addSubview:self.recordButton];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(longPressRecordButton:)];
    
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnRecordButton:)];
    [self.recordButton addGestureRecognizer:tapR];
    
    longPress.cancelsTouchesInView = NO;
    longPress.minimumPressDuration = 0.15;
    [self.recordButton addGestureRecognizer:longPress];
    
    self.maxAutoExpandHeight = 100.f;
    self.minAutoExpandHeight = 32.f;
    
}

#pragma mark - 内部接口

- (void)setPanelIdentifier:(NSString *)panelIdentifier
{
    if ([_panelIdentifier isEqualToString:panelIdentifier]) {
        return;
    }
    _panelIdentifier = nil;
    _panelIdentifier = [panelIdentifier copy];
    
    [self observeRequiredNoti];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if ([_placeHolder isEqualToString:placeHolder]) {
        return;
    }
    
    _placeHolder = nil;
    _placeHolder = [placeHolder copy];
    self.placeHolderLabel.text = _placeHolder;
    
    if (self.textView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
}

#pragma mark - 观察必要通知
- (void)observeRequiredNoti
{
    /* 观察输入音量 */
    NSString *soundMeterNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewRecordSoundMeterNoti formateWithIdentifier:self.panelIdentifier];
    NSString *recordTooShortNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewRecordTooShortNoti formateWithIdentifier:self.panelIdentifier];
    NSString *recordTooLongNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewRecordTooLongNoti formateWithIdentifier:self.panelIdentifier];
    NSString *setMessageDraftNoti = [GJGCChatInputConst panelNoti:GJGCChatInputSetLastMessageDraftNoti formateWithIdentifier:self.panelIdentifier];
    NSString *emojiDeleteNoti = [GJGCChatInputConst panelNoti:GJGCChatInputExpandEmojiPanelChooseDeleteNoti formateWithIdentifier:self.panelIdentifier];
    NSString *chooseEmojiNoti = [GJGCChatInputConst panelNoti:GJGCChatInputExpandEmojiPanelChooseEmojiNoti formateWithIdentifier:self.panelIdentifier];
    NSString *appendTextNoti = [GJGCChatInputConst panelNoti:GJGCChatInputPanelNeedAppendTextNoti formateWithIdentifier:self.panelIdentifier];
    
    [GJCFNotificationCenter addObserver:self selector:@selector(observeRecordSoundMeter:) name:soundMeterNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeRecordTooShort:) name:recordTooShortNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeRecordTooLong:) name:recordTooLongNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeSetLastMessageDraft:) name:setMessageDraftNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeEmojiPanelChooseDeleteNoti:) name:emojiDeleteNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeEmojiPanelChooseEmojiNoti:) name:chooseEmojiNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeAppendFocusOnOther:) name:appendTextNoti object:nil];

}

- (void)observeAppendFocusOnOther:(NSNotification *)noti
{
    NSString *appendText = (NSString *)noti.object;
    
    if (GJCFStringIsNull(appendText)) {
        return;
    }
    
    if ([self.textView.text rangeOfString:appendText].location != NSNotFound) {
        return;
    }
    
    if (GJCFStringIsNull(self.textView.text)) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,appendText];
    }else{
        self.textView.text = [NSString stringWithFormat:@"%@ %@",self.textView.text,appendText];
    }
    
    NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewContentChangeNoti formateWithIdentifier:self.panelIdentifier];
    [GJCFNotificationCenter postNotificationName:formateNoti object:self.textView.text];
    
    [self becomeFirstResponder];
    
    /* 保留500字 */
    if (self.textView.text.length > 500 ) {
        
        self.textView.text = [self.textView.text substringToIndex:499];
        
    }
    
    [self updateDisplayByInputContentTextChange];
}

- (void)observeSetLastMessageDraft:(NSNotification *)noti
{
    if (noti.object) {
        
        self.textView.text = noti.object;
        
        [self performSelector:@selector(updateDisplayByInputContentTextChange) withObject:nil afterDelay:0.5];
    }
}

- (void)setRecordState:(BOOL)recordState
{
    if (_recordState == recordState) {
        return;
    }
    _recordState = recordState;
    if (!_recordState) {
        [self becomeFirstResponder];
    }else{
        [self resignFirstResponder];
    }
    [self setNeedsLayout];
}

- (void)setContent:(NSString *)content
{
    if ([self.textView.text isEqualToString:content]) {
        return;
    }
    self.textView.text = content;
}

- (NSString *)content
{
   return  self.textView.text;
}

- (void)resignFirstResponder
{
    [self.textView resignFirstResponder];
}

- (BOOL)isInputTextFirstResponse
{
    return [self.textView isFirstResponder];
}

- (void)becomeFirstResponder
{
    [self.textView becomeFirstResponder];
}

- (void)expandTextViewToHeight:(CGFloat)height
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];

    self.gjcf_height = height;
    
    _inputTextStateHeight = self.gjcf_height;
    
    [UIView commitAnimations];
    
    /* 文本视图 */
    self.textView.frame = CGRectMake(2, 2, self.gjcf_width - 4, self.gjcf_height - 4);
    
}

- (void)layoutInputTextView
{
    [self.textView scrollRectToVisible:CGRectMake(0, self.textView.contentSize.height - self.textView.frame.size.height, self.textView.frame.size.width,self.textView.frame.size.height) animated:NO];
}

- (void)updateDisplayByInputContentTextChange
{
    if (self.textView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
    
    CGSize contentSize = self.textView.contentSize;
    
    if (contentSize.height - 8.f > self.textView.bounds.size.height && self.frame.size.height <= self.maxAutoExpandHeight) {
        
        CGFloat changeDelta = contentSize.height - 8.f - self.frame.size.height;
        
        [self expandTextViewToHeight:contentSize.height - 8.f];
        
        if (self.frameChangeBlock) {
            self.frameChangeBlock(self,changeDelta);
        }

    }else if(contentSize.height - 8.f  < self.textView.bounds.size.height && contentSize.height > self.minAutoExpandHeight){
        
        CGFloat minHeight = MAX(self.minAutoExpandHeight, contentSize.height);
        if (contentSize.height - self.minAutoExpandHeight < 5) {
            minHeight = self.minAutoExpandHeight;
        }
        
        CGFloat changeDelta = minHeight - self.frame.size.height;
        
        [self expandTextViewToHeight:minHeight];
        
        if (self.frameChangeBlock) {
            self.frameChangeBlock(self,changeDelta);
        }
        
    }
}

- (void)setInputTextBackgroundImage:(UIImage *)inputTextBackgroundImage
{
    if (_inputTextBackgroundImage == inputTextBackgroundImage) {
        return;
    }
    _inputTextBackgroundImage = inputTextBackgroundImage;
    self.inputBackgroundImageView.image = GJCFImageResize(_inputTextBackgroundImage, 2, 2, 2, 2);
}

- (void)setRecordAudioBackgroundImage:(UIImage *)recordAudioBackgroundImage
{
    if (_recordAudioBackgroundImage == recordAudioBackgroundImage) {
        return;
    }
    _recordAudioBackgroundImage = recordAudioBackgroundImage;
    [self.recordButton setBackgroundImage:GJCFImageResize(_recordAudioBackgroundImage, 2, 2, 2, 2) forState:UIControlStateNormal];
}

- (void)setRecordingTitle:(NSString *)recordingTitle
{
    if ([_recordingTitle isEqualToString:recordingTitle]) {
        return;
    }
    _recordingTitle = nil;
    _recordingTitle = [recordingTitle copy];
    [self.recordButton setTitle:_recordingTitle forState:UIControlStateHighlighted];
}

- (void)setPreRecordTitle:(NSString *)preRecordTitle
{
    if ([_preRecordTitle isEqualToString:preRecordTitle]) {
        return;
    }
    _preRecordTitle = nil;
    _preRecordTitle = [preRecordTitle copy];
    [self.recordButton setTitle:_preRecordTitle forState:UIControlStateNormal];
}


#pragma mark - 录音按钮触摸检测
- (void)showRecordTipView
{
    [self removeRecordTipView];
    self.recordTipView = [[GJGCChatInputRecordAudioTipView alloc]init];
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.recordTipView];
}

- (void)removeRecordTipView
{
    if (self.recordTipView.isTooShortRecordDuration) {
        
        GJCFAsyncMainQueueDelay(0.5, ^{
            
            if (self.recordTipView) {
                [self.recordTipView removeFromSuperview];
                self.recordTipView = nil;
            }
            
        });
        
        return;
    }
    
    if (self.recordTipView) {
        [self.recordTipView removeFromSuperview];
        self.recordTipView = nil;
    }
    
}
- (void)observeRecordSoundMeter:(NSNotification *)noti
{
    CGFloat soundMeter = [noti.object floatValue];
    self.recordTipView.soundMeter = soundMeter;
}

- (void)observeRecordTooShort:(NSNotification *)noti
{
    self.recordTipView.isTooShortRecordDuration = YES;
    [self removeRecordTipView];
}

- (void)observeRecordTooLong:(NSNotification *)noti
{
    [self removeRecordTipView];
}

#pragma mark - 观察表情键盘通知

- (void)deleteLastEmoji
{
    if(GJCFStringIsNull(self.textView.text))
    {
        return;
    }
    
    if ([[self.textView.text substringFromIndex:self.textView.text.length-1] isEqualToString:@"]"]) {
        
        NSInteger lastCharCursor = self.textView.text.length - 1;
        
        NSInteger innerCharCount = 0;
        while (lastCharCursor >= 0) {
            
            NSString * lastChar = [self.textView.text substringWithRange:NSMakeRange(lastCharCursor, 1)];

            if ([lastChar isEqualToString:@"["]) {
                
                break;
                
            }
            lastCharCursor--;
            innerCharCount ++;
        }
        
        if (innerCharCount > 4) {
            
            [self.textView deleteBackward];
            
            NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewContentChangeNoti formateWithIdentifier:self.panelIdentifier];
            [GJCFNotificationCenter postNotificationName:formateNoti object:self.textView.text];
            
            return;
        }
        
        self.textView.text = [self.textView.text substringToIndex:lastCharCursor];
        
        NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewContentChangeNoti formateWithIdentifier:self.panelIdentifier];
        [GJCFNotificationCenter postNotificationName:formateNoti object:self.textView.text];
        
    }else{
        
        [self.textView deleteBackward];
        
        NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewContentChangeNoti formateWithIdentifier:self.panelIdentifier];
        [GJCFNotificationCenter postNotificationName:formateNoti object:self.textView.text];
        
    }
}

- (void)observeEmojiPanelChooseEmojiNoti:(NSNotification *)noti
{
    NSString *emoji = noti.object;
    
    self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,emoji];
    
    [self performSelector:@selector(updateDisplayByInputContentTextChange) withObject:nil afterDelay:0.1];
    
    CGFloat visiableOriginY = self.textView.contentSize.height - self.textView.bounds.size.height;
    
    if (self.textView.contentSize.height > self.textView.bounds.size.height) {
        
        [self.textView scrollRectToVisible:CGRectMake(0, visiableOriginY, self.textView.gjcf_width, self.textView.gjcf_height) animated:NO];
        
    }
    
    NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewContentChangeNoti formateWithIdentifier:self.panelIdentifier];
    [GJCFNotificationCenter postNotificationName:formateNoti object:self.textView.text];

    
}

- (void)observeEmojiPanelChooseDeleteNoti:(NSNotification *)noti
{
    [self deleteLastEmoji];
    
    [self performSelector:@selector(updateDisplayByInputContentTextChange) withObject:nil afterDelay:0.1];
}

#pragma mark - 按下录音按钮

#pragma mark - 检查麦克风权限

- (BOOL)checkRecordPermission
{
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if (avSession && [avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        __block BOOL isPermission;
        
        [avSession requestRecordPermission:^(BOOL granted) {
           
            if (!granted) {
                
                [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许访问你的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
            
            isPermission = granted;
            
        }];
        
        return isPermission;
    }
    
    return YES;
}

- (void)tapOnRecordButton:(UITapGestureRecognizer *)sender
{
    if (![self checkRecordPermission]) {
        
        return;
    }
    
    if (self.actionChangeBlock) {
        
        self.actionChangeBlock(GJGCChatInputTextViewRecordActionTypeTooShort);
        
    }
}

#pragma mark - 开始录音动作是否有效

- (void)updateStartRecordAction:(NSTimer *)timer
{
    self.isRecordStartRight = YES;
    
    if (self.minRecordActionTimer ) {
        [self.minRecordActionTimer invalidate];
        self.minRecordActionTimer = nil;
    }
}

#pragma mark - 长按手势

- (void)longPressRecordButton:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (![self checkRecordPermission]) {
            return;
        }
        
        self.recordButton.highlighted = YES;
        
        [self showRecordTipView];
        
        if (self.actionChangeBlock) {
            self.actionChangeBlock(GJGCChatInputTextViewRecordActionTypeStart);
        }
        
        self.minRecordActionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateStartRecordAction:) userInfo:nil repeats:NO];
        [self.minRecordActionTimer fire];
        
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        
    {
        CGPoint point = [gestureRecognizer locationInView:self.recordButton];
        if (point.x > 1 && point.y > 1)
        {
         
            if (self.isRecordStartRight) {
                
                if (self.actionChangeBlock) {
                    
                    self.actionChangeBlock(GJGCChatInputTextViewRecordActionTypeFinish);
                }
                
            }else{
                
                if (self.actionChangeBlock) {
                    
                    self.actionChangeBlock(GJGCChatInputTextViewRecordActionTypeCancel);
                }
                
                if (self.actionChangeBlock) {
                    
                    self.actionChangeBlock(GJGCChatInputTextViewRecordActionTypeTooShort);
                    
                }
            }
            
        }
        else
        {
            if (self.actionChangeBlock) {
                self.actionChangeBlock(GJGCChatInputTextViewRecordActionTypeCancel);
            }
        }
        
        self.recordButton.highlighted = NO;
        
        [self removeRecordTipView];
        
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        CGPoint point = [gestureRecognizer locationInView:self.recordButton];
        if (point.x > 1 && point.y > 1)
        {
            self.recordTipView.willCancel = NO;
        }
        else
        {
            self.recordTipView.willCancel = YES;
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{    
    NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewContentChangeNoti formateWithIdentifier:self.panelIdentifier];
    [GJCFNotificationCenter postNotificationName:formateNoti object:textView.text];

    /* 保留500字 */
    if (self.textView.text.length > 500 ) {
        
        self.textView.text = [self.textView.text substringToIndex:499];
        
    }
    
    // frame 改变
    [self performSelector:@selector(updateDisplayByInputContentTextChange) withObject:nil afterDelay:0.1];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(![textView hasText] && [text isEqualToString:@""])
    {
        return NO;
    }
    
    /* 输入内容不能超过500字 */
    if (textView.text.length >= 500 && ![text isEqualToString:@""]) {

        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        
        /* 是否纯空格 */
        BOOL isAllWhiteSpace = GJCFStringIsAllWhiteSpace(self.textView.text);
        if (isAllWhiteSpace) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:GJGC_NOTIFICATION_TOAST_NAME object:nil userInfo:@{@"message":@"不允许发送空信息"}];
            return NO;
        }
        for (int i = 0; i < textView.text.length; i++) {
            if ([textView.text characterAtIndex:i] == 0xfffc) {
                return NO;
            }
        }
        if (self.finishInputBlock) {
            
            if (!GJCFStringIsNull(textView.text)) {
                self.finishInputBlock(self,textView.text);
                textView.text = @"";
                [self performSelector:@selector(updateDisplayByInputContentTextChange) withObject:nil afterDelay:0.1];
                NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputTextViewContentChangeNoti formateWithIdentifier:self.panelIdentifier];
                [GJCFNotificationCenter postNotificationName:formateNoti object:textView.text];
                return NO;
            }
        }
    }
    
    if ([text isEqualToString:@""]) {
        
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.responseBlock) {
        self.responseBlock(self);
    }
    
    return YES;
}

- (void)clearInputText
{
    self.textView.text = @"";
    
    [self performSelector:@selector(updateDisplayByInputContentTextChange) withObject:nil afterDelay:0.1];
}
#pragma mark - 公开接口

- (BOOL)isValidateContent
{
    return GJCFStringIsNull(self.textView.text);
}

- (void)reserveToNormal
{
    
}

- (void)configFrameChangeBlock:(GJGCChatInputTextViewFrameDidChangeBlock)changeBlock
{
    if (self.frameChangeBlock) {
        self.frameChangeBlock = nil;
    }
    self.frameChangeBlock = changeBlock;
}

- (void)configRecordActionChangeBlock:(GJGCChatInputTextViewRecordActionChangeBlock)actionBlock
{
    if (self.actionChangeBlock) {
        self.actionChangeBlock = nil;
    }
    self.actionChangeBlock = actionBlock;
}

- (void)configFinishInputTextBlock:(GJGCChatInputTextViewFinishInputTextBlock)finishBlock
{
    if (self.finishInputBlock) {
        self.finishInputBlock = nil;
    }
    self.finishInputBlock = finishBlock;
}

- (void)configTextViewDidBecomeFirstResponse:(GJGCChatInputTextViewDidBecomeFirstResponseBlock)firstResponseBlock
{
    if (self.responseBlock) {
        self.responseBlock = nil;
    }
    self.responseBlock = firstResponseBlock;
}

@end
