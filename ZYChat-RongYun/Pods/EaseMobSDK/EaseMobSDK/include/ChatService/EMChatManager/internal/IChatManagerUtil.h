/*!
 @header IChatManagerUtil.h
 @abstract 为ChatManager提供工具类
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */


#import <Foundation/Foundation.h>
#import "IChatManagerBase.h"

@protocol IEMChatProgressDelegate;
@class EMError;
@class EMMessage;

/*!
 @protocol
 @brief 本协议主要用于为ChatManager提供一些实用工具
 @discussion
 */
@protocol IChatManagerUtil <IChatManagerBase>

@required

#pragma mark - fetch message

/*!
 @method
 @brief 获取聊天对象对应的远程服务器上的文件, 同步方法
 @discussion 如果此对象所在的消息对象是被加密的,下载下来的对象会被自动解密
 @param aMessage 聊天对象
 @param progress 进度条
 @param pError 错误信息
 */
- (EMMessage *)fetchMessage:(EMMessage *)aMessage
                   progress:(id<IEMChatProgressDelegate>)progress
                      error:(EMError **)pError;

/*!
 @method
 @brief 获取聊天对象对应的远程服务器上的文件, 异步方法
 @discussion 如果此对象所在的消息对象是被加密的,下载下来的对象会被自动解密.下载完成后,didFetchMessage:error:回调会被触发
 @param aMessage 聊天对象
 @param progress 进度条
 */
- (void)asyncFetchMessage:(EMMessage *)aMessage
                 progress:(id<IEMChatProgressDelegate>)progress;

/*!
 @method
 @brief 获取聊天对象对应的远程服务器上的文件, 异步方法
 @discussion 如果此对象所在的消息对象是被加密的,下载下来的对象会被自动解密
 @param aMessage     聊天对象
 @param progress     进度条
 @param completion   函数执行完成后的回调
 @param aQueue       回调函数所在的线程
 */
- (void)asyncFetchMessage:(EMMessage *)aMessage
                 progress:(id<IEMChatProgressDelegate>)progress
               completion:(void (^)(EMMessage *aMessage,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;

#pragma mark - fetch message thumbnail

/*!
 @method
 @brief 获取聊天对象的缩略图(当收到的消息有缩略图时, SDK会自动下载缩略图, 缩略图下载失败时, 可以使用此方法去重新获取)
 @discussion 如果此对象所在的消息对象是被加密的,下载下来的对象会被自动解密
 @param aMessage 聊天对象
 @param progress 进度条
 @param pError 错误信息
 */
- (EMMessage *)fetchMessageThumbnail:(EMMessage *)aMessage
                            progress:(id<IEMChatProgressDelegate>)progress
                               error:(EMError **)pError;

/*!
 @method
 @brief 获取聊天对象的缩略图(当收到的消息有缩略图时, SDK会自动下载缩略图, 缩略图下载失败时, 可以使用此方法去重新获取), 异步方法
 @discussion 如果此对象所在的消息对象是被加密的,下载下来的对象会被自动解密.下载完成后, didFetchMessageThumbnail:error:回调会被触发
 @param aMessage 聊天对象
 @param progress 进度条
 */
- (void)asyncFetchMessageThumbnail:(EMMessage *)aMessage
                          progress:(id<IEMChatProgressDelegate>)progress;

/*!
 @method
 @brief 获取聊天对象的缩略图(当收到的消息有缩略图时, SDK会自动下载缩略图, 缩略图下载失败时, 可以使用此方法去重新获取), 异步方法
 @discussion 如果此对象所在的消息对象是被加密的,下载下来的对象会被自动解密
 @param aMessage     聊天对象
 @param progress     进度条
 @param completion   函数执行完成后的回调
 @param aQueue       回调函数所在的线程
 */
- (void)asyncFetchMessageThumbnail:(EMMessage *)aMessage
                          progress:(id<IEMChatProgressDelegate>)progress
                        completion:(void (^)(EMMessage * aMessage,
                                             EMError *error))completion
                           onQueue:(dispatch_queue_t)aQueue;

@end
