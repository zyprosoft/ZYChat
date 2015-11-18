/*!
 @header EMPushManagerDefs.h
 @abstract PushManager相关宏定义
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#ifndef EaseMobClientSDK_EMPushManagerDefs_h
#define EaseMobClientSDK_EMPushManagerDefs_h

#define kPushNotificationMaskDisplayStyle      0x01
#define kPushNotificationMaskNickname          0x01<<1
#define kPushNotificationMaskNoDisturbing      0x01<<2
#define kPushNotificationMaskNoDisturbingStart 0x01<<3
#define kPushNotificationMaskNoDisturbingEnd   0x01<<4
#define kPushNotificationMaskAll               0x01<<7

/*!
 @enum
 @brief 推送消息的定制信息
 @constant ePushNotificationDisplayStyle_simpleBanner   简单显示一条"您有一条新消息"的文本
 @constant ePushNotificationDisplayStyle_messageSummary 会显示一条具有消息内容的推送消息
 */
typedef NS_ENUM(NSInteger, EMPushNotificationDisplayStyle) {
    ePushNotificationDisplayStyle_simpleBanner = 0,
    ePushNotificationDisplayStyle_messageSummary = 1,
};

/*!
 @enum
 @brief 推送消息免打扰设置的状态
 @constant ePushNotificationNoDisturbStatusDay     全天免打扰
 @constant ePushNotificationNoDisturbStatusCustom  自定义时间段免打扰
 @constant ePushNotificationNoDisturbStatusClose   关闭免打扰模式
 */
typedef NS_ENUM(NSInteger, EMPushNotificationNoDisturbStatus) {
    ePushNotificationNoDisturbStatusDay = 0,
    ePushNotificationNoDisturbStatusCustom = 1,
    ePushNotificationNoDisturbStatusClose = 2,
};

#endif
