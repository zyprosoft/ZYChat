/*!
 @header IEMChatCryptor.h
 @abstract 为消息提供基础加解密服务的协议
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

/*!
 @protocol
 @brief 本协议主要用于对聊天提供基础的加密, 解密服务
 @discussion
 */
@protocol IEMChatCryptor <NSObject>

@required

/*!
 @method
 @brief 对NSData进行加密
 @discussion
 @param data 要加密的数据
 @param aArgs 附加参数
 @result 加密后的数据
 */
- (NSData *)encryptData:(NSData *)data args:(id)aArgs;

/*!
 @method
 @brief 对NSData进行解密
 @discussion
 @param data 要解密的数据
 @param aArgs 附加参数
 @result 解密后的数据
 */
- (NSData *)decryptData:(NSData *)data args:(id)aArgs;

@end
