/*!
 @header IEMFileMessageBody.h
 @abstract 基于文件类的消息体接口
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "IEMMessageBody.h"

//消息体类型键
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeyType;

//附件属性键
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeyUrl;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeySecret;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeyFileName;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeyFileLength;

//图片大小属性键
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeySize;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeySizeWidth;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeySizeHeight;

//缩略图属性键
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeyThumb;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeyThumbSecret;

//音视频时长
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrKeyDuration;

//消息体类型
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrTypeTxt;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrTypeImag;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrTypeAudio;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrTypeLoc;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrTypeVideo;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrTypeFile;
FOUNDATION_EXTERN NSString * const EMMessageBodyAttrTypeCmd;

/*!
 @enum
 @brief 附件下载的状态
 @constant EMAttachmentDownloading       正在下载
 @constant EMAttachmentDownloadSuccessed 下载成功
 @constant EMAttachmentDownloadFailure   下载失败
 @constant EMAttachmentNotStarted        未下载
 */
typedef NS_ENUM(NSUInteger, EMAttachmentDownloadStatus) {
    EMAttachmentDownloading,
    EMAttachmentDownloadSuccessed,
    EMAttachmentDownloadFailure,
    EMAttachmentNotStarted,
} ;


/*!
 @protocol
 @brief 基于文件类型的消息体接口协议
 */
@protocol IEMFileMessageBody <IEMMessageBody>

@required

/*!
 @property
 @brief 文件uuid
 */
@property (nonatomic, strong) NSString *uuid;

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
 @brief 远端文件的密钥, 下载时需要文件密钥和用户安全信息配合以下载远程文件
 */
@property (nonatomic, strong) NSString *secretKey;

/*!
 @property
 @brief 附件是否下载完成
 */
@property (nonatomic)EMAttachmentDownloadStatus attachmentDownloadStatus;

/*!
 @property
 @brief 文件消息体的文件长度, 以字节为单位
 */
@property (nonatomic) long long fileLength;

@end
