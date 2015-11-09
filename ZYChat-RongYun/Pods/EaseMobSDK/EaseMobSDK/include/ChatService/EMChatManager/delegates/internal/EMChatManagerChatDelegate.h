/*!
 @header EMChatManagerChatDelegate.h
 @abstract 关于ChatManager中聊天相关功能的异步回调
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "EMChatManagerDelegateBase.h"
#import "commonDefs.h"

@class EMMessage;
@class EMConversation;
@class EMError;
@class EMReceipt;

/*!
 @protocol
 @brief 本协议包括：发送消息时的回调、接收到消息时的回调等其它操作
 @discussion
 */
@protocol EMChatManagerChatDelegate <EMChatManagerDelegateBase>

@optional

/*!
 @method
 @brief 将要发送消息时的回调
 @discussion
 @param message      将要发送的消息对象
 @param error        错误信息
 @result
 */
- (void)willSendMessage:(EMMessage *)message
                 error:(EMError *)error;

/*!
 @method
 @brief 发送消息后的回调
 @discussion
 @param message      已发送的消息对象
 @param error        错误信息
 @result
 */
- (void)didSendMessage:(EMMessage *)message
                error:(EMError *)error;

/*!
 @method
 @brief 收到消息时的回调
 @param message      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时, 会触发此回调
             针对有附件的消息, 此时附件还未被下载.
             附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:, 
             下载完所有附件后, 回调didMessageAttachmentsStatusChanged:error:会被触发
 */
- (void)didReceiveMessage:(EMMessage *)message;

/*!
 @method
 @brief 收到消息时的回调
 @param cmdMessage      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时, 会触发此回调
 针对有附件的消息, 此时附件还未被下载.
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:,
 下载完所有附件后, 回调didMessageAttachmentsStatusChanged:error:会被触发
 */
- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage;

/*!
 @method
 @brief 收到发送消错误的回调
 @param messageId           消息Id
 @param conversationChatter 会话的username/groupId
 @param error               错误信息
 */
- (void)didReceiveMessageId:(NSString *)messageId
                    chatter:(NSString *)conversationChatter
                      error:(EMError *)error;

/*!
 @method
 @brief SDK接收到消息时, 下载附件的进度回调, 回调方法有不在主线程中调用, 需要App自己切换到主线程中执行UI的刷新等操作
 @discussion SDK接收到消息时, 有以下两种情况:
    1. 如果是带缩略图的消息时(图片或Video), 会自动下载缩略图, 
        下载完成后, 会调用 didMessageAttachmentsStatusChanged:error这个回调
    2. 如果是语音消息时, 会自动下载语音附件, 
        会调用 didMessageAttachmentsStatusChanged:error这个回调
 @param message  正在下载的消息对象
 @param progress 下载进度
 @result
 */
- (void)didFetchingMessageAttachments:(EMMessage *)message
                            progress:(float)progress;

/*!
 @method
 @brief SDK接收到消息时, 下载附件成功或失败的回调
 @discussion SDK接收到消息时, 有以下两种情况:
     1. 如果是带缩略图的消息时(图片或Video), 会自动下载缩略图,
     2. 如果是语音消息时, 会自动下载语音附件,
 @param message  下载完成的消息对象
 @param error    若附件下载成功, error为nil, 若下载失败, 则会返回相应的error信息
 @result
 */
- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error;

/*!
 @method
 @brief 收到"已读回执"时的回调方法
 @discussion 发送方收到接收方发送的一个收到消息的回执, 意味着接收方已阅读了该消息
 @param resp 收到的"已读回执"对象, 包括 from, to, chatId等
 @result
 */
- (void)didReceiveHasReadResponse:(EMReceipt *)resp;

/*!
 @method
 @brief 收到"已送达回执"时的回调方法
 @discussion 发送方收到接收方发送的一个收到消息的回执, 但不意味着接收方已阅读了该消息
 @param resp 收到的"已送达回执"对象, 包括 from, to, chatId等
 @result
 */
- (void)didReceiveHasDeliveredResponse:(EMReceipt *)resp;

/*!
 @method
 @brief 会话列表信息更新时的回调
 @discussion 1. 当会话列表有更改时(新添加,删除), 2. 登陆成功时, 以上两种情况都会触发此回调
 @param conversationList 会话列表
 @result
 */
- (void)didUpdateConversationList:(NSArray *)conversationList;

/*!
 @method
 @brief 未读消息数改变时的回调
 @discussion 当EMConversation对象的enableUnreadMessagesCountEvent为YES时,会触发此回调
 @result
 */
- (void)didUnreadMessagesCountChanged;

/*!
 @method
 @brief 将要接收离线消息的回调
 @discussion
 @result
 */
- (void)willReceiveOfflineMessages;

/*!
 @method
 @brief 接收到离线非透传消息的回调
 @discussion
 @param offlineMessages 接收到的离线列表
 @result
 */
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages;

/*!
 @method
 @brief 接收到离线透传消息的回调
 @discussion
 @param offlineCmdMessages 接收到的离线透传消息列表
 @result
 */
- (void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages;


/*!
 @method
 @brief 离线非透传消息接收完成的回调
 @discussion
 @param offlineMessages 接收到的离线列表
 @result
 */
- (void)didFinishedReceiveOfflineMessages;

/*!
 @method
 @brief 离线透传消息接收完成的回调
 @discussion
 @param offlineCmdMessages 接收到的离线透传消息列表
 @result
 */
- (void)didFinishedReceiveOfflineCmdMessages;

#pragma mark - EM_DEPRECATED_IOS

/*!
 @method
 @brief 离线透传消息接收完成的回调
 @discussion
 @param offlineCmdMessages 接收到的离线透传消息列表
 @result
 */
- (void)didFinishedReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages EM_DEPRECATED_IOS(2_1_5,2_1_8,"使用didFinishedReceiveOfflineCmdMessages标识离线消息结束，离线CMD全部通过didReceiveOfflineCmdMessages返回");

/*!
 @method
 @brief 离线非透传消息接收完成的回调
 @discussion
 @param offlineMessages 接收到的离线列表
 @result
 */
- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages EM_DEPRECATED_IOS(2_1_5,2_1_8,"使用didFinishedReceiveOfflineMessages标识离线消息结束，离线消息全部通过didReceiveOfflineMessages返回");

@end
