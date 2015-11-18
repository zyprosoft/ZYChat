/*!
 @header EMChatManagerUtilDelegate.h
 @abstract 此协议提供了一些群组操作的回调协议
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "EMChatManagerDelegateBase.h"

@class EMGroup;

/*!
 @protocol
 @brief 此协议提供了一些群组操作的回调
 @discussion
 */
@protocol EMChatManagerGroupDelegate <EMChatManagerDelegateBase>

@optional

/*!
 @method
 @brief 创建一个群组后的回调
 @param group 所创建的群组对象
 @param error 错误信息
 @discussion
 */
- (void)group:(EMGroup *)group didCreateWithError:(EMError *)error;

/*!
 @method
 @brief 离开一个群组后的回调
 @param group  所要离开的群组对象
 @param reason 离开的原因
 @param error  错误信息
 @discussion
        离开的原因包含主动退出, 被别人请出, 和销毁群组三种情况
 */
- (void)group:(EMGroup *)group
     didLeave:(EMGroupLeaveReason)reason
        error:(EMError *)error;

/*!
 @method
 @brief 群组信息更新后的回调
 @param group 发生更新的群组
 @param error 错误信息
 @discussion
        当添加/移除/更改角色/更改主题/更改群组信息之后,都会触发此回调
 */
- (void)groupDidUpdateInfo:(EMGroup *)group
                     error:(EMError *)error;

/*!
 @method
 @brief 收到了其它群组的加入邀请
 @param groupId  群组ID
 @param username 邀请人名称
 @param message  邀请信息
 @discussion
 */
- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message EM_DEPRECATED_IOS(2_0_0, 2_0_6, "Use -didAutoAcceptedGroupInvitationFrom:inviter:message:");

/*!
 @method
 @brief 收到了已自动加入某个群组的通知（你收到通知时已是该群成员）
 @param groupId  群组ID
 @param username 邀请人名称
 @param message  邀请信息
 @discussion
        主要发生 1、于创建群组时，被选为默认成员；2、isAutoAcceptGroupInvitation为YES
 */
- (void)didAutoAcceptedGroupInvitationFrom:(NSString *)groupId
                                   inviter:(NSString *)username
                                   message:(NSString *)message EM_DEPRECATED_IOS(2_0_6, 2_1_1, "didAcceptInvitationFromGroup:error:");

/*!
 @method
 @brief 接受群组邀请并加入群组后的回调
 @param group 所接受的群组
 @param error 错误信息
 */
- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error;

/*!
 @method
 @brief 收到了其它群组的加入邀请 + 发送邀人申请失败
 @param groupId  群组ID
 @param username 邀请人名称
 @param message  邀请信息
 @param error    错误信息
 @discussion
 */
- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
                                error:(EMError *)error;

/*!
 @method
 @brief 邀请别人加入群组, 但被别人拒绝后的回调
 @param groupId  群组ID
 @param username 拒绝的人的用户名
 @param reason   拒绝理由
 @discussion
 */
- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason EM_DEPRECATED_IOS(2_0_0, 2_0_6, "Use -didReceiveGroupRejectFrom:invitee:reason:error:");

/*!
 @method
 @brief 邀请别人加入群组, 但被别人拒绝后的回调 + 拒绝群组邀请发生错误
 @param groupId  群组ID
 @param username 拒绝的人的用户名
 @param reason   拒绝理由
 @param error    错误信息
 @discussion
 */
- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
                            error:(EMError *)error;

/*!
 @method
 @brief 收到加入群组的申请
 @param groupId         要加入的群组ID
 @param groupname       申请人的用户名
 @param username        申请人的昵称
 @param reason          申请理由
 @discussion
 */
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason EM_DEPRECATED_IOS(2_0_0, 2_0_6, "Use -didReceiveApplyToJoinGroup:groupname:applyUsername:reason:error:");

/*!
 @method
 @brief 收到加入群组的申请 + 申请入群发生错误
 @param groupId         要加入的群组ID
 @param groupname       申请人的用户名
 @param username        申请人的昵称
 @param reason          申请理由
 @param error           错误信息
 @discussion
 */
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error;

/*!
 @method
 @brief 申请加入群组，被拒绝后的回调
 @param fromId          拒绝的人的ID
 @param groupname       申请加入的群组名称
 @param reason          拒绝理由
 */
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason EM_DEPRECATED_IOS(2_0_0, 2_0_6, "Use -didReceiveRejectApplyToJoinGroupFrom:groupname:reason:error:");

/*!
 @method
 @brief 申请加入群组，被拒绝后的回调 + 群主拒绝入群申请发生错误
 @param fromId          拒绝的人的ID
 @param groupname       申请加入的群组名称
 @param reason          拒绝理由
 @param error           错误信息
 */
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
                                       error:(EMError *)error;

/*!
 @method
 @brief 申请加入群组，同意后的回调
 @param groupId         申请加入的群组的ID
 @param groupname       申请加入的群组名称
 */
- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname EM_DEPRECATED_IOS(2_0_0, 2_0_6, "Use -didReceiveAcceptApplyToJoinGroup:groupname:error:");

/*!
 @method
 @brief 用户申请加入群组，群主同意后，用户收到回调 + 用户申请入群，群主同意申请发生错误
 @param groupId         申请加入的群组的ID
 @param groupname       申请加入的群组名称
 @param error           错误信息
 */
- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
                                   error:(EMError *)error;

/*!
 @method
 @brief 同意入群申请后，同意者收到的回调
 @param groupId         申请加入的群组的ID
 @param username        申请加入的人的username
 @param error           错误信息
 */
- (void)didAcceptApplyJoinGroup:(NSString *)groupId
                       username:(NSString *)username
                          error:(EMError *)error;

/*!
 @method
 @brief 群组列表变化后的回调
 @param groupList 新的群组列表
 @param error     错误信息
 */
- (void)didUpdateGroupList:(NSArray *)groupList
                     error:(EMError *)error;

/*!
 @method
 @brief 获取所有公开群组后的回调
 @param groups 公开群组列表
 @param error  错误信息
 */
- (void)didFetchAllPublicGroups:(NSArray *)groups
                          error:(EMError *)error;

/*!
 @method
 @brief 获取群组信息后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didFetchGroupInfo:(EMGroup *)group
                    error:(EMError *)error;

/*!
 @method
 @brief 获取群组成员列表后的回调
 @param occupantsList 群组成员列表（包含创建者）
 @param error         错误信息
 */
- (void)didFetchGroupOccupantsList:(NSArray *)occupantsList
                             error:(EMError *)error;

/*!
 @method
 @brief 获取群组黑名单列表后的回调
 @param groupId  群组id
 @param bansList 群组黑名单列表
 @param error         错误信息
 */
- (void)didFetchGroupBans:(NSString *)groupId
                     list:(NSArray *)bansList
                    error:(EMError *)error;

/*!
 @method
 @brief 加入公开群组后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didJoinPublicGroup:(EMGroup *)group
                     error:(EMError *)error;

/*!
 @method
 @brief 申请加入公开群组后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didApplyJoinPublicGroup:(EMGroup *)group
                          error:(EMError *)error;

#pragma mark - Anonymous Group nickname

/*!
 @method
 @brief 删除App后, 重新join匿名群时, 获取不到 nickname, 需要app主动提供一个nickname, 如果未主动提供或返回nil, SDK会随机生成一个nickname(字母+数字)
 @param account 当前登录的用户
 @param groupId 用户所在的(匿名)群组id
 @result 用户在该群组中的昵称
 */
- (NSString *)nicknameForAccount:(NSString *)account
                         inGroup:(NSString *)groupId;

@end
