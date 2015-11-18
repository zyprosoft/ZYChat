/*!
 @header EMChatImage.h
 @abstract 聊天的图片对象类型
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "IEMChatFile.h"
#import "IChatImageOptions.h"

@class UIImage;
@protocol IEMMessageBody;

/*!
 @class 
 @brief 聊天的图片对象类型
 */
@interface EMChatImage : NSObject<IEMChatFile>

/*!
 @property
 @brief 文件对象的显示名
 */
@property (nonatomic, strong) NSString *displayName;

/*!
 @property
 @brief 文件对象本地磁盘位置的全路径
 */
@property (nonatomic, strong) NSString *localPath;

/*!
 @property
 @brief 文件对象所对应的文件的大小, 以字节为单位
 */
@property (nonatomic) long long fileLength;

/*!
 @property
 @brief 图片对象尺寸
 */
@property (nonatomic) CGSize size;

/*!
 @property
 @brief
 聊天对象所在的消息体对象
 @discussion
 当消息体通过聊天对象创建完成后, messageBody为非nil, 当聊天对象并不属于任何消息体对象的时候, messageBody为nil
 */
@property (nonatomic, weak) id<IEMMessageBody> messageBody;

/*!
 @property
 @brief 对上传的图片压缩设置
 @discussion 目前只支持对图片的压缩比率的设置
 */
@property (strong, nonatomic) id <IChatImageOptions> imageOptions;

/*!
 @method
 @brief 以UIImage构造图片对象
 @discussion 
 @param aImage UIImage实例
 @param aDisplayName 图片对象的显示名
 @result 图片对象
 */
- (id)initWithUIImage:(UIImage *)aImage displayName:(NSString *)aDisplayName;

/*!
 @method
 @brief 以NSData构造图片对象
 @discussion
 @param aData 图片内容
 @param aDisplayName 图片对象的显示名
 @result 图片对象
 */
- (id)initWithData:(NSData *)aData displayName:(NSString *)aDisplayName;

/*!
 @method
 @brief 以文件路径构造图片对象
 @discussion
 @param filePath 磁盘文件全路径
 @param aDisplayName 图片对象的显示名
 @result 图片对象
 */
- (id)initWithFile:(NSString *)filePath displayName:(NSString *)aDisplayName;

@end
