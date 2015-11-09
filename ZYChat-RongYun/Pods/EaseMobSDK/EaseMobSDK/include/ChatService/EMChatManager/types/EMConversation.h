/*!
 @header EMConversation.h
 @abstract 聊天的会话对象类型
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "EMChatManagerDefs.h"

@class EMMessage;

/*!
 @class
 @brief 聊天的会话对象
 */
@interface EMConversation : NSObject<NSCoding>

/*!
 @property
 @brief 会话对方的用户名. 如果是群聊, 则是群组的id
 */
@property (nonatomic, strong, readonly) NSString *chatter;

/*!
 @property
 @brief 是否是群聊
 */
@property (nonatomic, readonly) BOOL isGroup EM_DEPRECATED_IOS(2_0_0, 2_1_6, "Use - conversationType");

/*!
 @property
 @brief 是否接收关于此会话的未读消息变更通知
 */
@property (nonatomic, readwrite) BOOL enableUnreadMessagesCountEvent;

/*!
 @property
 @brief 会话扩展
 */
@property (nonatomic, strong) NSDictionary *ext;

/*!
 @property
 @brief 此会话中的消息列表
 */
@property (nonatomic, strong, readonly) NSArray *messages EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Delete");

/*!
 @property
 @brief 是否接收关于此会话的消息
 */
@property (nonatomic, readwrite) BOOL enableReceiveMessage EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Delete");

/*!
 @property
 @brief 会话类型
 */
@property (nonatomic, readonly) EMConversationType conversationType;

#pragma mark - message

/*!
 @method
 @brief 删除会话对象和数据库中相关联的某一条消息
 @discussion 如果此消息不属于或不存在于此会话, 则不会进行删除
 @param aMessageId 将要删除的消息ID
 @result 是否成功删除此消息
 */
//- (BOOL)removeMessage:(NSString *)aMessageId EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Delete");
- (BOOL)removeMessageWithId:(NSString *)aMessageId;

/*!
 @method
 @brief 删除会话对象中的指定消息
 @discussion
 @result 删除是否成功
 */
- (BOOL)removeMessage:(EMMessage *)aMessage;

/*!
 @method
 @brief 删除会话对象和数据库中相关联的某几条消息
 @discussion 如果消息不属于或不存在于此会话, 则不会进行删除相应的消息
 @param aMessageIds 将要删除的消息ID列表
 @result 成功删除的消息条数
 */
- (NSUInteger)removeMessages:(NSArray *)aMessageIds EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Use - removeMessagesWithIds:");
- (NSUInteger)removeMessagesWithIds:(NSArray *)aMessageIds;

/*!
 @method
 @brief 删除会话对象中相关联所有消息
 @discussion
 @result 删除是否成功
 */
- (BOOL)removeAllMessages;

/*!
 @method
 @brief 从数据库中加载消息
 @discussion
 @result 加载的消息列表
 */
- (NSArray *)loadAllMessages;

/*!
 @method
 @brief 根据消息ID从数据库中加载消息
 @discussion 如果数据库中没有这条消息, 方法返回nil
 @param aMessageId 消息ID
 @result 加载的消息
 */
- (EMMessage *)loadMessage:(NSString *)aMessageId EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Use - loadMessageWithId:");
- (EMMessage *)loadMessageWithId:(NSString *)aMessageId;

/*!
 @method
 @brief 根据消息ID列表从数据库中加载消息
 @discussion 如果数据库中没有某条消息对应的ID, 则不加载这条消息
 @param aMessageIds 消息ID列表
 @result 加载的消息列表
 */
- (NSArray *)loadMessages:(NSArray *)aMessageIds EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Use - loadMessagesWithIds:");
- (NSArray *)loadMessagesWithIds:(NSArray *)aMessageIds;

/*!
 @method
 @brief 根据时间加载指定条数的消息
 @param aCount 要加载的消息条数
 @param timestamp 时间点, UTC时间, 以毫秒为单位
 @discussion
 1. 加载后的消息按照升序排列;
 2. NSDate返回的timeInterval是以毫秒为单位的, 如果使用NSDate, 比如 timeIntervalSince1970 方法，需要将 timeInterval 乘以1000
 @result 加载的消息列表
 */
- (NSArray *)loadNumbersOfMessages:(NSUInteger)aCount before:(long long)timestamp;


/*!
 @method
 @brief 根据消息id加载它之前的指定条数消息
 @param aCount 要加载的消息条数
 @param messageId 消息id，如果传nil就是取最后一条消息
 @discussion
    加载后的消息按照升序排列（不包含传入的messageId对应的消息）;
 @result 加载的消息列表
 */
- (NSArray *)loadNumbersOfMessages:(NSUInteger)aCount withMessageId:(NSString *)messageId;

/*!
 @method
 @brief 根据时间和类型加载指定条数的消息
 @param aCount 要加载的消息条数
 @param type   消息体类型
 @param timestamp 时间点, UTC时间, 以毫秒为单位
 @discussion
 1. 加载后的消息按照升序排列;
 2. NSDate返回的timeInterval是以毫秒为单位的, 如果使用NSDate, 比如 timeIntervalSince1970 方法，需要将 timeInterval 乘以1000
 @result 加载的消息列表
 */
- (NSArray *)loadNumbersOfMessages:(NSUInteger)aCount bodyType:(MessageBodyType)type before:(long long)timestamp;

/*!
 @method
 @brief 获取conversation最新一条消息
 @result EMMessage最新一条消息
 */
- (EMMessage *)latestMessage;

/*!
 @method
 @brief 获取conversation从对方发过来的最新一条消息
 @result EMMessage最新一条消息
 */
- (EMMessage *)latestMessageFromOthers;

#pragma mark - mark conversation

/*!
 @method
 @brief 把本对话里的所有消息标记为已读/未读(此方法调用后，需要从数据库重新获取数据)
 @param isRead 已读或未读
 @result 成功标记的消息条数
 */
- (NSUInteger)markMessagesAsRead:(BOOL)isRead EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Use - markAllMessagesAsRead:");
- (BOOL)markAllMessagesAsRead:(BOOL)isRead;

/*!
 @method
 @brief 把本条消息标记为已读/未读
 @discussion 非此conversation的消息不会被标记
 @param aMessageId 需要被标记的消息ID
 @param isRead 已读或未读
 @result 是否成功标记此条消息
 */
- (BOOL)markMessage:(NSString *)aMessageId asRead:(BOOL)isRead EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Use - markMessageWithId:asRead");
- (BOOL)markMessageWithId:(NSString *)aMessageId asRead:(BOOL)isRead;

#pragma mark - statistics

/*!
 @method
 @brief 获取此对话中所有未读消息的条数
 @discussion
 @result 此对话中所有未读消息的条数
 */
- (NSUInteger)unreadMessagesCount;

@end
