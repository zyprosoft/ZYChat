/*!
 @header IEMChatProgressDelegate.h
 @abstract 聊天消息发送接收进度条协议
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "IEMMessageBody.h"

/*!
 @protocol
 @brief 聊天消息发送接收进度条
 @discussion 当发送带有附件的消息时, 可以使用进度条在界面上提示用户当前进度
 */
@protocol IEMChatProgressDelegate <NSObject>

@optional

/*!
 @method
 @brief 设置进度
 @discussion 用户需实现此接口用以支持进度显示
 @param progress 值域为0到1.0的浮点数
 @param message  某一条消息的progress
 @result
 */
- (void)setProgress:(float)progress
         forMessage:(EMMessage *)message EM_DEPRECATED_IOS(2_0_6, 2_1_2, "Use - setProgress:forMessage:forMessageBody:");

/*!
 @method
 @brief 设置进度
 @discussion 用户需实现此接口用以支持进度显示
 @param progress 值域为0到1.0的浮点数
 @result
 */
- (void)setProgress:(float)progress;

@required

/*!
 @method
 @brief 设置进度
 @discussion 用户需实现此接口用以支持进度显示
 @param progress 值域为0到1.0的浮点数
 @param message  某一条消息的progress
 @param messageBody  某一条消息某个body的progress
 @result
 */
- (void)setProgress:(float)progress
         forMessage:(EMMessage *)message
     forMessageBody:(id<IEMMessageBody>)messageBody;

@end
