/*!
 *  \~chinese
 *  @header IEMChatroomManager.h
 *  @abstract 此协议定义了聊天室相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatroomManager.h
 *  @abstract This protocol defined the chatroom operations
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMChatroomManagerDelegate.h"
#import "EMChatroom.h"

@class EMError;

/*!
 *  \~chinese
 *  聊天室相关操作
 *
 *  \~english
 *  Chatroom operations
 */
@protocol IEMChatroomManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     添加回调代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<EMChatroomManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<EMChatroomManagerDelegate>)aDelegate;

#pragma mark - Api

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError   出错信息
 *
 *  @return 聊天室列表<EMChatroom>
 *
 *  \~english
 *  Get all the chatrooms from server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError   Error
 *
 *  @return Chat room list<EMChatroom>
 */
- (NSArray *)getAllChatroomsFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室的ID
 *  @param pError       返回的错误信息
 *
 *  @result 所加入的聊天室
 *
 *  \~english
 *  Join a chatroom
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result Joined chatroom
 */
- (EMChatroom *)joinChatroom:(NSString *)aChatroomId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result 退出的聊天室, 失败返回nil
 *
 *  \~english
 *  Leave a chatroom
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result Leaved chatroom
 */
- (EMChatroom *)leaveChatroom:(NSString *)aChatroomId
                        error:(EMError **)pError;

@end
