/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCMessage.h
//  Created by Heq.Shinoda on 14-6-13.

#ifndef __RCMessage
#define __RCMessage
#import <Foundation/Foundation.h>
#import "RCStatusDefine.h"

@class RCMessageContent;

/**
 *  IM消息元数据,用于描述消息的所有信息
 */
@interface RCMessage : NSObject <NSCopying, NSCoding>
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

/**
 *  指派初始化方法，根据给定信息初始化实例
 *
 *  @param  conversationType    会话类型
 *  @param  targetId            目标ID，如讨论组ID, 群ID, 聊天室ID
 *  @param  messageDirection    消息方向
 *  @param  messageId           消息ID
 *  @param  content             消息体内容字段
 */
- (instancetype)initWithType:(RCConversationType)conversationType
                    targetId:(NSString *)targetId
                   direction:(RCMessageDirection)messageDirection
                   messageId:(long)messageId
                     content:(RCMessageContent *)content;

/**
 *  根据服务器返回JSON创建新实例
 *
 *  @param  jsonData    JSON数据字典
 */
+ (instancetype)messageWithJSON:(NSDictionary *)jsonData;

@end
#endif
