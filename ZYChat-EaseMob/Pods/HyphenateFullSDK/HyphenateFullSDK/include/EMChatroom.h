/*!
 *  \~chinese
 *  @header EMChatroom.h
 *  @abstract 聊天室
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMChatroom.h
 *  @abstract Chatroom
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese 
 *  聊天室
 *
 *  \~english 
 *  Chatroom
 */
@interface EMChatroom : NSObject

/*!
 *  \~chinese 
 *  聊天室ID
 *
 *  \~english 
 *  Chatroom id
 */
@property (nonatomic, copy, readonly) NSString *chatroomId;

/*!
 *  \~chinese
 *  聊天室的主题
 *
 *  \~english 
 *  Subject of chatroom
 */
@property (nonatomic, copy, readonly) NSString *subject;

/*!
 *  \~chinese 
 *  聊天室的描述
 *
 *  \~english 
 *  Description of chatroom
 */
@property (nonatomic, copy, readonly) NSString *description;

/*!
 *  \~chinese 
 *  聊天室的最大人数
 *
 *  \~english
 *  The maximum number of members
 */
@property (nonatomic, readonly) NSInteger maxOccupantsCount;

/*!
 *  \~chinese
 *  初始化聊天室实例
 *  
 *  请使用[+chatroomWithId:]方法
 *
 *  @result nil
 *
 *  \~english
 *  Initialize chatroom instance
 *
 *  Please use [+chatroomWithId:]
 *
 *  @result nil
 */
- (instancetype)init __deprecated_msg("Use +chatroomWithId:");

/*!
 *  \~chinese
 *  获取聊天室实例
 *
 *  @param aChatroomId   聊天室ID
 *
 *  @result 聊天室实例
 *
 *  \~english
 *  Create chatroom instance
 *
 *  @param aChatroomId   Chatroom id
 *
 *  @result Chatroom instance
 */
+ (instancetype)chatroomWithId:(NSString *)aChatroomId;

@end
