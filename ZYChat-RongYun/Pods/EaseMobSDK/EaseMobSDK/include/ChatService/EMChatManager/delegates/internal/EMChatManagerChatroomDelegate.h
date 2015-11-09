/*!
 @header EMChatManagerChatroomDelegate.h
 @abstract 聊天室回调协议
 @author EaseMob Inc.
 @version 1.00 2015/04/09 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "EMChatManagerDelegateBase.h"

/*!
 @enum
 @brief 被踢出聊天室的原因
 @constant eChatroomBeKickedReason_BeRemoved 被管理员移出该聊天室
 @constant eChatroomBeKickedReason_Destroyed 聊天室被销毁
 */
typedef NS_ENUM(NSInteger, EMChatroomBeKickedReason) {
    eChatroomBeKickedReason_BeRemoved = 1,
    eChatroomBeKickedReason_Destroyed
};

@class EMChatroom;

/*!
 @protocol
 @brief 此协议提供了聊天室操作的回调
 @discussion
 */
@protocol EMChatManagerChatroomDelegate <EMChatManagerDelegateBase>

@optional

/*!
 @method
 @brief 有用户加入聊天室
 @param chatroom    加入的聊天室
 @param username    加入者名称
 */
- (void)chatroom:(EMChatroom *)chatroom occupantDidJoin:(NSString *)username;

/*!
 @method
 @brief 有用户离开聊天室
 @param chatroom    离开的聊天室
 @param username    离开者名称
 */
- (void)chatroom:(EMChatroom *)chatroom occupantDidLeave:(NSString *)username;

/*!
 @method
 @brief 被踢出聊天室
 @param chatroom    被踢出的聊天室
 @param reason      被踢出聊天室的原因
 */
- (void)beKickedOutFromChatroom:(EMChatroom *)chatroom reason:(EMChatroomBeKickedReason)reason;

/*!
 @method
 @brief 收到加入聊天室的邀请
 @param chatroomId  聊天室ID
 @param username    邀请人名称
 @param message     邀请信息
 @discussion
 */
- (void)didReceiveChatroomInvitationFrom:(NSString *)chatroomId
                                 inviter:(NSString *)username
                                 message:(NSString *)message;
@end
