/*!
 @header IChatManagerSettingOptions.h
 @abstract 为ChatManager提供昵称、是否自动登录等配置信息
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "IChatManagerBase.h"

/*!
 @protocol
 @brief 推送昵称、是否自动登录等配置信息
 */
@protocol IChatManagerSettingOptions <IChatManagerBase>

@optional

/*!
 @property
 @brief 当前登陆用户的昵称, 默认为用户名。
        因为环信只有用户ID, 并没有用户信息, 所以在后台发送推送的时候, 并不能知道用户昵称, 导致在推送过来的消息里, 用户名字为用户ID. 为解决此类问题, 环信多添加了一个可以由用户设置的推送昵称的属性，此方法是同步方法，会阻塞调用线程.
 */
@property (strong, nonatomic) NSString *apnsNickname;

/*!
 @property
 @brief 是否已经开启自动登录
 @discussion
 */
@property (nonatomic) BOOL isAutoLoginEnabled;

/*!
 @property
 @brief 开启自动登录功能
 @discussion
 设置后，当再次app启动时，会自动登录上次登录的账号，本设置需要在登录成功后设置才起作用。
 */
- (void)enableAutoLogin;

/*!
 @property
 @brief 关闭自动登录功能
 @discussion
 */
- (void)disableAutoLogin;

/*!
 @property
 @brief 自动获取好友列表(包括好友黑名单，Default is NO)
 @discussion
 设置为YES时, 登录成功后会自动调用 asyncFetchBuddyList 方法
 */
@property (nonatomic) BOOL isAutoFetchBuddyList;

/*!
 @property
 @brief 开启自动获取好友列表
 @discussion
 登录成功后会自动调用 asyncFetchBuddyList 方法
 */
- (void)enableAutoFetchBuddyList;

/*!
 @property
 @brief 关闭自动获取好友列表
 @discussion
 */
- (void)disableAutoFetchBuddyList;

/*!
 @property
 @brief 是否使用ip，该接口的设置不会进行存储，需要开发者每次启动sdk之前都要设置一下
 @discussion
 2.1.4版本缺省关闭，2.1.5及以后版本缺省打开
 */
@property (nonatomic) BOOL isUseIp;

/*!
 @property
 @brief 使用ip，该接口的设置不会进行存储，需要开发者每次启动sdk之前都要设置一下
 @discussion
 2.1.4版本缺省关闭，2.1.5及以后版本缺省打开
 */
- (void)enableUseIp;

/*!
 @property
 @brief 关闭ip，该接口的设置不会进行存储，需要开发者每次启动sdk之前都要设置一下
 @discussion
 2.1.4版本缺省关闭，2.1.5及以后版本缺省打开
 */
- (void)disableUseIp;

/*!
 @property
 @brief 开启消息送达通知(默认是不开启的)
 @discussion
 */
- (void)enableDeliveryNotification;

/*!
 @property
 @brief 关闭消息送达通知 (默认是不开启的)
 @discussion
 */
- (void)disableDeliveryNotification;

/*!
 @property
 @brief 离开群时是否自动删除群会话(Default is YES)，该接口的设置不会进行存储，需要开发者每次启动sdk之前都要设置一下
 @discussion
 设置为YES时, 当离开该群时会自动删除该群对应的会话
 */
@property (nonatomic) BOOL isAutoDeleteConversationWhenLeaveGroup;

/*!
 @property
 @brief 开启离开群组后自动删除对应会话
 @discussion
 当开启后, 当离开该群时会自动删除该群对应的会话
 */
- (void)enableAutoDeleteConversatonWhenLeaveGroup;

/*!
 @property
 @brief 关闭离开群组后自动删除对应会话
 @discussion
 当关闭后, 当离开该群时不会自动删除该群对应的会话
 */
- (void)disableAutoDeleteConversatonWhenLeaveGroup;

@optional

#pragma mark - EM_DEPRECATED_IOS

/*!
 @property
 @brief 当前登陆用户的昵称, 默认为用户名。
 因为环信只有用户ID, 并没有用户信息, 所以在后台发送推送的时候, 并不能知道用户昵称, 导致在推送过来的消息里, 用户名字为用户ID. 为解决此类问题, 环信多添加了一个可以由用户设置的推送昵称的属性.
 */
@property (strong, nonatomic) NSString *nickname EM_DEPRECATED_IOS(2_0_6, 2_1_1, "apnsNickname");

/*!
 @property
 @brief 自动获取好友列表(包括好友黑名单，Default is NO),
 @discussion
 设置为YES时, 登录成功后会自动调用 asyncFetchBuddyList 方法
 */
@property (nonatomic) BOOL autoFetchBuddyList EM_DEPRECATED_IOS(2_0_9, 2_1_1, "isAutoFetchBuddyList");

@end
