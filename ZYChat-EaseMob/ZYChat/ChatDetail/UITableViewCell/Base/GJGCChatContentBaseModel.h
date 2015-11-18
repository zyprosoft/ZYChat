//
//  GJGCChatContentBaseModel.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatBaseConstans.h"

/**
 *  发送消息状态
 */
typedef NS_ENUM(NSUInteger, GJGCChatFriendSendMessageStatus) {
    /**
     *  发送失败
     */
    GJGCChatFriendSendMessageStatusFaild = 0,
    /**
     *  发送成功
     */
    GJGCChatFriendSendMessageStatusSuccess = 1,
    /**
     *  发送中
     */
    GJGCChatFriendSendMessageStatusSending = 2,
};

/**
 *  对话类型
 */
typedef NS_ENUM(NSUInteger, GJGCChatFriendTalkType) {
    /**
     *  单聊
     */
    GJGCChatFriendTalkTypePrivate,
    /**
     *  群聊
     */
    GJGCChatFriendTalkTypeGroup,
    /**
     *  帖子聊天
     */
    GJGCChatFriendTalkTypePost,
    /**
     *  帖子系统
     */
    GJGCChatFriendTalkTypePostSystem,
    /**
     *  系统助手
     */
    GJGCChatFriendTalkSystemAssist
};

@interface GJGCChatContentBaseModel : NSObject

@property (nonatomic,readonly)NSString *uniqueIdentifier;

@property (nonatomic,readwrite)NSInteger contentSourceIndex;

@property (nonatomic,assign)long long sendTime;

/**
 *  是否时间区间的模型
 */
@property (nonatomic,assign)BOOL isTimeSubModel;

/**
 *  绑定的时间块的唯一标示
 */
@property (nonatomic,strong)NSString *timeSubIdentifier;

/**
 *  某个时间块下面有多少条消息
 */
@property (nonatomic,assign)NSInteger timeSubMsgCount;

@property (nonatomic,strong)NSAttributedString *timeString;

@property (nonatomic,strong)NSString *faildReason;

@property (nonatomic,assign)NSInteger faildType;

@property (nonatomic,assign)GJGCChatFriendTalkType talkType;

@property (nonatomic,strong)NSString *toId;

@property (nonatomic,strong)NSString *toUserName;

@property (nonatomic,strong)NSString *senderId;

@property (nonatomic,strong)NSString *sessionId;

/**
 *  消息最基础的类型区分
 */
@property (nonatomic,assign)GJGCChatBaseMessageType baseMessageType;

/**
 *  内容高度
 */
@property (nonatomic,assign)CGFloat contentHeight;

/**
 *  具体内容大小
 */
@property (nonatomic,assign)CGSize  contentSize;

/**
 *  本地消息id
 */
@property (nonatomic,strong)NSString *localMsgId;

/**
 *  消息发送状态
 */
@property (nonatomic,assign)GJGCChatFriendSendMessageStatus sendStatus;

- (NSComparisonResult)compareContent:(GJGCChatContentBaseModel *)contentModel;

@end
