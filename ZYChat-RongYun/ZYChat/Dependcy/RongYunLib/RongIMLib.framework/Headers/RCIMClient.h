/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RongIMClient.h
//  Created by xugang on 14/12/23.

#ifndef __RongIMClient
#define __RongIMClient
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "RCStatusDefine.h"
#import "RCMessage.h"
#import "RCUserInfo.h"
#import "RCPublicServiceProfile.h"
#import "RCUserData.h"
#import "RCWatchKitStatusDelegate.h"
#import "RCUploadImageStatusListener.h"
#import "RCPublicServiceDataSource.h"

@class RCConversation;
@class RCDiscussion;

UIKIT_EXTERN NSString *const KNotificationclearTheConversationMessages;

/**
 *  接受消息 delegate 回调
 */
@protocol RCIMClientReceiveMessageDelegate <NSObject>

/**
 *  收到消息后的处理。
 *
 *  @param message 收到的消息实体。
 *  @param nLeft   剩余消息数。
 *  @param object  调用对象。
 */
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object;

@end

/**
 *  连接状态监听器，以获取连接相关状态。
 */
@protocol RCConnectionStatusChangeDelegate <NSObject>

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onConnectionStatusChanged:(RCConnectionStatus)status;
@end

/**
 *  SDK运行状态
 */
typedef NS_ENUM(NSUInteger, RCSDKRunningMode) {
  /**
   *  后台运行
   */
  RCSDKRunningMode_Backgroud = 0,
  /**
   *  前台运行
   */
  RCSDKRunningMode_Foregroud = 1
};

/**
 *  当前网络状态
 */
typedef NS_ENUM(NSUInteger, RCNetworkStatus) {
  /**
   *  不可用
   */
  RC_NotReachable = 0,
  /**
   *  wifi
   */
  RC_ReachableViaWiFi,
  /**
   *  4G
   */
  RC_ReachableViaLTE,
  /**
   *  3G
   */
  RC_ReachableVia3G,
  /**
   *  2G
   */
  RC_ReachableVia2G
};

/**
 *  IM 客户端核心类。
 *  <p/>
 *  所有 IM 相关方法、监听器都由此调用和设置。
 */
@interface RCIMClient : NSObject

/**
 *  当前的用户信息对象
 */
@property(nonatomic, strong) RCUserInfo *currentUserInfo;

/**
 *  公众服务信息提供者
 */
@property(nonatomic, strong)id<RCPublicServiceDataSource> publicServiceDataSource;

/**
 *  当前 App 前后台模式
 */
@property(nonatomic, assign, readonly) RCSDKRunningMode sdkRunningMode;

/**
 *  WatchKit 的状态代理
 */
@property(nonatomic, strong)
    id<RCWatchKitStatusDelegate> watchKitStatusDelegate;
/**
 *  获取通讯能力库的核心类单例。
 *
 *  @return 通讯能力库的核心类单例。
 */
+ (instancetype)sharedRCIMClient;

/**
 * 初始化 SDK。
 * 在整个应用程序全局，只需要调用一次 init 方法。传入您从开发者平台申请的 appKey
 *即可。
 *
 * @param appKey      从开发者平台申请的应用 appKey。
 */
- (void)init:(NSString *)appKey;

/**
 * 注册消息类型。
 * 用于自定义消息类型的注册，请参考官网。如果不对消息类型进行扩展，可以忽略此方法。
 *
 * @param messageClass 消息类型名称，对应的继承自 RCMessageContent 的消息类型。
 */

- (void)registerMessageType:(Class)messageClass;

/**
 * 设置 DeviceToken，用于 APNS 的设备唯一标识。请在获取到Device
 * Token之后立即调用该方法。
 * @param deviceToken 从苹果服务器获取的设备唯一标识
 */
- (void)setDeviceToken:(NSString *)deviceToken;

/**
 * 建立连接。
 * 建立连接必须传入 Token，它是您 App 当前用户的唯一身份凭证，故传入错误的 Token
 *会导致失败。
 *
 *  @param token                 从服务端获取的用户身份令牌（Token）。
 *  @param successBlock          调用完成的处理。
 *  @param errorBlock            调用返回的错误信息。
 *  @param tokenIncorrectBlock   Token错误，可能是因为过期导致，需要重新换取token重新连接，但要注意避免因为token错误导致无限循环。
 */
- (void)connectWithToken:(NSString *)token
                 success:(void (^)(NSString *userId))successBlock
                   error:(void (^)(RCConnectErrorCode status))errorBlock
          tokenIncorrect:(void (^)())tokenIncorrectBlock;

//从2.2.3版本之后，所有的重连操作都由lib库自动处理，上层不需要干预。
///**
// *  重新连接服务器。
// *  将重用您的 Token 进行重连，请注意当 Token 错误或过期失效时您需要重新获取
// Token。
// *
// *  @param successBlock 重连成功回调
// *  @param errorBlock   重连失败回调
// */
//- (void)reconnect:(void (^)(NSString *userId))successBlock error:(void
//(^)(RCConnectErrorCode status))errorBlock;

/**
 *  断开连接。
 *
 *  @param isReceivePush 是否接收回调。YES 为接收，NO 为不接收。
 */
- (void)disconnect:(BOOL)isReceivePush;

/**
 *  断开连接。还可以接收到push消息。
 */
- (void)disconnect;

/**
 *  Log out。不会接收到push消息。
 */
- (void)logout;

/**
 *  设置接收消息的监听器。
 *
 *  所有接收到的消息、通知、状态都经由此处设置的监听器处理。包括私聊消息、讨论组消息、群组消息、聊天室消息以及各种状态。
 *
 *  @param delegate 接收消息的监听器。
 *  @param userData 用户自定义数据，该值会在 delegate 中返回。
 */
- (void)setReceiveMessageDelegate:(id<RCIMClientReceiveMessageDelegate>)delegate
                           object:(id)userData;

/**
 *  设置连接状态变化的监听器。
 *
 *  @param delegate 连接状态变化的监听器。
 */
- (void)setRCConnectionStatusChangeDelegate:
    (id<RCConnectionStatusChangeDelegate>)delegate;

/**
 *  发送状态消息。可以发送任何类型的消息。但建议您发送自定义的消息类型
 *  注：如果通过该接口发送图片消息，需要自己实现上传图片，把imageUrl传入content（注意它将是一个RCImageMessage）。
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          消息内容。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 *
 *  @return 发送的状态消息实体。
 */
- (RCMessage *)sendStatusMessage:(RCConversationType)conversationType
                        targetId:(NSString *)targetId
                         content:(RCMessageContent *)content
                         success:(void (^)(long messageId))successBlock
                           error:(void (^)(RCErrorCode nErrorCode,
                                           long messageId))errorBlock;
/**
 *  发送消息。可以发送任何类型的消息。
 *  注：如果通过该接口发送图片消息，需要自己实现上传图片，把imageUrl传入content（注意它将是一个RCImageMessage）。
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          消息内容。
 *  @param pushContent      推送消息内容
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 *
 *  @return 发送的消息实体。
 */
- (RCMessage *)sendMessage:(RCConversationType)conversationType
                  targetId:(NSString *)targetId
                   content:(RCMessageContent *)content
               pushContent:(NSString *)pushContent
                   success:(void (^)(long messageId))successBlock
                     error:(void (^)(RCErrorCode nErrorCode,
                                     long messageId))errorBlock;

/**
 *  发送消息。可以发送任何类型的消息。
 *  注：如果通过该接口发送图片消息，需要自己实现上传图片，把imageUrl传入content（注意它将是一个RCImageMessage）。
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          消息内容。
 *  @param pushContent      推送消息内容
 *  @param pushData         推送消息附加信息
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 *
 *  @return 发送的消息实体。
 */
- (RCMessage *)sendMessage:(RCConversationType)conversationType
                  targetId:(NSString *)targetId
                   content:(RCMessageContent *)content
               pushContent:(NSString *)pushContent
                  pushData:(NSString *)pushData
                   success:(void (^)(long messageId))successBlock
                     error:(void (^)(RCErrorCode nErrorCode,
                                     long messageId))errorBlock;
/**
 *  发送图片消息，上传图片并且发送，使用该方法，默认原图会上传到融云的服务，并且发送消息,如果使用普通的sendMessage方法，
 *  需要自己实现上传图片，并且添加ImageMessage的URL之后发送
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          消息内容
 *  @param pushContent      推送消息内容
 *  @param progressBlock    进度块
 *  @param successBlock     成功处理块
 *  @param errorBlock       失败处理块
 *
 *  @return 发送的消息实体。
 */
- (RCMessage *)
sendImageMessage:(RCConversationType)conversationType
        targetId:(NSString *)targetId
         content:(RCMessageContent *)content
     pushContent:(NSString *)pushContent
        progress:(void (^)(int progress, long messageId))progressBlock
         success:(void (^)(long messageId))successBlock
           error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock;

/**
 *  发送图片消息，上传图片并且发送，使用该方法，默认原图会上传到融云的服务，并且发送消息,如果使用普通的sendMessage方法，
 *  需要自己实现上传图片，并且添加ImageMessage的URL之后发送
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          消息内容
 *  @param pushContent      推送消息内容
 *  @param pushData         推送消息附加信息
 *  @param progressBlock    进度块
 *  @param successBlock     成功处理块
 *  @param errorBlock       失败处理块
 *
 *  @return 发送的消息实体。
 */
- (RCMessage *)
sendImageMessage:(RCConversationType)conversationType
        targetId:(NSString *)targetId
         content:(RCMessageContent *)content
     pushContent:(NSString *)pushContent
        pushData:(NSString *)pushData
        progress:(void (^)(int progress, long messageId))progressBlock
         success:(void (^)(long messageId))successBlock
           error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock;

/**
 *  发送图片消息，由APP实现上传图片。请在uploadPrepareBlock中上传图片，并通知融云上传进度和结果。使用lib的客户可以忽略此方法
 *
 *  @param conversationType   会话类型。
 *  @param targetId           目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content            消息内容
 *  @param pushContent        推送消息内容
 *  @param pushData         推送消息附加信息
 *  @param uploadPrepareBlock 应用上传图片Block
 *  @param progressBlock      进度块
 *  @param successBlock       成功处理块
 *  @param errorBlock         失败处理块
 *
 *  @return 发送的消息实体。
 */
- (RCMessage *)sendImageMessage:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                        content:(RCMessageContent *)content
                    pushContent:(NSString *)pushContent
                       pushData:(NSString *)pushData
                  uploadPrepare:(void (^)(RCUploadImageStatusListener *uploadListener))uploadPrepareBlock
                       progress:(void (^)(int progress, long messageId))progressBlock
                        success:(void (^)(long messageId))successBlock
                          error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock;
/**
 *  下载图片
 *
 *  @param conversationType 会话类型
 *  @param targetId         标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param mediaType        媒体类型，目前支持图片
 *  @param mediaUrl         媒体URL
 *  @param progressBlock    回调进度
 *  @param successBlock     成功处理块
 *  @param errorBlock       失败处理块
 */
- (void)downloadMediaFile:(RCConversationType)conversationType
                 targetId:(NSString *)targetId
                mediaType:(RCMediaType)mediaType
                 mediaUrl:(NSString *)mediaUrl
                 progress:(void (^)(int progress))progressBlock
                  success:(void (^)(NSString *mediaPath))successBlock
                    error:(void (^)(RCErrorCode errorCode))errorBlock;

/**
 *  获取用户信息。该方法sdk2.0弃用，我们建议您使用自己本地的方法获取
 *
 *  如果本地缓存中包含用户信息，则从本地缓存中直接获取，否则将访问融云服务器获取用户登录时注册的信息；<br/>
 *  但如果该用户如果从来没有登录过融云服务器，返回的用户信息会为空值。
 *
 *  @param userId          用户 Id。
 *  @param successBlock    调用完成的处理。
 *  @param errorBlock      调用返回的错误信息。
 */
- (void)getUserInfo:(NSString *)userId
            success:(void (^)(RCUserInfo *userInfo))successBlock
              error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  获取会话列表。
 *
 *  会话列表按照时间从前往后排列，如果有置顶会话，则置顶会话在前。
 *
 *  @param conversationTypeList 会话类型数组，存储对象为NSNumber类型 type类型为int
 *  @return 会话列表。
 */
- (NSArray *)getConversationList:(NSArray *)conversationTypeList;

/**
 *  获取会话信息。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         会话 Id。
 *
 *  @return 会话信息。
 */
- (RCConversation *)getConversation:(RCConversationType)conversationType
                           targetId:(NSString *)targetId;

/**
 *  从会话列表中移除某一会话，但是不删除会话内的消息。
 *
 *  如果此会话中有新的消息，该会话将重新在会话列表中显示，并显示最近的历史消息。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *
 *  @return 是否移除成功。
 */
- (BOOL)removeConversation:(RCConversationType)conversationType
                  targetId:(NSString *)targetId;

/**
 *  设置某一会话为置顶或者取消置顶。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param isTop            是否置顶。
 *
 *  @return 是否设置成功。
 */
- (BOOL)setConversationToTop:(RCConversationType)conversationType
                    targetId:(NSString *)targetId
                       isTop:(BOOL)isTop;

/**
 *  获取所有未读消息数。
 *
 *  @return 未读消息数。
 */
- (int)getTotalUnreadCount;

/**
 *  获取来自某用户（某会话）的未读消息数。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *
 *  @return 未读消息数。
 */
- (int)getUnreadCount:(RCConversationType)conversationType
             targetId:(NSString *)targetId;

/**
 *  获取某会话类型的未读消息数.
 *
 *  @param conversationTypes 会话类型, 存储对象为NSNumber type类型为int
 *
 *  @return 未读消息数。
 */
- (int)getUnreadCount:(NSArray *)conversationTypes;

/**
 *  获取最新消息记录。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。
 *  @param count            要获取的消息数量。
 *
 *  @return 最新消息记录，按照时间顺序从新到旧排列。
 */
- (NSArray *)getLatestMessages:(RCConversationType)conversationType
                      targetId:(NSString *)targetId
                         count:(int)count;

/**
 *  获取历史消息记录。
 *
 *  @param conversationType 会话类型。不支持传入 RCConversationType.CHATROOM。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *  @param oldestMessageId  最后一条消息的 Id，获取此消息之前的 count 条消息。
 *  @param count            要获取的消息数量。
 *
 *  @return 历史消息记录，按照时间顺序新到旧排列。
 */
- (NSArray *)getHistoryMessages:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                oldestMessageId:(long)oldestMessageId
                          count:(int)count;

/**
 *  插入一条消息。
 *
 *  @param conversationType 会话类型。不支持传入 RCConversationType.CHATROOM。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *  @param senderUserId     消息的发送者，如果为空则为当前用户。
 *  @param sendStatus       要插入的消息状态。
 *  @param content          消息内容
 *
 *  @return 插入的消息实体。
 */
- (RCMessage *)insertMessage:(RCConversationType)conversationType
                    targetId:(NSString *)targetId
                senderUserId:(NSString *)senderUserId
                  sendStatus:(RCSentStatus)sendStatus
                     content:(RCMessageContent *)content;
/**
 *  删除指定的一条或者一组消息。
 *
 *  @param messageIds 要删除的消息 Id 列表, 存储对象为NSNumber
 *messageId，类型为long。
 *
 *  @return 是否删除成功。
 */
- (BOOL)deleteMessages:(NSArray *)messageIds;

/**
 *  清空某一会话的所有聊天消息记录。
 *
 *  @param conversationType 会话类型。不支持传入 RCConversationType.CHATROOM。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *
 *  @return 是否清空成功。
 */
- (BOOL)clearMessages:(RCConversationType)conversationType
             targetId:(NSString *)targetId;

/**
 *  清除消息未读状态。
 *
 *  @param conversationType 会话类型。不支持传入 RCConversationType.CHATROOM。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *
 *  @return 是否清空成功。
 */
- (BOOL)clearMessagesUnreadStatus:(RCConversationType)conversationType
                         targetId:(NSString *)targetId;

/**
 *  清空会话列表
 *
 *  @param conversationTypeList 会话类型列表，存储对象为NSNumber, type类型为int
 *
 *  @return 操作结果
 */
- (BOOL)clearConversations:(NSArray *)conversationTypeList;

/**
 *  设置消息的附加信息，此信息只保存在本地。
 *
 *  @param messageId 消息 Id。
 *  @param value     消息附加信息。
 *
 *  @return 是否设置成功。
 */
- (BOOL)setMessageExtra:(long)messageId value:(NSString *)value;

/**
 *  设置接收到的消息状态。
 *
 *  @param messageId      消息 Id。
 *  @param receivedStatus 接收到的消息状态。
 */
- (BOOL)setMessageReceivedStatus:(long)messageId
                  receivedStatus:(RCReceivedStatus)receivedStatus;


/**
 *  设置消息发送状态。
 *
 *  @param messageId      消息 Id。
 *  @param sentStatus 接收到的消息状态。
 */
- (BOOL)setMessageSentStatus:(long)messageId
                  sentStatus:(RCSentStatus)sentStatus;

/**
 *  获取某一会话的文字消息草稿。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *
 *  @return 草稿的文字内容。
 */
- (NSString *)getTextMessageDraft:(RCConversationType)conversationType
                         targetId:(NSString *)targetId;

/**
 *  保存文字消息草稿。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          草稿的文字内容。
 *
 *  @return 是否保存成功。
 */
- (BOOL)saveTextMessageDraft:(RCConversationType)conversationType
                    targetId:(NSString *)targetId
                     content:(NSString *)content;

/**
 *  清除某一会话的文字消息草稿。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *
 *  @return 是否清除成功。
 */
- (BOOL)clearTextMessageDraft:(RCConversationType)conversationType
                     targetId:(NSString *)targetId;

/**
 *  获取讨论组信息和设置。
 *
 *  @param discussionId     讨论组 Id。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)getDiscussion:(NSString *)discussionId
              success:(void (^)(RCDiscussion *discussion))successBlock
                error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  设置讨论组名称
 *
 *  @param targetId         讨论组 Id。
 *  @param discussionName   讨论组名称。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)setDiscussionName:(NSString *)targetId
                     name:(NSString *)discussionName
                  success:(void (^)())successBlock
                    error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  创建讨论组。
 *
 *  @param name         讨论组名称，如：当前所有成员的名字的组合。
 *  @param userIdList   讨论组成员 Id 列表。
 *  @param successBlock 调用完成的处理。
 *  @param errorBlock   调用返回的错误信息。
 */
- (void)createDiscussion:(NSString *)name
              userIdList:(NSArray *)userIdList
                 success:(void (^)(RCDiscussion *discussion))successBlock
                   error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  邀请一名或者一组用户加入讨论组。
 *
 *  @param discussionId   讨论组 Id。
 *  @param userIdList     邀请的用户 Id 列表。
 *  @param successBlock   调用完成的处理。
 *  @param errorBlock     调用返回的错误信息。
 */
- (void)addMemberToDiscussion:(NSString *)discussionId
                   userIdList:(NSArray *)userIdList
                      success:(void (^)(RCDiscussion *discussion))successBlock
                        error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  供创建者将某用户移出讨论组。
 *
 *  移出自己或者调用者非讨论组创建者将产生错误。
 *
 *  @param discussionId   讨论组 Id。
 *  @param userId         用户 Id。
 *  @param successBlock   调用完成的处理。
 *  @param errorBlock     调用返回的错误信息。
 */
- (void)removeMemberFromDiscussion:(NSString *)discussionId
                            userId:(NSString *)userId
                           success:
                               (void (^)(RCDiscussion *discussion))successBlock
                             error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  退出当前用户所在的某讨论组。
 *
 *  @param discussionId 讨论组 Id。
 *  @param successBlock   调用完成的处理。
 *  @param errorBlock        调用返回的错误信息。
 */
- (void)quitDiscussion:(NSString *)discussionId
               success:(void (^)(RCDiscussion *discussion))successBlock
                 error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  获取会话消息提醒状态。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天Id、讨论组 Id、群组 Id。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)
getConversationNotificationStatus:(RCConversationType)conversationType
                         targetId:(NSString *)targetId
                          success:(void (^)(RCConversationNotificationStatus
                                                nStatus))successBlock
                            error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  设置会话消息提醒状态。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *  @param isBlocked        是否屏蔽。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)
setConversationNotificationStatus:(RCConversationType)conversationType
                         targetId:(NSString *)targetId
                        isBlocked:(BOOL)isBlocked
                          success:(void (^)(RCConversationNotificationStatus
                                                nStatus))successBlock
                            error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  设置讨论组成员邀请权限。
 *
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *  @param isOpen           开放状态，默认开放。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)setDiscussionInviteStatus:(NSString *)targetId
                           isOpen:(BOOL)isOpen
                          success:(void (^)())successBlock
                            error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  同步当前用户的群组信息。
 *
 *  @param groupList        群组对象列表。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)syncGroups:(NSArray *)groupList
           success:(void (^)())successBlock
             error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  加入群组。
 *
 *  @param groupId          群组Id。
 *  @param groupName        群组名称。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)joinGroup:(NSString *)groupId
        groupName:(NSString *)groupName
          success:(void (^)())successBlock
            error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  退出群组。
 *
 *  @param groupId          群组Id。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)quitGroup:(NSString *)groupId
          success:(void (^)())successBlock
            error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  加入聊天室。
 *
 *  @param targetId         聊天室ID。
 *  @param messageCount     进入聊天室获取获取多少条历史信息，-1表示不获取，0表示系统默认数目(现在默认值为10条)，正数表示获取的具体数目，最大值为50
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
- (void)joinChatRoom:(NSString *)targetId
        messageCount:(int)messageCount
             success:(void (^)())successBlock
               error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  退出聊天室。
 *
 *  @param targetId         聊天室ID。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */

- (void)quitChatRoom:(NSString *)targetId
             success:(void (^)())successBlock
               error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  获取当前网络状态
 *
 *  @return 当前网络状态
 */
- (RCNetworkStatus)getCurrentNetworkStatus;

/**
 *  加入黑名单
 *
 *  @param userId     用户id
 *  @param successBlock 加入黑名单成功。
 *  @param errorBlock      加入黑名单失败。
 */
- (void)addToBlacklist:(NSString *)userId
               success:(void (^)())successBlock
                 error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  移出黑名单
 *
 *  @param userId     用户id
 *  @param successBlock 移出黑名单成功。
 *  @param errorBlock      移出黑名单失败。
 */
- (void)removeFromBlacklist:(NSString *)userId
                    success:(void (^)())successBlock
                      error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  获取用户黑名单状态
 *
 *  @param userId     用户id
 *  @param successBlock 获取用户黑名单状态成功。bizStatus：0-在黑名单，101-不在黑名单
 *  @param errorBlock      获取用户黑名单状态失败。
 */
- (void)getBlacklistStatus:(NSString *)userId
                   success:(void (^)(int bizStatus))successBlock
                     error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  获取黑名单列表
 *
 *  @param successBlock 黑名单列表，多个id以回车分割
 *  @param errorBlock      获取用户黑名单状态失败
 */

- (void)getBlacklist:(void (^)(NSArray *blockUserIds))successBlock
               error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  设置关闭 Push 时间，在该段时间内您可以收到 Push 消息，但不会收到提示。
 *
 *  @param startTime         关闭起始时间 格式 HH:MM:SS
 *  @param spanMins          间隔分钟数 0 < t < 1440
 *  @param successBlock 成功操作回调,status为0表示成功，其它表示失败
 *  @param errorBlock   失败操作回调, 返回相应的错误码
 */

- (void)setConversationNotificationQuietHours:(NSString *)startTime
                                     spanMins:(int)spanMins
                                      success:(void (^)())successBlock
                                        error:(void (^)(RCErrorCode status))
                                                  errorBlock;
/**
 *  删除 Push 设置
 *
 *  @param successBlock 成功回调
 *  @param errorBlock   失败回调
 */
- (void)removeConversationNotificationQuietHours:(void (^)())successBlock
                                           error:(void (^)(RCErrorCode status))
                                                     errorBlock;

/**
 *  查询 Push 设置
 *
 *  @param successBlock startTime 关闭开始时间，spansMin间隔分钟
 *  @param errorBlock   status为0表示成功，其它失败
 */
- (void)getNotificationQuietHours:(void (^)(NSString *startTime,
                                            int spansMin))successBlock
                            error:(void (^)(RCErrorCode status))errorBlock;
/**
 *  搜索所有公众账号
 *
 *  @param searchKey          关键字
 *  @param searchType         匹配模式：精确匹配或者模糊匹配
 *  @param successBlock            查询成功：返回RCPublicServiceProfile的数组
 *  @param errorBlock              查询失败：返回错误码
 */

- (void)searchPublicService:(RCSearchType)searchType
                  searchKey:(NSString *)searchKey
                    success:(void (^)(NSArray *accounts))successBlock
                      error:(void (^)(RCErrorCode status))errorBlock;
/**
 *  按类型搜索公众账号
 *
 *  @param publicServiceType  搜索范围：全部搜索，公众号开发者，第三方平台
 *  @param searchKey          关键字
 *  @param searchType         匹配模式：精确匹配或者模糊匹配
 *  @param successBlock            查询成功：返回RCPublicServiceProfile的数组
 *  @param errorBlock              查询失败：返回错误码
 */

- (void)searchPublicServiceByType:(RCPublicServiceType)publicServiceType
                       searchType:(RCSearchType)searchType
                        searchKey:(NSString *)searchKey
                          success:(void (^)(NSArray *accounts))successBlock
                            error:(void (^)(RCErrorCode status))errorBlock;
/**
 *  订阅公众账号服务
 *
 *  @param publicServiceType  公众号开发者，第三方平台
 *  @param publicServiceId    目标ID
 *  @param successBlock            订阅成功
 *  @param errorBlock              订阅失败
 */
- (void)subscribePublicService:(RCPublicServiceType)publicServiceType
               publicServiceId:(NSString *)publicServiceId
                       success:(void (^)())successBlock
                         error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  取消订阅公众账号服务
 *
 *  @param publicServiceType  公众号开发者，第三方平台
 *  @param publicServiceId    目标ID
 *  @param successBlock            取消订阅成功
 *  @param errorBlock              取消订阅失败
 */
- (void)unsubscribePublicService:(RCPublicServiceType)publicServiceType
                 publicServiceId:(NSString *)publicServiceId
                         success:(void (^)())successBlock
                           error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  获取公众号信息
 *
 *  @param publicServiceType  公众号开发者，第三方平台
 *  @param publicServiceId    目标ID
 *
 *  @return RCPublicServiceProfile
 */
- (RCPublicServiceProfile *)getPublicServiceProfile:
                                (RCPublicServiceType)publicServiceType
                                    publicServiceId:(NSString *)publicServiceId;


/**
 *  获取公众号信息
 *
 *  @param publicServiceType  公众号开发者，第三方平台
 *  @param publicServiceId    目标ID
 *  @param successBlock       获取成功：返回RCPublicServiceProfile的数据
 *  @param errorBlock         获取失败：返回错误码
 */
- (void)getPublicServiceProfile:(NSString *)targetId
               conversationType:(RCConversationType)type
                      onSuccess:(void (^)(RCPublicServiceProfile *serviceProfile))onSuccess
                        onError:(void (^)(NSError *error))onError;
/**
 *  查询已关注的公众号
 *
 *  @return 公众服务列表
 */
- (NSArray *)getPublicServiceList;

/**
 *  获取公众号WebView Controller。
 *  公众号相关的所有网页都应该由此WebView打开。
 *
 *  @param URLString  待打开的链接地址
 *
 *  @return WebView controller
 */
- (UIViewController *)getPublicServiceWebViewController:(NSString *)URLString;

/**
 *  查询当前连接状态
 *
 *  @return 连接状态
 */
- (RCConnectionStatus)getConnectionStatus;

/**
 *  从服务端获取历史消息记录（不保存在本地数据库）。
 *
 *  @param conversationType 会话类型。不支持传入 RCConversationType.CHATROOM。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天
 *  Id、讨论组 Id、群组 Id。
 *  @param recordTime  最早消息的 sendtime，第一次取传0。
 *  @param count            要获取的消息数量（1-20条）。
 *  @param successBlock 成功回调返回历史记录
 *  @return 。
 */
- (void)getRemoteHistoryMessages:(RCConversationType)conversationType
                  targetId:(NSString *)targetId
                recordTime:(long)recordTime
                     count:(int)count
                   success:(void (^)(NSArray *messages))successBlock;

/**
 *  发起客服会话（kit中会话页面已经有客服会话的判断，不用调用此消息，如果用使用Lib 在发起客服会话时调用，这里会发送握手消息）
 *
 *  @param customerServiceId    客服id
 *  @param successBlock 成功回调
 *  @param errorBlock   失败回调
 */
- (void)joinCustomerServiceChat:(NSString *)customerServiceId
                        success:(void (^)())successBlock
                          error:(void (^)(RCErrorCode status))errorBlock;

/**
 *  结束客服会话（kit中会话页面已经有客服会话的判断，不用调用此消息，如果用使用Lib 在发起客服会话时调用，这里会发送结束消息）
 *
 *  @param customerServiceId    客服id
 *  @param successBlock 成功回调
 *  @param errorBlock   失败回调
 */
- (void)quitCustomerServiceChat:(NSString *)customerServiceId
                        success:(void (^)())successBlock
                          error:(void (^)(RCErrorCode status))errorBlock;


#pragma mark - 统计API
/**
 *  统计启动事件
 *
 *  @param launchOptions    启动原因
 */
- (void)recordLaunchOptionsEvent:(NSDictionary *)launchOptions;

/**
 *  统计本地推送事件
 *
 *  @param notification     本地推送内容
 */
- (void)recordLocalNotificationEvent:(UILocalNotification *)notification;

/**
 *  统计远程推送事件
 *
 *  @param userInfo     远程推送内容
 */
- (void)recordRemoteNotificationEvent:(NSDictionary *)userInfo;

/**
 *  获取点击的启动事件中，融云推送服务的扩展字段
 *
 *  @param launchOptions    启动原因
 *
 *  @return                 收到的融云推送服务的扩展字段，nil表示该启动事件不包含来自融云的推送服务
 */
- (NSDictionary *)getPushExtraFromLaunchOptions:(NSDictionary *)launchOptions;

/**
 *  获取点击的远程推送中，融云推送服务的扩展字段
 *
 *  @param userInfo     远程推送内容
 *
 *  @return             收到的融云推送服务的扩展字段，nil表示该远程推送不包含来自融云的推送服务
 */
- (NSDictionary *)getPushExtraFromRemoteNotification:(NSDictionary *)userInfo;

/**
 *  统计事件
 *
 *  @param key      事件名
 *  @param count    计数
 */
- (void)recordEvent:(NSString *)key count:(int)count;

/**
 *  统计事件
 *
 *  @param key      事件名
 *  @param count    计数
 *  @param sum      权重
 */
- (void)recordEvent:(NSString *)key count:(int)count sum:(double)sum;

/**
 *  统计事件
 *
 *  @param key              事件名
 *  @param segmentation     事件详情
 *  @param count            计数
 */
- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(int)count;

/**
 *  统计事件
 *
 *  @param key              事件名
 *  @param segmentation     事件详情
 *  @param count            计数
 *  @param sum              权重
 */
- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(int)count sum:(double)sum;

/**
 *  统计地址位置
 *
 *  @param latitude     纬度
 *  @param longitude    经度
 */
- (void)recordLocation:(double)latitude longitude:(double)longitude;

/**
 *  统计用户信息
 *
 *  @param userDetails  用户信息
 */
- (void)recordUserDetails:(NSDictionary *)userDetails;

/**
 *  用户信息Key值，昵称
 */
extern NSString* const kRCUserName;
/**
 *  用户信息Key值，邮箱
 */
extern NSString* const kRCUserEmail;
/**
 *  用户信息Key值，公司
 */
extern NSString* const kRCUserOrganization;
/**
 *  用户信息Key值，手机号
 */
extern NSString* const kRCUserPhone;
/**
 *  用户信息Key值，性别
 */
extern NSString* const kRCUserGender;
/**
 *  用户信息Key值，头像
 */
extern NSString* const kRCUserPicture;
/**
 *  用户信息Key值，头像地址
 */
extern NSString* const kRCUserPicturePath;
/**
 *  用户信息Key值，出生日期
 */
extern NSString* const kRCUserBirthYear;
/**
 *  用户信息Key值，用户自定义信息
 */
extern NSString* const kRCUserCustom;
- (void)uploadUserInfoWithName:(NSString *)name
                          data:(NSString *)data
                       success:(void (^)(NSString *token))successBlock
                         error:(void (^)(RCErrorCode status, NSString *errorMsg))errorBlock;

/**
 *  获取消息发送成功时间
 *
 *  @param messageId       消息的Id
 */
-(long long)getMessageSendTime:(long)messageId;


/**
 *  获取消息回执功能开通状态
 *  @param conversationType       会话类型（目前只支持单聊）
 */
-(BOOL)getConversationMessageReceiptStatus:(RCConversationType)conversationType;

/**
 *  发送已读消息回执
 *
 *  @param conversationType       会话类型（目前只支持单聊）
 *  @param targetId               会话Id
 *  @param time                   最后一条发送消息的时间戳
 */
-(void)sendReceiptMessage:(RCConversationType)conversationType
                 targetId:(NSString *)targetId
                     time: (long long)timestamp;

@end
#endif
