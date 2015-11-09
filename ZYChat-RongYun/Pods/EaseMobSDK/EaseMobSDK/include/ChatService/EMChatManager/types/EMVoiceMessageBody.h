/*!
 @header EMVoiceMessageBody.h
 @abstract 聊天的语音消息体对象类型
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "IEMFileMessageBody.h"
#import "EMChatManagerDefs.h"

@class EMMessage;
@class EMChatVoice;
@protocol IEMChatObject;

/*!
 @class
 @brief 聊天的语音消息体对象
 */
@interface EMVoiceMessageBody : NSObject<IEMFileMessageBody>

/*!
 @property
 @brief 消息体的类型
 */
@property (nonatomic, readonly) MessageBodyType messageBodyType;

/*!
 @property
 @brief 消息体的底层聊天对象
 */
@property (nonatomic, strong, readonly) id<IEMChatObject> chatObject;

/*!
 @property
 @brief 消息体所在的消息对象
 */
@property (nonatomic, weak) EMMessage *message;

/*!
 @property
 @brief 文件消息体的显示名
 */
@property (nonatomic, strong) NSString *displayName;

/*!
 @property
 @brief 文件消息体的本地文件路径
 */
@property (nonatomic, strong) NSString *localPath;

/*!
 @property
 @brief 文件消息体的服务器远程文件路径
 */
@property (nonatomic, strong) NSString *remotePath;

/*!
 @property
 @brief 远端语音文件的密钥, 下载时需要语音文件密钥和用户安全信息配合以下载远程语音文件
 */
@property (nonatomic, strong) NSString *secretKey;

/*!
 @property
 @brief 文件消息体的文件长度, 以字节为单位
 */
@property (nonatomic) long long fileLength;

/*!
 @property
 @brief 语音时长, 秒为单位
 */
@property (nonatomic) NSInteger duration;

/*!
 @property
 @brief 语音附件是否下载完成
 */
@property (nonatomic)EMAttachmentDownloadStatus attachmentDownloadStatus;

/*!
 @method
 @brief 以语音对象创建语音消息体实例
 @discussion
 @param aChatVoice 语音对象
 @result 语音消息体
 */
- (id)initWithChatObject:(EMChatVoice *)aChatVoice;

/*!
 @method
 @brief 以语音属性创建语音消息体
 @discussion 如果传入的参数有误会返回nil
 @param bodyDict 语音属性
 @param chatter 所属消息的chatter
 @result 语音消息体
 */
+ (instancetype)voiceMessageBodyFromBodyDict:(NSDictionary *)bodyDict forChatter:(NSString *)chatter;
@end
