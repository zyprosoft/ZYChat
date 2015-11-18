/*!
 @header EMPushNotificationOptions.h
 @abstract 消息推送参数设置
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "EMChatManagerDefs.h"

/*!
 @class
 @brief 消息推送参数设置
 */
@interface EMPushNotificationOptions : NSObject

/*!
 @property
 @brief 推送消息显示的昵称
 */
@property (nonatomic, strong) NSString *nickname;

/*!
 @property
 @brief 推送消息显示的类型
 */
@property (nonatomic) EMPushNotificationDisplayStyle displayStyle;

/*!
 @property
 @brief 推送消息是否开启了免打扰模式，YES:开启免打扰；NO:未开启免打扰
 */
@property (nonatomic) BOOL noDisturbing EM_DEPRECATED_IOS(2_0_6, 2_1_4, "Use - noDisturbStatus");

/*!
 @property
 @brief 推送消息的免打扰设置，YES:开启免打扰；NO:未开启免打扰
 */
@property (nonatomic) EMPushNotificationNoDisturbStatus noDisturbStatus;

/*!
 @property
 @brief 推送消息免打扰模式开始时间，小时，暂时只支持整点（小时）
 */
@property (nonatomic) NSUInteger noDisturbingStartH;

/*!
 @property
 @brief 推送消息免打扰模式开始时间，分钟，暂时不支持
 */
@property (nonatomic) NSUInteger noDisturbingStartM;

/*!
 @property
 @brief 推送消息免打扰模式结束时间，小时，暂时只支持整点（小时）
 */
@property (nonatomic) NSUInteger noDisturbingEndH;

/*!
 @property
 @brief 推送消息免打扰模式结束时间，分钟，暂时不支持
 */
@property (nonatomic) NSUInteger noDisturbingEndM;

/*!
 @property
 @brief  备份消息的类型（iOS or Android）
 */
@property (strong, nonatomic) NSString *backupType;

/*!
 @property
 @brief  备份消息的版本
 */
@property (strong, nonatomic) NSString *backupVersion;

/*!
 @property
 @brief  备份消息的大小 bytes
 */
@property (nonatomic) NSUInteger backupDataSize;

/*!
 @property
 @brief  备份消息的时间戳
 */
@property (nonatomic) NSTimeInterval backupTimeInterval;

/*!
 @property
 @brief  备份消息的下载地址,以“,”组合成字符串
 */
@property (strong, nonatomic) NSString *backupPaths;

@end
