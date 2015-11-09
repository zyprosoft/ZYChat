/*!
 @header EMGroup.h
 @abstract 群组对象类型
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "commonDefs.h"
#import "EMGroupStyleSetting.h"

@class EMError;
@class EMGroupOccupant;

/*!
 @class
 @brief 聊天消息类
 */
@interface EMGroup : NSObject

/*!
 @property
 @brief 群组ID
 */
@property (nonatomic, strong, readonly) NSString *groupId;

/*!
 @property
 @brief 群组的主题
 */
@property (nonatomic, strong, readonly) NSString *groupSubject;

/*!
 @property
 @brief 群组的描述
 */
@property (nonatomic, strong, readonly) NSString *groupDescription;

/*!
 @property
 @brief 群组的实际总人数
 */
@property (nonatomic, readonly) NSInteger groupOccupantsCount;

/*!
 @property
 @brief 群组的在线人数
 */
@property (nonatomic, readonly) NSInteger groupOnlineOccupantsCount;

/*!
 @property
 @brief 此群组的密码
 */
@property (nonatomic, strong, readonly) NSString *password EM_DEPRECATED_IOS(2_0_3, 2_1_3, "Delete");

/*!
 @property
 @brief 此群是否为公开群组
 */
@property (nonatomic, readonly) BOOL isPublic;

/*!
 @property
 @brief  群组属性配置
 */
@property (nonatomic, strong, readonly) EMGroupStyleSetting *groupSetting;

/*!
 @property
 @brief  此群组是否接收推送通知
 */
@property (nonatomic, readonly) BOOL isPushNotificationEnabled;

/*!
 @property
 @brief  此群组是否被屏蔽
 */
@property (nonatomic, readonly) BOOL isBlocked;

/*!
 @property
 @brief 群组的创建者
 @discussion
 群组的所有者只有一人
 */
@property (nonatomic, strong, readonly) NSString *owner;

/*!
 @property
 @brief 群组的管理员列表
 @discussion
 群组的管理员不止一人,可以通过动态更改群组成员的角色而成为群组的管理员
 */
@property (nonatomic, strong, readonly) NSArray  *admins EM_DEPRECATED_IOS(2_0_3, 2_0_9, "Delete");

/*!
 @property
 @brief 群组的普通成员列表
 */
@property (nonatomic, strong, readonly) NSArray  *members;

/*!
 @property
 @brief 此群组中的所有成员列表(owner, members)
 */
@property (nonatomic, strong, readonly) NSArray  *occupants;

/*!
 @property
 @brief 此群组黑名单中的成员列表
 @discussion 需要owner权限才能查看，非owner返回nil
 */
@property (nonatomic, strong, readonly) NSArray  *bans;

/*!
 @method
 @brief 通过username获取它的属性(一般只有匿名群中会用到)
 @param username 需要获取的occupant信息的username
 @result 返回username在群组中的属性
 */
- (EMGroupOccupant *)occupantWithUsername:(NSString *)username;

/*!
 @method
 @brief 如果不存在则创建一个群组实例
 @param groupId          群组ID
 @result 返回群组实例
 */
+ (instancetype)groupWithId:(NSString *)groupId;
@end
