//
//  GJGCCommonInputBar.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCChatInputBarItem.h"
#import "GJGCChatInputTextView.h"
#import "GJGCChatInputConst.h"

@class GJGCChatInputBar;

/**
 *  输入条改变了frame
 *
 *  @param inputBar
 *  @param changeToFrame 改变后的frame
 */
typedef void (^GJGCChatInputBarDidChangeFrameBlock) (GJGCChatInputBar *inputBar,CGFloat changeDelta);

/**
 *  输入条改变了输入动作
 *
 *  @param inputBar
 *  @param toActionType 改变后的输入动作
 */
typedef void (^GJGCChatInputBarDidChangeActionBlock) (GJGCChatInputBar *inputBar,GJGCChatInputBarActionType toActionType);

/**
 *  输入条要求发送文本
 *
 *  @param inputBar
 *  @param text
 */
typedef void (^GJGCChatInputBarDidTapOnSendTextBlock) (GJGCChatInputBar *inputBar,NSString *text);


@interface GJGCChatInputBar : UIView

@property (nonatomic,assign)CGFloat barHeight;

@property (nonatomic,assign)CGFloat inputTextStateBarHeight;

@property (nonatomic,strong)NSString *panelIdentifier;

/**
 *  文本输入默认占位
 */
@property (nonatomic,strong)NSString *inputTextViewPlaceHolder;

/**
 *  当前动作类型
 */
@property (nonatomic,readonly)GJGCChatInputBarActionType currentActionType;

/**
 *  不可用动作
 */
@property (nonatomic,assign)GJGCChatInputBarActionType disableActionType;

/**
 *  输入条改变了frame观察
 *
 *  @param changeBlock
 */
- (void)configBarDidChangeFrameBlock:(GJGCChatInputBarDidChangeFrameBlock)changeBlock;

/**
 *  输入条改变了动作类型观察
 *
 *  @param actionBlock 
 */
- (void)configBarDidChangeActionBlock:(GJGCChatInputBarDidChangeActionBlock)actionBlock;

/**
 *  输入条的录音动作变化
 *
 *  @param actionBlock 
 */
- (void)configInputBarRecordActionChangeBlock:(GJGCChatInputTextViewRecordActionChangeBlock)actionBlock;

/**
 *  输入条发送文本消息动作
 *
 *  @param sendTextBlock 
 */
- (void)configBarTapOnSendTextBlock:(GJGCChatInputBarDidTapOnSendTextBlock)sendTextBlock;

/**
 *  调整为评论条样式
 */
- (void)setupForCommentBarStyle;

/* 恢复初始状态 */
- (void)reserveState;

/* 恢复评论初始状态 */
- (void)reserveCommentState;

- (void)inputTextResigionFirstResponse;

- (BOOL)isInputTextFirstResponse;

- (void)inputTextBecomeFirstResponse;

- (void)clearInputText;

//解除好友关系后要求禁止语音输入
- (void)recordRightStartLimit;

@end
