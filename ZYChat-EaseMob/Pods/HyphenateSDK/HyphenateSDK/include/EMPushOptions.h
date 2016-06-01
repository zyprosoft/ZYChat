/*!
 *  \~chinese
 *  @header EMPushOptions.h
 *  @abstract 消息推送的设置选项
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMPushOptions.h
 *  @abstract Setting options of Apple APNS
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#define kPushNickname @"nickname"
#define kPushDisplayStyle @"notification_display_style"
#define kPushNoDisturbing @"notification_no_disturbing"
#define kPushNoDisturbingStartH @"notification_no_disturbing_start"
#define kPushNoDisturbingStartM @"notification_no_disturbing_startM"
#define kPushNoDisturbingEndH @"notification_no_disturbing_end"
#define kPushNoDisturbingEndM @"notification_no_disturbing_endM"

/*!
 *  \~chinese 
 *  推送消息的显示风格
 *
 *  \~english 
 *  Display style of push message
 */
typedef enum{
    EMPushDisplayStyleSimpleBanner = 0, /*! 
                                         *  \~chinese
                                         *  简单显示"您有一条新消息"
                                         *
                                         *  \~english
                                         *  Simply show "You have a new message"
                                         */
    EMPushDisplayStyleMessageSummary,   /*! 
                                         *  \~chinese 
                                         *  显示消息内容
                                         * 
                                         *  \~english 
                                         *  Show message's content
                                         */
}EMPushDisplayStyle;

/*!
 *  \~chinese 
 *  推送免打扰设置的状态
 *
 *  \~english 
 *  Status of APNS no-disturb setting
 */
typedef enum{
    EMPushNoDisturbStatusDay = 0,   /*! \~chinese 全天免打扰 \~english The whole day */
    EMPushNoDisturbStatusCustom,    /*! \~chinese 自定义时间段免打扰 \~english User defined period */
    EMPushNoDisturbStatusClose,     /*! \~chinese 关闭免打扰 \~english Close no-disturb mode */
}EMPushNoDisturbStatus;

/*!
 *  \~chinese 
 *  消息推送的设置选项
 *
 *  \~english 
 *  Apple APNS setting options
 */
@interface EMPushOptions : NSObject

/*!
 *  \~chinese 
 *  推送消息显示的昵称
 *
 *  \~english 
 *  Nick name to show for push message
 */
@property (nonatomic, strong) NSString *nickname;

/*!
 *  \~chinese 
 *  推送消息显示的类型
 *
 *  \~english 
 *  Display style of push message
 */
@property (nonatomic) EMPushDisplayStyle displayStyle;

/*!
 *  \~chinese 
 *  消息推送的免打扰设置
 *
 *  \~english 
 *  No-disturb setting of push message
 */
@property (nonatomic) EMPushNoDisturbStatus noDisturbStatus;

/*!
 *  \~chinese 
 *  消息推送免打扰开始时间，小时，暂时只支持整点（小时）
 *
 *  \~english 
 *  No-disturn mode start time, only supports hour
 */
@property (nonatomic) NSInteger noDisturbingStartH;

/*!
 *  \~chinese 
 *  消息推送免打扰结束时间，小时，暂时只支持整点（小时）
 *
 *  \~english 
 *  No-disturn mode end time, only supports hour
 */
@property (nonatomic) NSInteger noDisturbingEndH;

@end
