//
//  GJGCInputTextView.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCChatInputConst.h"

@class GJGCChatInputTextView;

typedef void (^GJGCChatInputTextViewFrameDidChangeBlock) (GJGCChatInputTextView *textView,CGFloat changeDetal);

typedef void (^GJGCChatInputTextViewRecordActionChangeBlock) (GJGCChatInputTextViewRecordActionType actionType);

typedef void (^GJGCChatInputTextViewFinishInputTextBlock) (GJGCChatInputTextView *textView,NSString *text);

typedef void (^GJGCChatInputTextViewDidBecomeFirstResponseBlock) (GJGCChatInputTextView *textView);

#define GJGCChatInputTextViewContentChangeNoti @"GJGCChatInputTextViewContentChangeNoti"

@interface GJGCChatInputTextView : UIView

/**
 *  准备录音的标题
 */
@property (nonatomic,strong)NSString *preRecordTitle;

/**
 *  正在录音时候的标题
 */
@property (nonatomic,strong)NSString *recordingTitle;

/**
 *  输入文本时候的背景
 */
@property (nonatomic,strong)UIImage *inputTextBackgroundImage;

/**
 *  录音时候的背景
 */
@property (nonatomic,strong)UIImage *recordAudioBackgroundImage;

/**
 *  是否录音输入状态
 */
@property (nonatomic,assign,getter=isRecordState)BOOL recordState;

/**
 *  当前文本内容
 */
@property (nonatomic,strong)NSString *content;

/**
 *  最大自动伸展高度
 */
@property (nonatomic,assign)CGFloat maxAutoExpandHeight;

/**
 *  最小高度
 */
@property (nonatomic,assign)CGFloat minAutoExpandHeight;

/**
 *  表情数组
 */
@property (nonatomic,strong)NSMutableArray *emojiInfoArray;

@property (nonatomic,strong)NSString *panelIdentifier;

@property (nonatomic,readonly)CGFloat inputTextStateHeight;

/**
 *  占位文本
 */
@property (nonatomic,strong)NSString *placeHolder;

/**
 *  当前文本是否合法
 *
 *  @return 是否合法
 */
- (BOOL)isValidateContent;

/**
 *  恢复到初始状态
 */
- (void)reserveToNormal;

/**
 *  注销第一响应
 */
- (void)resignFirstResponder;

- (void)updateDisplayByInputContentTextChange;

- (void)layoutInputTextView;

- (BOOL)isInputTextFirstResponse;

/**
 *  成为第一响应者
 */
- (void)becomeFirstResponder;

/**
 *  观察frame变化
 *
 *  @param changeBlock 
 */
- (void)configFrameChangeBlock:(GJGCChatInputTextViewFrameDidChangeBlock)changeBlock;

/**
 *  观察录音动作变化
 *
 *  @param actionBlock 
 */
- (void)configRecordActionChangeBlock:(GJGCChatInputTextViewRecordActionChangeBlock)actionBlock;

/**
 *  完成文本输入
 *
 *  @param finishBlock 
 */
- (void)configFinishInputTextBlock:(GJGCChatInputTextViewFinishInputTextBlock)finishBlock;


- (void)configTextViewDidBecomeFirstResponse:(GJGCChatInputTextViewDidBecomeFirstResponseBlock)firstResponseBlock;


- (void)clearInputText;

@end
