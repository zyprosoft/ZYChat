/*!
 @header EMChatroom.h
 @abstract 聊天室对象类型
 @author EaseMob Inc.
 @version 1.00 2015/04/08 Creation (1.00)
 */

#import <Foundation/Foundation.h>

@interface EMChatroom : NSObject
/*!
 @property
 @brief 聊天室ID
 */
@property (nonatomic, strong, readonly) NSString *chatroomId;

/*!
 @property
 @brief 聊天室的主题
 */
@property (nonatomic, strong, readonly) NSString *chatroomSubject;

/*!
 @property
 @brief 聊天室的描述
 */
@property (nonatomic, strong, readonly) NSString *chatroomDescription;

/*!
 @property
 @brief 聊天室的最大人数
 */
@property (nonatomic, readonly) NSInteger chatroomMaxOccupantsCount;

+ (instancetype)chatroomWithId:(NSString *)chatroomId;
@end
