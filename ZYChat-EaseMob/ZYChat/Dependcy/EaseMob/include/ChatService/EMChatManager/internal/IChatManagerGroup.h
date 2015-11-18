/*!
 @header IChatManagerGroup.h
 @abstract 为ChatManager提供群组的基础操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "IChatManagerBase.h"
#import "EMGroupManagerDefs.h"

@class EMGroup;
@class EMError;
@class EMGroupStyleSetting;
@class EMCursorResult;

/*!
 @protocol
 @brief 本协议包括：创建, 销毁, 加入, 退出等群组操作
 @discussion 所有不带Block回调的异步方法, 需要监听回调时, 需要先将要接受回调的对象注册到delegate中, 示例代码如下:
            [[[EaseMob sharedInstance] chatManager] addDelegate:self delegateQueue:dispatch_get_main_queue()]
 */
@protocol IChatManagerGroup <IChatManagerBase>

@required

#pragma mark - properties

/*!
 @property
 @brief 所加入和创建的群组列表, 群组对象
 */
@property (nonatomic, strong, readonly) NSArray *groupList;

#pragma mark - load groups from database

/*!
 @method
 @brief  从数据库获取与登陆者相关的群组
 @param append2Chat  是否加到内存中。
        YES为加到内存中。加到内存中之后, 会有相应的回调被触发从而更新UI;
        NO为不加到内存中。如果不加到内存中, 则只会直接添加进DB, 不会有SDK的回调函数被触发从而去更新UI。
 @return 错误信息
 */
- (NSArray *)loadAllMyGroupsFromDatabaseWithAppend2Chat:(BOOL)append2Chat;

#pragma mark - create group, Founded in 2.0.3 version

/*!
 @method
 @brief  创建群组（同步方法）
 @param subject        群组名称
 @param description    群组描述
 @param invitees       默认群组成员（usernames，不需要包含创建者username）
 @param welcomeMessage 群组欢迎语
 @param styleSetting   群组属性配置
 @param pError          建组的错误。成功为nil
 @return 创建好的群组
 @discussion
        创建群组成功 判断条件：*pError == nil && returnGroup != nil
 */
- (EMGroup *)createGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupStyleSetting *)styleSetting
                              error:(EMError **)pError;

/*!
 @method
 @brief  创建群组（异步方法）。
 @param subject        群组名称
 @param description    群组描述
 @param invitees       默认群组成员（usernames，不需要包含创建者username）
 @param welcomeMessage 群组欢迎语
 @param styleSetting   群组属性配置
 @discussion
        函数执行完, 回调[group:didCreateWithError:]会被触发
 */
- (void)asyncCreateGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupStyleSetting *)styleSetting;

/*!
 @method
 @brief  创建群组（异步方法）。
 @param subject        群组名称
 @param description    群组描述
 @param invitees       默认群组成员（usernames，不需要包含创建者username）
 @param welcomeMessage 群组欢迎语
 @param styleSetting   群组属性配置
 @param completion     创建完成后的回调
 @param aQueue         回调block时的线程
 @discussion
        创建群组成功 判断条件：completion中，error == nil && group != nil
        函数执行完, 会调用参数completion
 */
- (void)asyncCreateGroupWithSubject:(NSString *)subject
                        description:(NSString *)description
                           invitees:(NSArray *)invitees
              initialWelcomeMessage:(NSString *)welcomeMessage
                       styleSetting:(EMGroupStyleSetting *)styleSetting
                         completion:(void (^)(EMGroup *group,
                                              EMError *error))completion
                            onQueue:(dispatch_queue_t)aQueue;


#pragma mark - create Anonymous group(匿名群组), Founded in 2.0.9 version

/*!
 @method
 @brief 创建匿名群组（同步方法）
 @param subject        群组名称
 @param description    群组描述
 @param welcomeMessage 群组欢迎语
 @param nickname        创建群组时群主的昵称(匿名聊天时的昵称)
 @param styleSetting   群组属性配置(groupStyle 必须为 eGroupStyle_PublicAnonymous, 目前只可以设置 maxUsersCount)
 @param pError          建组的错误。成功为nil
 @return 创建好的群组
 @discussion
 创建群组成功 判断条件：*pError == nil && returnGroup != nil
 */
- (EMGroup *)createAnonymousGroupWithSubject:(NSString *)subject
                                 description:(NSString *)description
                       initialWelcomeMessage:(NSString *)welcomeMessage
                                    nickname:(NSString *)nickname
                                styleSetting:(EMGroupStyleSetting *)styleSetting
                                       error:(EMError **)pError;

/*!
 @method
 @brief  创建匿名群组（异步方法）。函数执行完, 回调[group:didCreateWithError:]会被触发
 @param subject        群组名称
 @param description    群组描述
 @param welcomeMessage 群组欢迎语
 @param nickname        创建群组时群主的昵称(匿名聊天时的昵称)
 @param styleSetting   群组属性配置(groupStyle 必须为 eGroupStyle_PublicAnonymous, 目前只可以设置 maxUsersCount)
 */
- (void)asyncCreateAnonymousGroupWithSubject:(NSString *)subject
                                 description:(NSString *)description
                       initialWelcomeMessage:(NSString *)welcomeMessage
                                    nickname:(NSString *)nickname
                                styleSetting:(EMGroupStyleSetting *)styleSetting;

/*!
 @method
 @brief 创建群组（异步方法）。函数执行完, 会调用参数completion
 @param subject        群组名称
 @param description    群组描述
 @param welcomeMessage 群组欢迎语
 @param nickname        创建群组时群主的昵称(匿名聊天时的昵称)
 @param styleSetting   群组属性配置(groupStyle 必须为 eGroupStyle_PublicAnonymous, 目前只可以设置 maxUsersCount)
 @param completion      创建完成后的回调
 @param aQueue          回调block时的线程
 @discussion
 创建群组成功 判断条件：completion中，error == nil && group != nil
 */
- (void)asyncCreateAnonymousGroupWithSubject:(NSString *)subject
                                 description:(NSString *)description
                       initialWelcomeMessage:(NSString *)welcomeMessage
                                    nickname:(NSString *)nickname
                                styleSetting:(EMGroupStyleSetting *)styleSetting
                                  completion:(void (^)(EMGroup *group,
                                                       EMError *error))completion
                                     onQueue:(dispatch_queue_t)aQueue;

#pragma mark - join Anonymous public group, Founded in 2.0.9 version

/*!
 @method
 @brief 加入一个匿名公开群组
 @param groupId   公开群组的ID
 @param nickname  匿名群组中的昵称
 @param pError    错误信息
 @result 所加入的公开群组
 */
- (EMGroup *)joinAnonymousPublicGroup:(NSString *)groupId
                             nickname:(NSString *)nickname
                                error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 加入一个匿名公开群组
 @param groupId   公开群组的ID
 @param nickname  匿名群组中的昵称
 @discussion
 执行后, 回调didJoinPublicGroup:error:会被触发
 */
- (void)asyncJoinAnonymousPublicGroup:(NSString *)groupId
                             nickname:(NSString *)nickname;

/*!
 @method
 @brief 异步方法, 加入一个匿名公开群组
 @param groupId    公开群组的ID
 @param nickname   匿名群组中的昵称
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncJoinAnonymousPublicGroup:(NSString *)groupId
                             nickname:(NSString *)nickname
                           completion:(void (^)(EMGroup *group,
                                                EMError *error))completion
                              onQueue:(dispatch_queue_t)aQueue;

#pragma mark - leave group

/*!
 @method
 @brief 退出群组 (需要非owner的权限)
 @param groupId  群组ID
 @param pError   错误信息
 @result 退出的群组对象, 失败返回nil
 */
- (EMGroup *)leaveGroup:(NSString *)groupId
                  error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 退出群组(需要非owner的权限)
 @param groupId  群组ID
 @discussion
        函数执行完, 回调group:didLeave:error:会被触发
 */
- (void)asyncLeaveGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 退出群组(需要非owner的权限)
 @param groupId  群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncLeaveGroup:(NSString *)groupId
             completion:(void (^)(EMGroup *group,
                                  EMGroupLeaveReason reason,
                                  EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue;

#pragma mark - destroy group

/*!
 @method
 @brief 同步方法， 解散群组，需要owner权限
 @param groupId  群组ID
 @param pError   错误信息
 @result 退出的群组对象, 失败返回nil
 */
- (EMGroup *)destroyGroup:(NSString *)groupId
                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 解散群组，需要owner权限
 @param groupId  群组ID
 @discussion
 函数执行完, 回调group:didLeave:error:会被触发
 */
- (void)asyncDestroyGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 解散群组，需要owner权限
 @param groupId  群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncDestroyGroup:(NSString *)groupId
             completion:(void (^)(EMGroup *group,
                                  EMGroupLeaveReason reason,
                                  EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue;

#pragma mark - add occupants

/*!
 @method
 @brief 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @param pError         错误信息
 @result 返回群组对象, 失败返回空
 */
- (EMGroup *)addOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage
                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @discussion
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncAddOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage;

/*!
 @method
 @brief 异步方法, 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 */
- (void)asyncAddOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage
               completion:(void (^)(NSArray *occupants,
                                    EMGroup *group,
                                    NSString *welcomeMessage,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;

#pragma mark - remove occupants

/*!
 @method
 @brief 将某些人请出群组
 @param occupants 要请出群组的人的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限
 */
- (EMGroup *)removeOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId
                       error:(EMError *__autoreleasing *)pError;

/*!
 @method
 @brief 异步方法, 将某些人请出群组
 @param occupants 要请出群组的人的用户名列表
 @param groupId   群组ID
 @discussion
        此操作需要admin/owner权限.
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncRemoveOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人请出群组
 @param occupants  要请出群组的人的用户名列表
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
        此操作需要admin/owner权限
 */
- (void)asyncRemoveOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId
                  completion:(void (^)(EMGroup *group,
                                       EMError *error))completion
                     onQueue:(dispatch_queue_t)aQueue;

#pragma mark - block occupants

/*!
 @method
 @brief 将某些人加入群组黑名单
 @param occupants 要加入黑名单的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
 */
- (EMGroup *)blockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId
                      error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 将某些人加入群组黑名单
 @param occupants 要加入黑名单的用户名列表
 @param groupId   群组ID
 @discussion
        此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncBlockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人加入群组黑名单
 @param occupants   要加入黑名单的用户名列表
 @param groupId     群组ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
        此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
 */
- (void)asyncBlockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId
                 completion:(void (^)(EMGroup *group,
                                      EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - unblock occupants

/*!
 @method
 @brief 将某些人从群组黑名单中解除
 @param occupants 要从黑名单中移除的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
 */
- (EMGroup *)unblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId
                        error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 将某些人从群组黑名单中解除
 @param occupants 要从黑名单中移除的用户名列表
 @param groupId   群组ID
 @discussion
        此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncUnblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人从群组黑名单中解除
 @param occupants   要从黑名单中移除的用户名列表
 @param groupId     群组ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
        此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
 */
- (void)asyncUnblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId
                   completion:(void (^)(EMGroup *group,
                                        EMError *error))completion
                      onQueue:(dispatch_queue_t)aQueue;

#pragma mark - change group subject

/*!
 @method
 @brief 更改群组主题
 @param subject  主题
 @param groupId  群组ID
 @param pError   错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限
 */
- (EMGroup *)changeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId
                          error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 更改群组主题
 @param subject  主题
 @param groupId  群组ID
 @discussion
        此操作需要admin/owner权限
        函数执行完, groupDidUpdateInfo:error:回调会被触发
 */
- (void)asyncChangeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 更改群组主题
 @param subject    主题
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
        此操作需要admin/owner权限
 */
- (void)asyncChangeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId
                     completion:(void (^)(EMGroup *group,
                                          EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue;

#pragma mark - change group description

/*!
 @method
 @brief 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @param pError         错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限
 */
- (EMGroup *)changeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId
                         error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @discussion
        此操作需要admin/owner权限.
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncChangeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 @discussion
        此操作需要admin/owner权限
 */
- (void)asyncChangeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId
                    completion:(void (^)(EMGroup *group,
                                         EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;


#pragma mark - accept join group apply

/*!
 @method
 @brief 同意加入群组的申请
 @param groupId   所申请的群组ID
 @param groupname 申请的群组名称
 @param username  申请人的用户名
 @param pError    错误信息
 */
- (void)acceptApplyJoinGroup:(NSString *)groupId
                   groupname:(NSString *)groupname
                   applicant:(NSString *)username
                       error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 同意加入群组的申请
 @param groupId   所申请的群组ID
 @param groupname 申请的群组名称
 @param username  申请人的用户名
 @discussion
       函数执行后, didAcceptApplyJoinGroup:username:error:回调会被触发
 */
- (void)asyncAcceptApplyJoinGroup:(NSString *)groupId
                        groupname:(NSString *)groupname
                        applicant:(NSString *)username;

/*!
 @method
 @brief 异步方法, 同意加入群组的申请
 @param groupId    所申请的群组ID
 @param groupname  申请的群组名称
 @param username   申请人的用户名
 @param completion 消息完成后的回调
 @param aQueue     回调执行时的线程
 */
- (void)asyncAcceptApplyJoinGroup:(NSString *)groupId
                        groupname:(NSString *)groupname
                        applicant:(NSString *)username
                       completion:(void (^)(EMError *error))completion
                          onQueue:(dispatch_queue_t)aQueue;

#pragma mark - reject join group apply

/*!
 @method
 @brief 拒绝一个加入群组的申请
 @param groupId  被拒绝的群组ID
 @param username 被拒绝的人
 @param reason   拒绝理由
 */
- (void)rejectApplyJoinGroup:(NSString *)groupId
                   groupname:(NSString *)groupname
                 toApplicant:(NSString *)username
                      reason:(NSString *)reason;

#pragma mark - fetch group info

/*!
 @method
 @brief 获取群组详细信息（id，密码，主题，描述，实际总人数，在线人数，成员列表，属性）
 @param groupId 群组ID
 @param pError  错误信息
 @result 所获取的群组对象
 */
- (EMGroup *)fetchGroupInfo:(NSString *)groupId
                      error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组详细信息（id，密码，主题，描述，实际总人数，在线人数，成员列表，属性）
 @param groupId 群组ID
 @discussion
        执行后, 回调didFetchGroupInfo:error会被触发
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 获取群组详细信息（id，密码，主题，描述，实际总人数，在线人数，成员列表，属性）
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId
                 completion:(void (^)(EMGroup *group,
                                      EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief 同步方法, 获取群组成员列表
 @param groupId    群组ID
 @param pError     错误信息
 @return  群组的成员列表（包含创建者）
 */
- (NSArray *)fetchOccupantList:(NSString *)groupId error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组成员列表
 @param groupId    群组ID
 @discussion
 执行完成后，回调[didFetchGroupOccupantsList:error:]
 */
- (void)asyncFetchOccupantList:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 获取群组成员列表
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchOccupantList:(NSString *)groupId
                    completion:(void (^)(NSArray *occupantsList,EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief 同步方法, 获取群组信息
 @param groupId             群组ID
 @param includesOccupantList 是否获取成员列表
 @param pError              错误信息
 @return 群组
 */
- (EMGroup *)fetchGroupInfo:(NSString *)groupId
       includesOccupantList:(BOOL)includesOccupantList
                      error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组成员列表
 @param groupId             群组ID
 @param includesOccupantList 是否获取成员列表
 @discussion
 执行完成后，回调[didFetchGroupInfo:error:]
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId
       includesOccupantList:(BOOL)includesOccupantList;

/*!
 @method
 @brief 异步方法, 获取群组成员列表
 @param groupId             群组ID
 @param includesOccupantList 是否获取成员列表
 @param completion          消息完成后的回调
 @param aQueue              回调block时的线程
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId
        includesOccupantList:(BOOL)includesOccupantList
                 completion:(void (^)(EMGroup *group,EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - fetch group bans 
/*!
 @method
 @brief 同步方法, 获取群组黑名单列表
 @param groupId  群组ID
 @return         群组黑名单列表
 @discussion
        需要owner权限
 */
- (NSArray *)fetchGroupBansList:(NSString *)groupId error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组黑名单列表
 @param groupId  群组ID
 @discussion
        需要owner权限
        执行完成后，回调[didFetchGroupBans:list:error:]
 */
- (void)asyncFetchGroupBansList:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 获取群组黑名单列表
 @param groupId             群组ID
 @param completion          消息完成后的回调
 @param aQueue              回调block时的线程
 @discussion
        需要owner权限
 */
- (void)asyncFetchGroupBansList:(NSString *)groupId
                     completion:(void (^)(NSArray *groupBans,EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue;

#pragma mark - fetch my groups, Founded in 2.0.3 version

/**
 @brief  获取与我相关的群组列表（自己创建的，加入的）(同步方法)
 @param pError 获取错误信息
 @return 群组列表
 @discussion
        获取列表成功 判断条件：*pError == nil && returnArray != nil
 */
- (NSArray *)fetchMyGroupsListWithError:(EMError **)pError;

/*!
 @method
 @brief      获取与我相关的群组列表（自己创建的，加入的）(异步方法)
 @discussion    
        执行后, 回调[didUpdateGroupList:error]会被触发
 */
- (void)asyncFetchMyGroupsList;

/*!
 @method
 @brief 获取与我相关的群组列表（自己创建的，加入的）(异步方法)
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
        获取列表成功 判断条件：completion中，error == nil && groups != nil
 */
- (void)asyncFetchMyGroupsListWithCompletion:(void (^)(NSArray *groups,
                                                  EMError *error))completion
                                onQueue:(dispatch_queue_t)aQueue;

#pragma mark - fetch all public groups

/*!
 @method
 @brief 获取所有公开群组
 @param pError 错误信息
 @return 获取的所有群组列表
 */
- (NSArray *)fetchAllPublicGroupsWithError:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取所有公开群组
 @discussion
        执行后, 回调didFetchAllPublicGroups:error:会被触发
 */
- (void)asyncFetchAllPublicGroups;

/*!
 @method
 @brief 异步方法, 获取所有公开群组
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchAllPublicGroupsWithCompletion:(void (^)(NSArray *groups,
                                                          EMError *error))completion
                                        onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief 获取指定范围内的公开群
 @param cursor   获取公开群的cursor，首次调用传空即可
 @param pageSize 期望结果的数量, 如果 < 0 则一次返回所有结果
 @param pError   出错信息
 @return         获取的公开群结果
 @discussion
 这是一个阻塞方法，用户应当在一个独立线程中执行此方法，用户可以连续调用此方法以获得所有的公开群
 */
- (EMCursorResult *)fetchPublicGroupsFromServerWithCursor:(NSString *)cursor
                                                 pageSize:(NSInteger)pageSize
                                                 andError:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取指定范围的公开群
 @param cursor      获取公开群的cursor，首次调用传空即可
 @param pageSize    期望结果的数量, 如果 < 0 则一次返回所有结果
 @param completion  完成回调，回调会在主线程调用
 */
- (void)asyncFetchPublicGroupsFromServerWithCursor:(NSString *)cursor
                                     pageSize:(NSInteger)pageSize
                                andCompletion:(void (^)(EMCursorResult *result, EMError *error))completion;

#pragma mark - join public group

/*!
 @method
 @brief 加入一个公开群组
 @param groupId 公开群组的ID
 @param pError  错误信息
 @result 所加入的公开群组
 @discussion
        成功标志：*pError == nil;
 */
- (EMGroup *)joinPublicGroup:(NSString *)groupId error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 加入一个公开群组
 @param groupId 公开群组的ID
 @discussion
        执行后, 回调didJoinPublicGroup:error:会被触发
        成功标志：error == nil;
 */
- (void)asyncJoinPublicGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 加入一个公开群组
 @param groupId    公开群组的ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
        成功标志：error == nil;
 */
- (void)asyncJoinPublicGroup:(NSString *)groupId
                  completion:(void (^)(EMGroup *group,
                                       EMError *error))completion
                     onQueue:(dispatch_queue_t)aQueue;

#pragma mark - Apply to join public group, Founded in 2.0.3 version

/*!
 @method
 @brief 同步方法, 申请加入一个需授权的公开群组
 @param groupId             公开群组的ID
 @param groupName           请求加入的群组名称
 @param message             请求加入的信息
 @param pError              错误信息
 @result 所加入的公开群组
 */
- (EMGroup *)applyJoinPublicGroup:(NSString *)groupId
                    withGroupname:(NSString *)groupName
                          message:(NSString *)message
                            error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 申请加入一个需授权的公开群组
 @param groupId             公开群组的ID
 @param groupName           请求加入的群组名称
 @param message             请求加入的信息
 @discussion
        执行后, 回调didApplyJoinPublicGroup:error:会被触发
 */
- (void)asyncApplyJoinPublicGroup:(NSString *)groupId
                    withGroupname:(NSString *)groupName
                          message:(NSString *)message;

/*!
 @method
 @brief 异步方法, 申请加入一个需授权的公开群组
 @param groupId             公开群组的ID
 @param groupName           请求加入的群组名称
 @param message             请求加入的信息
 @param completion          消息完成后的回调
 @param aQueue              回调block时的线程
 */
- (void)asyncApplyJoinPublicGroup:(NSString *)groupId
                     withGroupname:(NSString *)groupName
                          message:(NSString *)message
                       completion:(void (^)(EMGroup *group,
                                            EMError *error))completion
                          onQueue:(dispatch_queue_t)aQueue;

#pragma mark - search public group, Founded in 2.0.3 version

/*!
 @method
 @brief  根据groupId搜索公开群(同步方法)
 @param groupId  群组id(完整id)
 @param pError   搜索失败的错误
 @return 搜索到的群组
 @discussion
        搜索群组成功 判断条件：*pError == nil && returnGroup != nil
 */
- (EMGroup *)searchPublicGroupWithGroupId:(NSString *)groupId
                                    error:(EMError **)pError;

/*!
 @method
 @brief  根据groupId搜索公开群(异步方法)
 @param groupId    公开群组的ID(完整id)
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
        搜索群组成功 判断条件：completion中，error == nil && group != nil
 */
- (void)asyncSearchPublicGroupWithGroupId:(NSString *)groupId
                               completion:(void (^)(EMGroup *group,
                                                    EMError *error))completion
                                  onQueue:(dispatch_queue_t)aQueue;

#pragma mark - block group

/*!
 @method
 @brief 屏蔽群消息，服务器不发送消息(不能屏蔽自己创建的群，EMErrorInvalidUsername)
 @param groupId   要屏蔽的群ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
 被屏蔽的群，服务器不再发消息
 */
- (EMGroup *)blockGroup:(NSString *)groupId
                  error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 屏蔽群消息，服务器不发送消息(不能屏蔽自己创建的群，EMErrorInvalidUsername)
 @param groupId     要取消屏蔽的群ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
 被屏蔽的群，服务器不再发消息
 */
- (void)asyncBlockGroup:(NSString *)groupId
             completion:(void (^)(EMGroup *group,
                                  EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue;

/*!
 @method
 @brief 取消屏蔽群消息(不能操作自己创建的群，EMErrorInvalidUsername)
 @param groupId   要取消屏蔽的群ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
 */
- (EMGroup *)unblockGroup:(NSString *)groupId
                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 取消屏蔽群消息(不能操作自己创建的群，EMErrorInvalidUsername)
 @param groupId     要取消屏蔽的群ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
 */
- (void)asyncUnblockGroup:(NSString *)groupId
               completion:(void (^)(EMGroup *group,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;

@optional

#pragma mark - EM_DEPRECATED_IOS

/*!
 @method
 @brief  从数据库获取与登陆者相关的群组
 @return 错误信息
 @discussion
 直接从数据库中获取,并不会返回相关回调方法;
 若希望返回相关回调方法,请使用loadAllMyGroupsFromDatabaseWithAppend2Chat:
 */
- (NSArray *)loadAllMyGroupsFromDatabase EM_DEPRECATED_IOS(2_1_0, 2_1_2, "Use - loadAllMyGroupsFromDatabaseWithAppend2Chat:");

#pragma mark - create private group, will be abolished

/*!
 @method
 @brief 创建一个私有群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @param pError         错误信息
 @result 创建的群组对象, 失败返回nil
 */
- (EMGroup *)createPrivateGroupWithSubject:(NSString *)subject
                               description:(NSString *)description
                                  invitees:(NSArray *)invitees
                     initialWelcomeMessage:(NSString *)welcomeMessage
                                     error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -createGroupWithSubject:description:invitees:initialWelcomeMessage:styleSetting:error:");

/*!
 @method
 @brief 异步方法, 创建一个私有群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @discussion
 函数执行完, 回调group:didCreateWithError:会被触发
 */
- (void)asyncCreatePrivateGroupWithSubject:(NSString *)subject
                               description:(NSString *)description
                                  invitees:(NSArray *)invitees
                     initialWelcomeMessage:(NSString *)welcomeMessage EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -asyncCreateGroupWithSubject:description:invitees:initialWelcomeMessage:styleSetting:");

/*!
 @method
 @brief 异步方法, 创建一个私有群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 */
- (void)asyncCreatePrivateGroupWithSubject:(NSString *)subject
                               description:(NSString *)description
                                  invitees:(NSArray *)invitees
                     initialWelcomeMessage:(NSString *)welcomeMessage
                                completion:(void (^)(EMGroup *group,
                                                     EMError *error))completion
                                   onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -asyncCreateGroupWithSubject:description:invitees:initialWelcomeMessage:styleSetting:completion:onQueue:");

#pragma mark - create public group, will be abolished

/*!
 @method
 @brief 创建一个公开群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @param pError         错误信息
 @result 创建的群组对象, 失败返回nil
 */
- (EMGroup *)createPublicGroupWithSubject:(NSString *)subject
                              description:(NSString *)description
                                 invitees:(NSArray *)invitees
                    initialWelcomeMessage:(NSString *)welcomeMessage
                                    error:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -createGroupWithSubject:description:invitees:initialWelcomeMessage:styleSetting:error:");

/*!
 @method
 @brief 异步方法, 创建一个公开群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @discussion
 函数执行完, 回调group:didCreateWithError:会被触发
 */
- (void)asyncCreatePublicGroupWithSubject:(NSString *)subject
                              description:(NSString *)description
                                 invitees:(NSArray *)invitees
                    initialWelcomeMessage:(NSString *)welcomeMessage EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -asyncCreateGroupWithSubject:description:invitees:initialWelcomeMessage:styleSetting:");

/*!
 @method
 @brief 异步方法, 创建一个公开群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 */
- (void)asyncCreatePublicGroupWithSubject:(NSString *)subject
                              description:(NSString *)description
                                 invitees:(NSArray *)invitees
                    initialWelcomeMessage:(NSString *)welcomeMessage
                               completion:(void (^)(EMGroup *group,
                                                    EMError *error))completion
                                  onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -asyncCreateGroupWithSubject:description:invitees:initialWelcomeMessage:styleSetting:completion:onQueue:");

#pragma mark - change group password, will be abolished

/*!
 @method
 @brief 更改群组密码
 @param newPassword 新密码
 @param groupId  群组ID
 @param pError      错误信息
 @result 返回群组对象
 @discussion
 此操作需要admin/owner权限
 */
- (EMGroup *)changePassword:(NSString *)newPassword
                   forGroup:(NSString *)groupId
                      error:(EMError **)pError EM_DEPRECATED_IOS(2_0_3, 2_0_9, "Delete");

/*!
 @method
 @brief 异步方法, 更改群组密码
 @param newPassword 新密码
 @param groupId     群组ID
 @discussion
 此操作需要admin/owner权限.
 函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncChangePassword:(NSString *)newPassword
                   forGroup:(NSString *)groupId EM_DEPRECATED_IOS(2_0_3, 2_0_9, "Delete");

/*!
 @method
 @brief 异步方法, 更改群组密码
 @param newPassword 新密码
 @param groupId     群组ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
 此操作需要admin/owner权限
 */
- (void)asyncChangePassword:(NSString *)newPassword
                   forGroup:(NSString *)groupId
                 completion:(void (^)(EMGroup *group, EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_3, 2_0_9, "Delete");

#pragma mark - change occupants' affiliation, will be abolished

/*!
 @method
 @brief 更改成员的权限级别
 @param newAffiliation 新的级别
 @param occupants      被更改成员的用户名列表
 @param groupId        群组ID
 @param pError         错误信息
 @result 返回群组对象
 @discussion
 此操作需要admin/owner权限
 */
- (EMGroup *)changeAffiliation:(EMGroupMemberRole)newAffiliation
                  forOccupants:(NSArray *)occupants
                       inGroup:(NSString *)groupId
                         error:(EMError **)pError EM_DEPRECATED_IOS(2_0_3, 2_0_9, "Delete");

/*!
 @method
 @brief 异步方法, 更改成员的权限级别
 @param newAffiliation 新的级别
 @param occupants      被更改成员的用户名列表
 @param groupId        群组ID
 @discussion
 此操作需要admin/owner权限.
 函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncChangeAffiliation:(EMGroupMemberRole)newAffiliation
                  forOccupants:(NSArray *)occupants
                       inGroup:(NSString *)groupId EM_DEPRECATED_IOS(2_0_3, 2_0_9, "Delete");

/*!
 @method
 @brief 异步方法, 更改成员的权限级别
 @param newAffiliation 新的级别
 @param occupants      被更改成员的用户名列表
 @param groupId        群组ID
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 @discussion
 此操作需要admin/owner权限
 */
- (void)asyncChangeAffiliation:(EMGroupMemberRole)newAffiliation
                  forOccupants:(NSArray *)occupants
                       inGroup:(NSString *)groupId
                    completion:(void (^)(EMGroup *group,
                                         EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_3, 2_0_9, "Delete");

#pragma mark - fetch my groups, will be abolished

/*!
 @method
 @brief 获取所有私有群组
 @param pError 错误信息
 @return 获取的所有私有群组列表
 */
- (NSArray *)fetchAllPrivateGroupsWithError:(EMError **)pError EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -fetchMyGroupsListWithError:");

/*!
 @method
 @brief 异步方法, 获取所有私有群组
 @discussion
 执行后, 回调didUpdateGroupList:error会被触发
 */
- (void)asyncFetchAllPrivateGroups EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -asyncMyGroupsList");

/*!
 @method
 @brief 异步方法, 获取所有私有群组
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchAllPrivateGroupsWithCompletion:(void (^)(NSArray *groups,
                                                           EMError *error))completion
                                         onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -asyncMyGroupsListWithCompletion:onQueue:");

#pragma mark - accept invitation, will be abolished

/*!
 @method
 @brief 接受并加入群组
 @param groupId 所接受的群组ID
 @param pError  错误信息
 @result 返回所加入的群组对象
 */
- (EMGroup *)acceptInvitationFromGroup:(NSString *)groupId
                                 error:(EMError **)pError EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

/*!
 @method
 @brief 异步方法, 接受并加入群组
 @param groupId 所接受的群组ID
 @discussion
        函数执行后, didAcceptInvitationFromGroup:error:回调会被触发
 */
- (void)asyncAcceptInvitationFromGroup:(NSString *)groupId EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

/*!
 @method
 @brief 异步方法, 接受并加入群组
 @param groupId    所接受的群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调执行时的线程
 */
- (void)asyncAcceptInvitationFromGroup:(NSString *)groupId
                            completion:(void (^)(EMGroup *group,
                                                 EMError *error))completion
                               onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

#pragma mark - reject invitation, will be abolished

/*!
 @method
 @brief 拒绝一个加入群组的邀请
 @param groupId  被拒绝的群组ID
 @param username 被拒绝的人
 @param reason   拒绝理由
 */
- (void)rejectInvitationForGroup:(NSString *)groupId
                       toInviter:(NSString *)username
                          reason:(NSString *)reason EM_DEPRECATED_IOS(2_0_3, 2_1_8, "Delete");

@end
