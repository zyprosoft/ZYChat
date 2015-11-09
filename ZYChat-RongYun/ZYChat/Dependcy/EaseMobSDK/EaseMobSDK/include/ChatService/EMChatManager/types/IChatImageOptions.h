/*!
 @header IChatImageOptions.h
 @abstract 发送图片消息时的压缩设置协议
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

/*!
 @protocol
 @brief 本协议主要用于发送图片消息时的压缩设置, 目前只支持压缩比率的设置
 @discussion
 */
@protocol IChatImageOptions <NSObject>

@required

/*!
 @property
 @brief 发送图片信息时的压缩比率
 @discussion 为1.0的时候, 不压缩, 越小图片质量就越小. 如果设置为0, 则使用默认值(0.6)进行压缩
 */
@property (assign, nonatomic) CGFloat compressionQuality;

@end
