/*!
 @header EMCommandMessageBody.h
 @abstract 聊天的命令消息体对象类型
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "IEMMessageBody.h"
#import "EMChatManagerDefs.h"

@class EMChatCommand;

/*!
 @class
 @abstract 聊天的命令消息体对象
 */
@interface EMCommandMessageBody : NSObject<IEMMessageBody>

/*!
 @property
 @brief 消息体的类型
 @discussion 实现IEMMessageBody接口
 */
@property (nonatomic, readonly) MessageBodyType messageBodyType;

/*!
 @property
 @brief 消息体的底层聊天对象
 @discussion 实现IEMMessageBody接口
 */
@property (nonatomic, strong, readonly) id<IEMChatObject> chatObject;

/*!
 @property
 @brief 具体命令
 */
@property (nonatomic, strong, readonly) NSString *action;

/*!
 @property
 @brief 命令参数
 */
@property (nonatomic, strong, readonly) NSArray *params EM_DEPRECATED_IOS(2_0_0, 2_0_9, @"不推荐使用, 请使用 EMMessage 的 ext 属性来携带额外的参数");

/*!
 @property
 @brief 消息体所在的消息对象
 @discussion 实现IEMMessageBody接口
 */
@property (nonatomic, weak) EMMessage *message;

/*!
 @method
 @abstract 以命令对象创建文件消息体实例
 @discussion
 @param aChatCommand 命令对象
 @result 命令消息体
 */
- (id)initWithChatObject:(EMChatCommand *)aChatCommand;

@end
