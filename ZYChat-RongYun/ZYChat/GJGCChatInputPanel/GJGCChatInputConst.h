//
//  GJGCChatInputConst.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  输入条动作类型
 */
typedef NS_ENUM(NSUInteger, GJGCChatInputBarActionType) {

    /* 无动作 */
    GJGCChatInputBarActionTypeNone,
    
    /* 录音动作 */
    GJGCChatInputBarActionTypeRecordAudio,

    /* 文本输入动作 */
    GJGCChatInputBarActionTypeInputText,

    /* 选择表情动作 */
    GJGCChatInputBarActionTypeChooseEmoji,

    /* 选择扩展面板动作 */
    GJGCChatInputBarActionTypeExpandPanel,
};

/**
 * *  重要提示
 *
 *  扩展菜单面板动作类型
 *
 *  新增扩展面板功能的时候在这里增加一个新的动作类型
 *  然后在GJGCChatInputExpandMenuPanelDataSource中创建一个Item绑定
 */
typedef NS_ENUM(NSUInteger, GJGCChatInputMenuPanelActionType) {
    /**
     *  选择拍照
     */
    GJGCChatInputMenuPanelActionTypeCamera,
    /**
     *  选择照片库
     */
    GJGCChatInputMenuPanelActionTypePhotoLibrary,
    /**
     *  选择我的帖子
     */
    GJGCChatInputMenuPanelActionTypeMyFavoritePost,
    /**
     *  群主召唤
     */
    GJGCChatInputMenuPanelActionTypeGroupCall,
};

/**
 *  输入框录音动作类型
 */
typedef NS_ENUM(NSUInteger, GJGCChatInputTextViewRecordActionType) {
    /**
     *  开始录音
     */
    GJGCChatInputTextViewRecordActionTypeStart,
    /**
     *  取消录音
     */
    GJGCChatInputTextViewRecordActionTypeCancel,
    /**
     *  完成录音
     */
    GJGCChatInputTextViewRecordActionTypeFinish,
    /**
     *  时间太短
     */
    GJGCChatInputTextViewRecordActionTypeTooShort
};

/**
 *  表情类型
 */
typedef NS_ENUM(NSUInteger, GJGCChatInputExpandEmojiType) {
    /**
     *  简单表情
     */
    GJGCChatInputExpandEmojiTypeSimple = 0,
    /**
     *  GIF表情
     */
    GJGCChatInputExpandEmojiTypeGIF = 1,
};

extern NSString *const GJGCChatInputTextViewRecordSoundMeterNoti;

extern NSString *const GJGCChatInputTextViewRecordTooShortNoti;

extern NSString *const GJGCChatInputTextViewRecordTooLongNoti;

extern NSString *const GJGCChatInputExpandEmojiPanelChooseEmojiNoti;

extern NSString *const GJGCChatInputExpandEmojiPanelChooseGIFEmojiNoti;

extern NSString *const GJGCChatInputExpandEmojiPanelChooseDeleteNoti;

extern NSString *const GJGCChatInputExpandEmojiPanelChooseSendNoti;

extern NSString *const GJGCChatInputSetLastMessageDraftNoti;

extern NSString *const GJGCChatInputPanelBeginRecordNoti;

extern NSString *const GJGCChatInputPanelNeedAppendTextNoti;



@interface GJGCChatInputConst : NSObject

+ (NSString *)panelNoti:(NSString *)notiName formateWithIdentifier:(NSString *)identifier;

@end
