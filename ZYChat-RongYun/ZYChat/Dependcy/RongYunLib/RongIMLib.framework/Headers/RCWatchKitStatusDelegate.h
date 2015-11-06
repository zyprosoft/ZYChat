//
//  RCWatchKitStatusDelegate.h
//  RongIMLib
//
//  Created by litao on 15/6/4.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef RongIMLib_RCwatchKitStatusDelegate_h
#define RongIMLib_RCwatchKitStatusDelegate_h

/**
 * 该delegage是用来监听所有imlib的各种活动。实现该protocol用来通知watch kit各种状态变化。
 */
@protocol RCWatchKitStatusDelegate <NSObject>

@optional

/**
 * 收到消息
 *
 * @param receivedMsg   接受到的消息
 */
- (void)notifyWatchKitReceivedMessage:(RCMessage *)receivedMsg;

/**
 * 退出讨论组。创建结果通过notifyWatchKitDiscussionOperationCompletion获得
 *
 * @param discussionId    讨论组ID
 */
- (void)notifyWatchKitQuitDiscussion:(NSString *)discussionId;
/**
 * 踢出成员。踢出结果通过notifyWatchKitDiscussionOperationCompletion获得
 *
 *  @param discussionId    讨论组ID
 *  @param userId          用户ID
 */
- (void)notifyWatchKitRemoveMemberFromDiscussion:(NSString *)discussionId
                                          userId:(NSString *)userId;
/**
 * 添加成员。添加结果通过notifyWatchKitDiscussionOperationCompletion获得
 *
 *  @param discussionId    讨论组ID
 *  @param userIdList      添加成员ID
 */
- (void)notifyWatchKitAddMemberToDiscussion:(NSString *)discussionId
                                 userIdList:(NSArray *)userIdList;
/**
 * 讨论组相关操作结果。tag：100-邀请；101-踢人；102-退出。status：0成功，非0失败
 *
 *  @param tag       tag
 *  @param status    状态值
 */
- (void)notifyWatchKitDiscussionOperationCompletion:(int)tag status:(RCErrorCode)status;

/**
 * 创建讨论组
 *
 *  @param name         讨论组名称
 *  @param userIdList   成员列表
 */
- (void)notifyWatchKitCreateDiscussion:(NSString *)name
                            userIdList:(NSArray *)userIdList;

/**
 * 创建讨论组成功
 *
 *  @param discussionId    讨论组ID
 */
- (void)notifyWatchKitCreateDiscussionSuccess:(NSString *)discussionId;

/**
 * 创建讨论组失败
 *
 *  @param errorCode    错误代码
 */
- (void)notifyWatchKitCreateDiscussionError:(RCErrorCode)errorCode;

/**
 * 清除会话
 *
 *  @param conversationTypeList    会话类型数组
 */
- (void)notifyWatchKitClearConversations:(NSArray *)conversationTypeList;

/**
 * 清除消息
 *
 *  @param conversationType    会话类型
 *  @param targetId            目标ID
 */
- (void)notifyWatchKitClearMessages:(RCConversationType)conversationType targetId:(NSString *)targetId;

/**
 * 清除未读状态
 *
 *  @param conversationType    会话类型
 *  @param targetId            目标ID
 */
- (void)notifyWatchKitClearUnReadStatus:(RCConversationType)conversationType targetId:(NSString *)targetId;

/**
 * 删除消息
 *
 *  @param messageIds    消息ID数组
 */
- (void)notifyWatchKitDeleteMessages:(NSArray *)messageIds;

/**
 * 发送消息
 *
 *  @param message    待发送消息
 */
- (void)notifyWatchKitSendMessage:(RCMessage *)message;

/**
 * 发送消息完成。status：0成功，非0失败
 *
 *  @param messageId    消息ID
 *  @param status       状态代码
 */
- (void)notifyWatchKitSendMessageCompletion:(long)messageId status:(RCErrorCode)status;

/**
 * 上传图片进度
 *
 *  @param progress    进度
 *  @param messageId   消息ID
 */
- (void)notifyWatchKitUploadFileProgress:(int)progress  messageId:(long)messageId;

/**
 * 网络状态发生变化
 *
 *  @param status    网络状态
 */
- (void)notifyWatchKitConnectionStatusChanged:(RCConnectionStatus) status;

@end
#endif
