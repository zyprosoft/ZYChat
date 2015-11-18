/*!
 @header IChatManagerChat.h
 @abstract 为ChatManager提供基础消息操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "IChatManagerBase.h"
#import "EMChatManagerDefs.h"

@class EMMessage;
@class EMError;
@protocol IEMChatProgressDelegate;

/*!
 @protocol
 @brief 用户聊天协议, 用于发送, 转发信息
 @discussion 所有不带Block回调的异步方法, 需要监听回调时, 需要先将要接受回调的对象注册到delegate中, 示例代码如下:
    [[[EaseMob sharedInstance] chatManager] addDelegate:self delegateQueue:dispatch_get_main_queue()]
 */
@protocol IChatManagerChat <IChatManagerBase>

@required
#pragma mark - send message

/*!
 @method
 @brief 发送一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @param pError   错误信息
 @result 发送完成后的消息对象
 */
- (EMMessage *)sendMessage:(EMMessage *)message
                 progress:(id<IEMChatProgressDelegate>)progress
                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 发送一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改. 在发送过程中, willSendMessage:error:和didSendMessage:error:这两个回调会被触发
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncSendMessage:(EMMessage *)message
                      progress:(id<IEMChatProgressDelegate>)progress;

/*!
 @method
 @brief 异步方法, 发送一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @param prepare          将要发送消息前的回调block
 @param aPrepareQueue    回调block时的线程
 @param completion       发送消息完成后的回调
 @param aCompletionQueue 回调block时的线程
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncSendMessage:(EMMessage *)message
                           progress:(id<IEMChatProgressDelegate>)progress
                            prepare:(void (^)(EMMessage *message,
                                              EMError *error))prepare
                            onQueue:(dispatch_queue_t)aPrepareQueue
                         completion:(void (^)(EMMessage *message,
                                              EMError *error))completion
                            onQueue:(dispatch_queue_t)aCompletionQueue;

#pragma mark - message ack

/*!
 @method
 @brief 发送一个"已读消息"(在UI上显示了或者阅后即焚的销毁的时候发送)的回执到服务器
 @discussion
 @param message 从服务器收到的消息
 @result
 */
- (void)sendReadAckForMessage:(EMMessage *)message;

#pragma mark - resend message

/*!
 @method
 @brief 重新发送某一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @param pError   错误信息
 @result
 */
- (EMMessage *)resendMessage:(EMMessage *)message
                        progress:(id<IEMChatProgressDelegate>)progress
                           error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 重新发送某一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改. 在发送过程中, EMChatManagerChatDelegate中的willSendMessage:error:和didSendMessage:error:这两个回调会被触发
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncResendMessage:(EMMessage *)message
                             progress:(id<IEMChatProgressDelegate>)progress;

/*!
 @method
 @brief 异步方法, 重新发送某一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @param prepare          将要发送消息前的回调block
 @param aPrepareQueue    回调block时的线程
 @param completion       发送消息完成后的回调
 @param aCompletionQueue 回调block时的线程
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncResendMessage:(EMMessage *)message
                             progress:(id<IEMChatProgressDelegate>)progress 
                              prepare:(void (^)(EMMessage *message, 
                                                EMError *error))prepare
                              onQueue:(dispatch_queue_t)aPrepareQueue
                           completion:(void (^)(EMMessage *message,
                                                EMError *error))completion
                              onQueue:(dispatch_queue_t)aCompletionQueue;

@optional

#pragma mark - EM_DEPRECATED_IOS

/*!
 @method
 @brief 发送一个"已读消息"(在UI上显示了或者阅后即焚的销毁的时候发送)的回执到服务器
 @discussion
 @param message 从服务器收到的消息
 @result
 */
- (void)sendHasReadResponseForMessage:(EMMessage *)message EM_DEPRECATED_IOS(2_0_0, 2_1_6, "Use - sendReadAckForMessage:");

#pragma mark - forward message， delete

/*!
 @method
 @brief 将某一条消息转发给另一个聊天用户
 @discussion
 @param message     需要转发的消息对象
 @param ext         转发时需要修改的ext(原有需要转发的message的ext不会进行转发)
 @param username    需要转发给聊天对象的username
 @param isGroup  是否是转发到一个群组
 @param progress    发送多媒体信息时的progress回调对象
 @param pError      错误信息
 @result 发送的消息对象
 */
- (EMMessage *)forwardMessage:(EMMessage *)message
                          ext:(NSDictionary *)ext
                           to:(NSString *)username
                      isGroup:(BOOL)isGroup
                     progress:(id<IEMChatProgressDelegate>)progress
                        error:(EMError **)pError EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

/*!
 @method
 @brief 异步方法, 将某一条消息转发给另一个聊天用户
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改. 在发送过程中, EMChatManagerChatDelegate中的willSendMessage:error:和didSendMessage:error:这两个回调会被触发
 @param message     需要转发的消息对象
 @param ext         转发时需要修改的ext(原有需要转发的message的ext不会进行转发)
 @param username    需要转发给聊天对象的username
 @param isGroup  是否是转发到一个群组
 @param progress    发送多媒体信息时的progress回调对象
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncForwardMessage:(EMMessage *)message
                               ext:(NSDictionary *)ext
                                to:(NSString *)username
                           isGroup:(BOOL)isGroup
                          progress:(id<IEMChatProgressDelegate>)progress EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

/*!
 @method
 @brief 异步方法, 将某一条消息转发给另一个聊天用户
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改.
 @param message     需要转发的消息对象
 @param ext         转发时需要修改的ext(原有需要转发的message的ext不会进行转发)
 @param username    需要转发给聊天对象的username
 @param isGroup     是否是转发到一个群组
 @param progress    发送多媒体信息时的progress回调对象
 @param prepare          将要发送消息前的回调block
 @param aPrepareQueue    回调block时的线程
 @param completion       发送消息完成后的回调
 @param aCompletionQueue 回调block时的线程
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncForwardMessage:(EMMessage *)message
                               ext:(NSDictionary *)ext
                                to:(NSString *)username
                           isGroup:(BOOL)isGroup
                          progress:(id<IEMChatProgressDelegate>)progress
                           prepare:(void (^)(EMMessage *message,
                                             EMError *error))prepare
                           onQueue:(dispatch_queue_t)aPrepareQueue
                        completion:(void (^)(EMMessage *message,
                                             EMError *error))completion
                           onQueue:(dispatch_queue_t)aCompletionQueue EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

/*!
 @method
 @brief 将某一条消息转发给另一个聊天用户
 @discussion
 @param message     需要转发的消息对象
 @param ext         转发时需要修改的ext(原有需要转发的message的ext不会进行转发)
 @param username    需要转发给聊天对象的username
 @param type        转发对象的类型
 @param progress    发送多媒体信息时的progress回调对象
 @param pError      错误信息
 @result 发送的消息对象
 */
- (EMMessage *)forwardMessage:(EMMessage *)message
                          ext:(NSDictionary *)ext
                           to:(NSString *)username
                  messageType:(EMMessageType)type
                     progress:(id<IEMChatProgressDelegate>)progress
                        error:(EMError **)pError EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

/*!
 @method
 @brief 异步方法, 将某一条消息转发给另一个聊天用户
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改. 在发送过程中, EMChatManagerChatDelegate中的willSendMessage:error:和didSendMessage:error:这两个回调会被触发
 @param message     需要转发的消息对象
 @param ext         转发时需要修改的ext(原有需要转发的message的ext不会进行转发)
 @param username    需要转发给聊天对象的username
 @param type        转发对象的类型
 @param progress    发送多媒体信息时的progress回调对象
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncForwardMessage:(EMMessage *)message
                               ext:(NSDictionary *)ext
                                to:(NSString *)username
                       messageType:(EMMessageType)type
                          progress:(id<IEMChatProgressDelegate>)progress EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

/*!
 @method
 @brief 异步方法, 将某一条消息转发给另一个聊天用户
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改.
 @param message     需要转发的消息对象
 @param ext         转发时需要修改的ext(原有需要转发的message的ext不会进行转发)
 @param username    需要转发给聊天对象的username
 @param type        转发对象的类型
 @param progress    发送多媒体信息时的progress回调对象
 @param prepare          将要发送消息前的回调block
 @param aPrepareQueue    回调block时的线程
 @param completion       发送消息完成后的回调
 @param aCompletionQueue 回调block时的线程
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncForwardMessage:(EMMessage *)message
                               ext:(NSDictionary *)ext
                                to:(NSString *)username
                       messageType:(EMMessageType)type
                          progress:(id<IEMChatProgressDelegate>)progress
                           prepare:(void (^)(EMMessage *message,
                                             EMError *error))prepare
                           onQueue:(dispatch_queue_t)aPrepareQueue
                        completion:(void (^)(EMMessage *message,
                                             EMError *error))completion
                           onQueue:(dispatch_queue_t)aCompletionQueue EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

@end
