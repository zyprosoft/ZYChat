/*!
 @header IEMChatObject.h
 @abstract 聊天对象基类接口
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

@protocol IEMMessageBody;

/*!
 @class
 @brief 聊天对象基类对象协议
 */
@protocol IEMChatObject <NSObject>

@required

/*!
 @property
 @brief 聊天对象所在的消息体对象
 @discussion
        当消息体通过聊天对象创建完成后, messageBody为非nil, 当聊天对象并不属于任何消息体对象的时候, messageBody为nil
 */
@property (nonatomic, weak) id<IEMMessageBody> messageBody;

@end
