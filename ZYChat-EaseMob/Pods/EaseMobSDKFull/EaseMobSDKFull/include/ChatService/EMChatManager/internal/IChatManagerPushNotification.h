/*!
 @header IChatManagerPushNotification.h
 @abstract 为推送通知提供基础操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "IChatManagerBase.h"

@class EMPushNotificationOptions;

/*!
 @protocol
 @brief 本协议包括：消息推送自定义设置
 @discussion
 */
@protocol IChatManagerPushNotification <IChatManagerBase>

@required
#pragma mark - push notification properties

/*!
 @property
 @brief     消息推送设置
 */
@property (nonatomic, strong, readonly) EMPushNotificationOptions *pushNotificationOptions;

/*!
 @property
 @brief     已屏蔽接收推送消息的群ID列表
 */
@property (nonatomic, strong, readonly) NSArray *ignoredGroupIds;

/*!
 @method
 @brief 更新消息推送相关属性配置（同步方法）
 @param options    属性
 @param pError     更新错误信息
 @result    最新的属性配置
 */
- (EMPushNotificationOptions *)updatePushOptions:(EMPushNotificationOptions *)options
                                           error:(EMError **)pError;

/*!
 @method
 @brief 更新消息推送相关属性配置（异步方法）
 @param options    属性
 @discussion
    方法执行完之后，调用[didUpdatePushOptions:error:];
 */
- (void)asyncUpdatePushOptions:(EMPushNotificationOptions *)options;

/*!
 @method
 @brief 更新消息推送相关属性配置(异步方法)
 @param options    属性
 @param completion 回调
 @param aQueue     回调时的线程
 @result
 */
- (void)asyncUpdatePushOptions:(EMPushNotificationOptions *)options
                    completion:(void (^)(EMPushNotificationOptions *options, EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

#pragma mark - ignore group push notification

/*!
 @method
 @brief 屏蔽接收群的推送消息
 @param groupId    需要屏蔽/取消屏蔽 推送消息的群ID
 @param ignore     屏蔽/取消屏蔽
 @param pError     错误信息
 @result           返回已屏蔽接收推送消息的群列表
 @discussion
        全局的屏蔽推送消息属性优先于此设置
 */
- (NSArray *)ignoreGroupPushNotification:(NSString *)groupId
                                  ignore:(BOOL)ignore
                                   error:(EMError **)pError;

/*!
 @method
 @brief 屏蔽接收群的推送消息, 异步方法
 @param groupId    需要屏蔽/取消屏蔽 推送消息的群ID
 @param isIgnore   屏蔽/取消屏蔽
 @discussion
        全局的屏蔽推送消息属性优先于此设置; 
        方法执行完之后，调用[didIgnoreGroupPushNotification:error:].
 */
- (void)asyncIgnoreGroupPushNotification:(NSString *)groupId
                                isIgnore:(BOOL)isIgnore;

/*!
 @method
 @brief 屏蔽接收群的推送消息, 异步方法
 @param groupId    需要屏蔽/取消屏蔽 推送消息的群ID
 @param isIgnore   屏蔽/取消屏蔽
 @param completion 回调
 @param aQueue     回调时的线程
 @discussion
        全局的屏蔽推送消息属性优先于此设置;
 */
- (void)asyncIgnoreGroupPushNotification:(NSString *)groupId
                                isIgnore:(BOOL)isIgnore
                              completion:(void (^)(NSArray *ignoreGroupsList,
                                                   EMError *error))completion
                                 onQueue:(dispatch_queue_t)aQueue;

@optional

#pragma mark - EM_DEPRECATED_IOS

/*!
 @property
 @brief     已屏蔽接收推送消息的群ID列表
 */
@property (nonatomic, strong, readonly) NSArray *ignoredGroupList EM_DEPRECATED_IOS(2_0_0, 2_1_1, "Use - ignoredGroupIds");

@end
