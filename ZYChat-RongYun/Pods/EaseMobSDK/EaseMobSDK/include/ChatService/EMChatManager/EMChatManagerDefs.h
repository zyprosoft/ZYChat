/*!
 @header EMChatManagerDefs.h
 @abstract ChatManager相关宏定义
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#ifndef EaseMobClientSDK_EMChatManagerDefs_h
#define EaseMobClientSDK_EMChatManagerDefs_h

#import "commonDefs.h"
#import "EMPushManagerDefs.h"
#import "EMGroupManagerDefs.h"

/*!
 @enum
 @brief 聊天类型
 @constant eMessageBodyType_Text 文本类型
 @constant eMessageBodyType_Image 图片类型
 @constant eMessageBodyType_Video 视频类型
 @constant eMessageBodyType_Location 位置类型
 @constant eMessageBodyType_Voice 语音类型
 @constant eMessageBodyType_File 文件类型
 @constant eMessageBodyType_Command 命令类型
 */
typedef NS_ENUM(NSInteger, MessageBodyType) {
    eMessageBodyType_Text = 1,
    eMessageBodyType_Image,
    eMessageBodyType_Video,
    eMessageBodyType_Location,
    eMessageBodyType_Voice,
    eMessageBodyType_File,
    eMessageBodyType_Command
};

/*!
 @enum
 @brief 聊天消息发送状态
 @constant eMessageDeliveryState_Pending 待发送
 @constant eMessageDeliveryState_Delivering 正在发送
 @constant eMessageDeliveryState_Delivered 已发送, 成功
 @constant eMessageDeliveryState_Failure 已发送, 失败
 */
typedef NS_ENUM(NSInteger, MessageDeliveryState) {
    eMessageDeliveryState_Pending = 0, 
    eMessageDeliveryState_Delivering, 
    eMessageDeliveryState_Delivered, 
    eMessageDeliveryState_Failure
};

/*!
 @brief 消息回执类型
 @constant eReceiptTypeRequest   回执请求
 @constant eReceiptTypeResponse  回执响应
 */
typedef NS_ENUM(NSInteger, EMReceiptType){
    eReceiptTypeRequest  = 0,
    eReceiptTypeResponse,
};

/*
@brief 会话类型
@constant eConversationTypeChat            单聊会话
@constant eConversationTypeGroupChat       群聊会话
@constant eConversationTypeChatRoom        聊天室会话
*/
typedef NS_ENUM(NSInteger, EMConversationType){
    eConversationTypeChat,
    eConversationTypeGroupChat,
    eConversationTypeChatRoom
};

/*!
 @brief 消息类型
 @constant eMessageTypeChat            单聊消息
 @constant eMessageTypeGroupChat       群聊消息
 @constant eMessageTypeChatRoom        聊天室消息
 */
typedef NS_ENUM(NSInteger, EMMessageType){
    eMessageTypeChat,
    eMessageTypeGroupChat,
    eMessageTypeChatRoom
};

/*!
 @enum
 @brief 备份消息状态
 @constant eBackupMessagesStatusNone        初始状态
 @constant eBackupMessagesStatusFormatting  格式化消息
 @constant eBackupMessagesStatusCompressing 压缩消息
 @constant eBackupMessagesStatusUploading   上传消息
 @constant eBackupMessagesStatusUpdating    更新云端备份
 @constant eBackupMessagesStatusCancelled   取消备份
 @constant eBackupMessagesStatusFailed      备份失败
 @constant eBackupMessagesStatusSucceeded   备份成功
 */
typedef NS_ENUM(NSInteger, EMBackupMessagesStatus) {
    eBackupMessagesStatusNone = 0,
    eBackupMessagesStatusFormatting,
    eBackupMessagesStatusCompressing,
    eBackupMessagesStatusUploading,
    eBackupMessagesStatusUpdating,
    eBackupMessagesStatusCancelled,
    eBackupMessagesStatusFailed,
    eBackupMessagesStatusSucceeded,
};

/*!
 @enum
 @brief 恢复备份消息状态
 @constant eRestoreBackupStatusNone             初始状态
 @constant eRestoreBackupStatusDownload         备份下载
 @constant eRestoreBackupStatusDecompressing    解压缩
 @constant eRestoreBackupStatusImporting        导入
 @constant eRestoreBackupStatusCancelled        取消恢复
 @constant eRestoreBackupStatusFailed           恢复备份失败
 @constant eRestoreBackupStatusSucceeded         恢复备份成功
 */
typedef NS_ENUM(NSInteger, EMRestoreBackupStatus) {
    eRestoreBackupStatusNone = 0,
    eRestoreBackupStatusDownloading,
    eRestoreBackupStatusDecompressing,
    eRestoreBackupStatusImporting,
    eRestoreBackupStatusCancelled,
    eRestoreBackupStatusFailed,
    eRestoreBackupStatusSucceeded,
};

#endif
