/*!
 @header EMChatLocation.h
 @abstract 聊天的位置对象类型
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "IEMChatObject.h"

@class CLLocation;
@protocol IEMMessageBody;

/*!
 @class 
 @brief 聊天的位置对象类型
 */
@interface EMChatLocation : NSObject<IEMChatObject>

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
 @brief 地址信息
 */
@property (nonatomic, strong) NSString *address;

/*!
 @property
 @brief CLLocation位置信息
 */
@property (nonatomic, strong) CLLocation *location;

/*!
 @property
 @brief
 聊天对象所在的消息体对象
 @discussion
 当消息体通过聊天对象创建完成后, messageBody为非nil, 当聊天对象并不属于任何消息体对象的时候, messageBody为nil
 */
@property (nonatomic, weak) id<IEMMessageBody> messageBody;

/*!
 @method
 @brief 以位置信息构造位置对象
 @discussion 
 @param latitude 纬度
 @param longitude 经度
 @param address 地址信息
 @result 位置对象
 */
- (id)initWithLatitude:(double)latitude 
             longitude:(double)longitude 
               address:(NSString *)address;

/*!
 @method
 @brief 以CLLocation构造位置对象
 @discussion 
 @param location CLLocation实例
 @result 位置对象
 */
- (id)initWithCLLocation:(CLLocation *)location;

@end
