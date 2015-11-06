//
//  RongConversationModel.h
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RongConversationModel
#define __RongConversationModel

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>
/**
 *  RCConversationModelType
 */
typedef NS_ENUM(NSUInteger, RCConversationModelType) {
    /**
     *  RC_CONVERSATION_MODEL_TYPE_NORMAL
     */
    RC_CONVERSATION_MODEL_TYPE_NORMAL = 1,
    /**
     *  RC_CONVERSATION_MODEL_TYPE_COLLECTION
     */
    RC_CONVERSATION_MODEL_TYPE_COLLECTION = 2,
    /**
     *  RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION
     */
    RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION = 3,
    /**
     *  RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE
     */
    RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE = 4,

};

/**
 *  RCConversationModel
 */
@interface RCConversationModel : NSObject

/**
 *  conversationModelType
 */
@property(nonatomic) RCConversationModelType conversationModelType;

/**
 *  用户自定义数据
 */
@property(nonatomic, strong) id extend;

/*!
 会话类型 @see RCConversationType
 */
@property(nonatomic, assign) RCConversationType conversationType;
/*!
 会话 Id
 */
@property(nonatomic, strong) NSString *targetId;
/*!
 会话名称
 */
@property(nonatomic, strong) NSString *conversationTitle;
/*!
 会话中未读消息数
 */
@property(nonatomic, assign) NSInteger unreadMessageCount;
/*!
 当前会话是否置顶
 */
@property(nonatomic, assign) BOOL isTop;
/*!
 消息阅读状态 @see RCReceivedStatus
 */
@property(nonatomic, assign) RCReceivedStatus receivedStatus;
/*!
 消息发送状态 @see RCSentStatus
 */
@property(nonatomic, assign) RCSentStatus sentStatus;
/*!
 消息接收时间
 */
@property(nonatomic, assign) long long receivedTime;
/*!
 消息发送时间
 */
@property(nonatomic, assign) long long sentTime;
/*!
 消息草稿，尚未发送的消息内容
 */
@property(nonatomic, strong) NSString *draft;
/*!
 会话实体名
 */
@property(nonatomic, strong) NSString *objectName;
/*!
 发送消息用户Id
 */
@property(nonatomic, strong) NSString *senderUserId;
/*!
 发送消息用户名
 */
@property(nonatomic, strong) NSString *senderUserName;
/*!
 当前会话最近一条消息Id
 */
@property(nonatomic, assign) long lastestMessageId;
/*!
 当前会话最近一条消息实体
 */
@property(nonatomic, strong) RCMessageContent *lastestMessage;
/**
 *  会话的json数据
 */
@property(nonatomic, strong) NSDictionary *jsonDict;

/**
 *  用户使用的初始化方法
 *
 *  @param conversationModelType conversationModelType
 *  @param extend                extend
 *
 *  @return model
 */
- (id)init:(RCConversationModelType)conversationModelType exntend:(id)extend;

/**
 *  SDK本身使用的初始化方法
 *
 *  @param conversationModelType conversationModelType
 *  @param conversation          conversation
 *  @param extend                extend
 *
 *  @return model
 */
- (id)init:(RCConversationModelType)conversationModelType conversation:(RCConversation *)conversation extend:(id)extend;

@end

#endif