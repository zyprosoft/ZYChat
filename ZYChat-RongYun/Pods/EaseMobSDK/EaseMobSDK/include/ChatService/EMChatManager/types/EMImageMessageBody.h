/*!
 @header EMImageMessageBody.h
 @abstract 聊天的图片消息体对象类型
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

#import "IEMFileMessageBody.h"
#import "EMChatManagerDefs.h"

@class EMChatImage;
@class EMMessage;
@protocol IEMChatObject;

/*!
 @class
 @brief 聊天的图片消息体对象
 */
@interface EMImageMessageBody : NSObject<IEMFileMessageBody>

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
 @brief 图片消息体中的预览图文件的服务器uuid
 */
@property (nonatomic, strong) NSString *thumbnailUuid;

/*!
 @property
 @brief 图片消息体中的预览图的显示名
 */
@property (nonatomic, strong) NSString *thumbnailDisplayName;

/*!
 @property
 @brief 图片消息体中的预览图文件的本地路径
 */
@property (nonatomic, strong) NSString *thumbnailLocalPath;

/*!
 @property
 @brief 图片消息体中的预览图文件的服务器远程路径
 */
@property (nonatomic, strong) NSString *thumbnailRemotePath;

/*!
 @property
 @brief 远端图片预览文件的密钥, 下载时需要图片预览文件密钥和用户安全信息配合以下载远程图片预览文件
 */
@property (nonatomic, strong) NSString *thumbnailSecretKey;

/*!
 @property
 @brief 图片消息体中的预览图的尺寸
 */
@property (nonatomic) CGSize thumbnailSize;

/*!
 @property
 @brief 图片消息体中的预览图文件的大小, 以字节为单位
 */
@property (nonatomic) long long thumbnailFileLength;

/*!
 @property
 @brief 图片消息体中的大图的显示名
 */
@property (nonatomic, strong) NSString *displayName;

/*!
 @property
 @brief 图片消息体中的大图文件的本地路径
 */
@property (nonatomic, strong) NSString *localPath;

/*!
 @property
 @brief 图片消息体中图片文件的服务器远程路径
 */
@property (nonatomic, strong) NSString *remotePath;

/*!
 @property
 @brief 远端图片文件的密钥, 下载时需要图片文件密钥和用户安全信息配合以下载远程图片文件
 */
@property (nonatomic, strong) NSString *secretKey;

/*!
 @property
 @brief 图片消息体中的大图的尺寸
 */
@property (nonatomic) CGSize size;

/*!
 @property
 @brief 图片消息体中的大图文件的大小, 以字节为单位
 */
@property (nonatomic) long long fileLength;

/*!
 @property
 @brief 图片消息体中的大图对象
 */
@property (nonatomic, readonly, strong) EMChatImage *image;

/*!
 @property
 @brief 图片消息体中的预览图对象
 */
@property (nonatomic, readonly, strong) EMChatImage *thumbnailImage;

/*!
 @property
 @brief 大图下载状态
 */
@property (nonatomic)EMAttachmentDownloadStatus attachmentDownloadStatus;

/*!
 @property
 @brief 缩略图下载状态
 */
@property (nonatomic)EMAttachmentDownloadStatus thumbnailDownloadStatus;

/*!
 @method
 @brief 以图片对象创建图片消息体
 @discussion 如果预览图对象为空或与大图为同一实例, 则会自动创建预览图对象
 @param aImage 大图对应的图片对象
 @param aThumbnialImage 预览图图对应的图片对象
 @result 图片消息体
 */
- (id)initWithImage:(EMChatImage *)aImage thumbnailImage:(EMChatImage *)aThumbnialImage;

/*!
 @method
 @brief 以图片对象创建图片消息体
 @discussion 会自动创建预览图对象
 @param aChatObject 大图对应的图片对象
 @result 图片消息体
 */
- (id)initWithChatObject:(EMChatImage *)aChatObject;

/*!
 @method
 @brief 以图片属性创建图片消息体
 @discussion 会自动创建预览图对象，如果传入的参数有误会返回nil
 @param bodyDict 图片属性
 @param chatter 所属消息的chatter
 @result 图片消息体
 */
+ (instancetype)imageMessageBodyFromBodyDict:(NSDictionary *)bodyDict forChatter:(NSString *)chatter;
@end
