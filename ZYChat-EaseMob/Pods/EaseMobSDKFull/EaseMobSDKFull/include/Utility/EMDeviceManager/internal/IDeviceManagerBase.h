/*!
 @header IDeviceManagerBase.h
 @abstract 为DeviceManager提供基础操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "IDeviceManagerDelegate.h"

/*!
 @protocol
 @brief 设备管理器基础协议, 用于注册对象到监听列表和从监听列表中移除对象
 @discussion
 */
@protocol IDeviceManagerBase <NSObject>

@required

/*!
 @method
 @brief 注册一个监听对象到监听列表中
 @discussion 把监听对象添加到监听列表中准备接收相应的事件
 @param delegate 需要注册的监听对象
 @param aQueue 通知监听对象时的线程
 @result
 */
- (void)addDelegate:(id<IDeviceManagerDelegate>)delegate onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief 从监听列表中移除一个监听对象
 @discussion 把监听对象从监听列表中移除,取消接收相应的事件
 @param delegate 需要移除的监听对象
 @result
 */
- (void)removeDelegate:(id<IDeviceManagerDelegate>)delegate;

@end
