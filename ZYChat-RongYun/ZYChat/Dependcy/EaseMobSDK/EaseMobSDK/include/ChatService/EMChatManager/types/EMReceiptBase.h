/*!
 @header EMReceiptBase.h
 @abstract 聊天回执请求与响应基类
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "EMChatManagerDefs.h"

#pragma mark - EMReceipt Base
/*!
 @class
 @brief 聊天回执基类
 */
@interface EMReceiptBase : NSObject

/*!
 @property
 @brief 发送方
 */
@property (nonatomic, copy) NSString *from;

/*!
 @property
 @brief 接收方
 */
@property (nonatomic, copy) NSString *to;

/*!
 @property
 @brief 此回执关联的聊天ID
 */
@property (nonatomic, copy) NSString *chatId;

/*!
 @property
 @brief 此回执是否用于群聊
 */
@property (nonatomic) BOOL isGroup;

/*!
 @property
 @brief 回执类型
 */
@property (nonatomic) EMReceiptType type;

/*!
 @property
 @brief 时间戳, UTC时间, 单位为毫秒
 */
@property (nonatomic) long long timestamp;

@end
