//
//  RongMessageModel.h
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>
/**
 *  RCMessageModel
 */
@interface RCMessageModel : NSObject
/**
 *  isDisplayMessageTime
 */
@property(nonatomic, assign) BOOL isDisplayMessageTime;
/**
 *  isDisplayNickname
 */
@property(nonatomic, assign) BOOL isDisplayNickname;
/** 用户信息 */
@property(nonatomic, strong) RCUserInfo *userInfo;
/** 会话类型 */
@property(nonatomic, assign) RCConversationType conversationType;
/** 目标ID，如讨论组ID, 群ID, 聊天室ID */
@property(nonatomic, strong) NSString *targetId;
/** 消息ID */
@property(nonatomic, assign) long messageId;
/** 消息方向 */
@property(nonatomic, assign) RCMessageDirection messageDirection;
/** 发送者ID */
@property(nonatomic, strong) NSString *senderUserId;
/** 接受状态 */
@property(nonatomic, assign) RCReceivedStatus receivedStatus;
/**发送状态 */
@property(nonatomic, assign) RCSentStatus sentStatus;
/** 接收时间 */
@property(nonatomic, assign) long long receivedTime;
/**发送时间 */
@property(nonatomic, assign) long long sentTime;
/** 消息体名称 */
@property(nonatomic, strong) NSString *objectName;
/** 消息内容 */
@property(nonatomic, strong) RCMessageContent *content;
/** 附加字段 */
@property(nonatomic, strong) NSString *extra;
/** 保存的cell高度值，避免重复计算 */
@property(nonatomic) CGSize cellSize;
/**
 *  initWithMessage
 *
 *  @param rcMessage rcMessage
 *
 *  @return return model
 */
- (instancetype)initWithMessage:(RCMessage *)rcMessage;

@end
