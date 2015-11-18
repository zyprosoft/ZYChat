/*!
 @header IChatManagerBase.h
 @abstract 为ChatManager提供基础操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "commonDefs.h"

@protocol EMChatManagerDelegate;

/*!
 @protocol
 @brief 聊天的基础协议, 用于注册对象到监听列表和从监听列表中移除对象
 @discussion
 */
@protocol IChatManagerBase <NSObject>

@required

/*!
 @method
 @brief 注册一个监听对象到监听列表中
 @discussion 把监听对象添加到监听列表中准备接收相应的事件
 @param delegate 需要注册的监听对象
 @param queue 通知监听对象时的线程
 @result
 */
- (void)addDelegate:(id<EMChatManagerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;

/*!
 @method
 @brief 从监听列表中移除一个监听对象
 @discussion 把监听对象从监听列表中移除,取消接收相应的事件
 @param delegate 需要移除的监听对象
 @result
 */
- (void)removeDelegate:(id<EMChatManagerDelegate>)delegate;

@end
