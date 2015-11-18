/*!
 @header EMChatManagerDelegate.h
 @abstract 关于ChatManager的异步回调内部协议
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "EMChatManagerChatDelegate.h"
#import "EMChatManagerEncryptionDelegate.h"
#import "EMChatManagerLoginDelegate.h"
#import "EMChatManagerBuddyDelegate.h"
#import "EMChatManagerUtilDelegate.h"
#import "EMChatManagerGroupDelegate.h"
#import "EMChatManagerPushNotificationDelegate.h"
#import "EMChatManagerChatroomDelegate.h"

/*!
 @protocol
 @brief 本协议包括：收发消息, 登陆注销, 加密解密, 媒体操作的回调等其它操作
 @discussion
 */
@protocol EMChatManagerDelegate <EMChatManagerChatDelegate,
                                EMChatManagerLoginDelegate, 
                                EMChatManagerEncryptionDelegate,
                                EMChatManagerBuddyDelegate,
                                EMChatManagerUtilDelegate,
                                EMChatManagerGroupDelegate,
                                EMChatManagerPushNotificationDelegate,
                                EMChatManagerChatroomDelegate>

@optional

@end
