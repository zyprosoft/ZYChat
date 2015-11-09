/*!
 @header EMReceipt.h
 @abstract 聊天回执
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import "EMReceiptBase.h"

@class EMMessage;

/*!
 @class
 @brief 聊天回执请求
 */
@interface EMReceipt : EMReceiptBase

/*!
 @property
 @brief 回执所属的对话对象的chatter
 */
@property (strong, nonatomic) NSString *conversationChatter;

/*!
 @property
 @brief 是否是匿名消息回执
 */
@property (assign, nonatomic) BOOL isAnonymous;

/*!
 @method
 @brief 由消息创建回执请求
 @discussion
 @param message 消息对象
 @param type    回执类型
 @result 聊天回执请求实例
 */
+ (EMReceipt *)createFromMessage:(EMMessage *)message type:(EMReceiptType)type;

@end
