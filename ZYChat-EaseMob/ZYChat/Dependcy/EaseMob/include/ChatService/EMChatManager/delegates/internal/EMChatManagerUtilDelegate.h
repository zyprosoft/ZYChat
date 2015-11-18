/*!
 @header EMChatManagerUtilDelegate.h
 @abstract 此协议提供了一些实用工具类的回调协议
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "EMNetworkMonitorDefs.h"

@protocol IEMFileMessageBody;

/*!
 @protocol
 @brief 此协议提供了一些实用工具类的回调
 @discussion
 */
@protocol EMChatManagerUtilDelegate <EMChatManagerDelegateBase>

@optional

/*!
 @method
 @brief 收取消息体对象后的回调
 @discussion 当获取完消息体对象后,此回调会被触发;如果此消息体所在的消息对象在服务器端已被加密,那么下载完成后会自动进行解压
 @param aMessage 要获取的消息对象
 @param error        错误信息
 */
- (void)didFetchMessage:(EMMessage *)aMessage error:(EMError *)error;

/*!
 @method
 @brief 下载消息缩略图完成后的回调
 @discussion 当获取完缩略图后, 此回调会被触发;如果此消息体所在的消息对象在服务器端已被加密,那么下载完成后会自动进行解压
 @param aMessage 要获取的消息对象
 @param error    错误信息
 */
- (void)didFetchMessageThumbnail:(EMMessage *)aMessage error:(EMError *)error;

/*!
 @method
 @brief SDK连接服务器的状态变化时的回调
 @discussion 有以下几种情况, 会引起该方法的调用:
     1. 登录成功后, 手机无法上网时, 会调用该回调
     2. 登录成功后, 网络状态变化时, 会调用该回调
    由于网络变化时, 都会调用到该方法, 
    如果需要保存前一次的connectionState, 需要自己手动保存该变量
 @param connectionState 当前SDK连接服务器的状态变化
 */
- (void)didConnectionStateChanged:(EMConnectionState)connectionState;

@end
