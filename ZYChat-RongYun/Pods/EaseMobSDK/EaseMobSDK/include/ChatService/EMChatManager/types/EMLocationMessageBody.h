/*!
 @header EMLocationMessageBody.h
 @abstract 聊天的位置消息体对象类型
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "EMChatManagerDefs.h"
#import "IEMMessageBody.h"

@class EMChatLocation;
@class EMMessage;
@protocol IEMChatObject;

/*!
 @class
 @brief 聊天的位置消息体对象
 */
@interface EMLocationMessageBody : NSObject<IEMMessageBody>

/*!
 @property
 @brief 消息体的类型
 */
@property (nonatomic, readonly) MessageBodyType messageBodyType;

/*!
 @property
 @brief 消息体的底层聊天对象
 */
@property (nonatomic, strong, readonly) id<IEMChatObject> chatObject;

/*!
 @property
 @brief 消息体所在的消息对象
 */
@property (nonatomic, weak) EMMessage *message;

/*!
 @property
 @brief 纬度
 */
@property (nonatomic) double latitude;

/*!
 @property
 @brief 经度
 */
@property (nonatomic) double longitude;

/*!
 @property
 @brief 地理位置信息
 */
@property (nonatomic, strong) NSString *address;

/*!
 @method
 @brief 以位置对象创建位置消息体实例
 @discussion
 @param aChatLocation 位置对象
 @result 位置消息体
 */
- (id)initWithChatObject:(EMChatLocation *)aChatLocation;

@end
