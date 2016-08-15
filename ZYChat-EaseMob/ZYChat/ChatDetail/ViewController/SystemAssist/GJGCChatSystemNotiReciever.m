//
//  GJGCChatSystemNotiReciever.m
//  ZYChat
//
//  Created by ZYVincent on 16/6/28.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCChatSystemNotiReciever.h"
#import "GJGCChatSystemNotiConstans.h"
#import "GJGCMessageExtendModel.h"
#import "GJGCChatSystemNotiDataManager.h"
#import "GJGCChatDetailDataSourceManager.h"
#import "GJGCMessageExtendGroupModel.h"
#import "GJGCGroupInfoExtendModel.h"
#import "Base64.h"

@interface GJGCChatSystemNotiReciever ()<EMContactManagerDelegate,EMGroupManagerDelegate>

@property (nonatomic,strong)EMConversation *conversation;

@end

@implementation GJGCChatSystemNotiReciever

+ (GJGCChatSystemNotiReciever*)shareReciever
{
    static GJGCChatSystemNotiReciever *_reciever = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reciever = [[self alloc]init];
    });
    return _reciever;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    }
    return self;
}

- (EMConversation *)systemAssistConversation
{
    if (self.conversation) {
        return self.conversation;
    }
    self.conversation = [[EMClient sharedClient].chatManager getConversation:SystemAssistConversationId type:EMConversationTypeChat createIfNotExist:YES];
    return self.conversation;
}

- (GJGCMessageExtendModel *)systemMessageExtendModel
{
    GJGCMessageExtendModel *extendModel = [[GJGCMessageExtendModel alloc]init];
    extendModel.isExtendMessageContent = NO;
    GJGCMessageExtendUserModel *userModel = [[GJGCMessageExtendUserModel alloc]init];
    userModel.nickName = @"聊天小助手";
    userModel.headThumb = @"http://img0.imgtn.bdimg.com/it/u=2382591939,624474057&fm=21&gp=0.jpg";
    userModel.sex = @"男";
    userModel.age = @"26";
    userModel.userName = SystemAssistConversationId;
    extendModel.userInfo = userModel;
    
    return extendModel;
}

- (void)insertSystemMessageInfo:(NSDictionary *)messageInfo
{
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc]initWithText:[messageInfo toJson]];
    GJGCMessageExtendModel *msgExtend = [self systemMessageExtendModel];
    EMMessage *aMessage = [[EMMessage alloc]initWithConversationID:SystemAssistConversationId  from:SystemAssistConversationId to:[EMClient sharedClient].currentUsername body:textBody ext:[msgExtend contentDictionary]];
    
    [[self systemAssistConversation]insertMessage:aMessage];
    
    [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    
    GJCFNotificationPostObjUserInfo(GJGCChatSystemNotiRecieverDidReiceveSystemNoti, nil, @{@"message":aMessage});
}

- (NSDictionary *)buildCommonUserInfoWithName:(NSString *)aUserName withMessage:(NSString *)message withAssistType:(GJGCChatSystemNotiAssistType)assitType withNotiType:(GJGCChatSystemFriendAssistNotiType)notiType withChatType:(EMConversationType)chatType acceptState:(GJGCChatSystemNotiAcceptState)acceptState
{
    NSDictionary *messageInfo = @{
                                  @"userId":aUserName,
                                  @"reason":message,
                                  @"message":message,
                                  @"username":aUserName,
                                  @"nickName":aUserName,
                                  @"birthday":@"1990-08-18",
                                  @"gender":@"男",
                                  @"avatar":@"http://imgsrc.baidu.com/forum/pic/item/9d82d158ccbf6c81f34d2e53bc3eb13533fa4016.jpg",
                                  @"notiType":[@(notiType) stringValue],
                                  @"chatType":[@(chatType) stringValue],
                                  @"acceptState":[@(acceptState) stringValue],
                                  @"assistType":[@(assitType) stringValue]
                                  };
    return messageInfo;
}

- (NSDictionary *)buildCommonGroupInfoWithName:(NSString *)aUserName withGroupName:(NSString *)groupName withMessage:(NSString *)message withAssistType:(GJGCChatSystemNotiAssistType)assitType withNotiType:(GJGCChatSystemGroupAssistNotiType)notiType withChatType:(EMConversationType)chatType acceptState:(GJGCChatSystemNotiAcceptState)acceptState withGroupExtendInf:(GJGCGroupInfoExtendModel *)groupInfo withGroupId:(NSString *)groupId
{
    NSDictionary *messageInfo = @{
                                  @"userId":aUserName,
                                  @"reason":message,
                                  @"message":message,
                                  @"username":aUserName,
                                  @"nickName":aUserName,
                                  @"birthday":@"1990-08-18",
                                  @"gender":@"男",
                                  @"avatar":@"http://imgsrc.baidu.com/forum/pic/item/9d82d158ccbf6c81f34d2e53bc3eb13533fa4016.jpg",
                                  @"notiType":[@(notiType) stringValue],
                                  @"chatType":[@(chatType) stringValue],
                                  @"acceptState":[@(acceptState) stringValue],
                                  @"assistType":[@(assitType) stringValue],
                                  @"groupAvatar":@"",
                                  @"name":groupName,
                                  @"level":@"3",
                                  @"maxCount":@"200",
                                  @"currentCount":@"30",
                                  @"groupId":groupId
                                  };
    return messageInfo;
}

#pragma mark - 联系人相关通知

/*!
 *  \~chinese
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after user B agreed user A's add-friend invitation
 *
 *  @param aUsername   User B
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    NSDictionary *messageInfo = [self buildCommonUserInfoWithName:aUsername
                                                      withMessage:[NSString stringWithFormat:@"用户#%@#已通过了你的好友申请",aUsername]
                                                   withAssistType:GJGCChatSystemNotiAssistTypeNormal
                                                     withNotiType:GJGCChatSystemFriendAssistNotiTypeApply withChatType:EMConversationTypeChat
                                                      acceptState:GJGCChatSystemNotiAcceptStatePrepare];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after user B declined user A's add-friend invitation
 *
 *  @param aUsername   User B
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    NSDictionary *messageInfo = [self buildCommonUserInfoWithName:aUsername
                                                      withMessage:[NSString stringWithFormat:@"用户#%@#拒绝了你的好友申请",aUsername]
                                                   withAssistType:GJGCChatSystemNotiAssistTypeNormal
                                                     withNotiType:GJGCChatSystemFriendAssistNotiTypeApply withChatType:EMConversationTypeChat
                                                      acceptState:GJGCChatSystemNotiAcceptStatePrepare];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  用户B删除与用户A的好友关系后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after User B delete the friend relationship between user A
 *
 *  @param aUsername   User B
 */
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername
{
    NSDictionary *messageInfo = [self buildCommonUserInfoWithName:aUsername
                                                      withMessage:[NSString stringWithFormat:@"用户#%@#已解除和你的好友关系",aUsername]
                                                   withAssistType:GJGCChatSystemNotiAssistTypeNormal
                                                     withNotiType:GJGCChatSystemFriendAssistNotiTypeApply withChatType:EMConversationTypeChat
                                                      acceptState:GJGCChatSystemNotiAcceptStatePrepare];
    
    [self insertSystemMessageInfo:messageInfo];
    
    [GJGCChatDetailDataSourceManager createRemindTipMessage:[NSString stringWithFormat:@"你和%@已解除好友关系",aUsername] conversationType:EMConversationTypeChat withConversationId:aUsername];
}

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 *
 *  \~english
 *  Both user A and B will receive this callback after User B agreed user A's add-friend invitation
 *
 *  @param aUsername   Another user of user‘s friend relationship
 */
- (void)didReceiveAddedFromUsername:(NSString *)aUsername
{
    [GJGCChatDetailDataSourceManager createRemindTipMessage:[NSString stringWithFormat:@"你和%@已成为好友",aUsername] conversationType:EMConversationTypeChat withConversationId:aUsername];
}

/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 *
 *  \~english
 *  User A will receive this callback after user B requested to add user A as a friend
 *
 *  @param aUsername   User B
 *  @param aMessage    Friend invitation message
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{

    NSDictionary *messageInfo = [self buildCommonUserInfoWithName:aUsername
                                                      withMessage:aMessage
                                                   withAssistType:GJGCChatSystemNotiAssistTypeFriend
                                                     withNotiType:GJGCChatSystemFriendAssistNotiTypeApply withChatType:EMConversationTypeChat
                                                      acceptState:GJGCChatSystemNotiAcceptStatePrepare];
    
    [self insertSystemMessageInfo:messageInfo];
}

#pragma mark - 群相关通知

/*!
 *  \~chinese
 *  用户A邀请用户B入群,用户B接收到该回调
 *
 *  @param aGroupId    群组ID
 *  @param aInviter    邀请者
 *  @param aMessage    邀请信息
 *
 *  \~english
 *  After user A invites user B into the group, user B will receive this callback
 *
 *  @param aGroupId    The group ID
 *  @param aInviter    Inviter
 *  @param aMessage    Invite message
 */
- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage
{
    NSDictionary *messageInfo = [self buildCommonGroupInfoWithName:@""
                                                     withGroupName:aGroupId
                                                      withMessage:aMessage
                                                   withAssistType:GJGCChatSystemNotiAssistTypeGroup
                                                     withNotiType:GJGCChatSystemGroupAssistNotiTypeInviteJoinGroup
                                                      withChatType:EMConversationTypeGroupChat
                                                      acceptState:GJGCChatSystemNotiAcceptStatePrepare
                                                      withGroupExtendInf:nil
                                                       withGroupId:aGroupId
                                 ];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  用户B同意用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组实例
 *  @param aInvitee  被邀请者
 *
 *  \~english
 *  After user B accepted user A‘s group invitation, user A will receive this callback
 *
 *  @param aGroup    User joined group
 *  @param aInvitee  Invitee
 */
- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
{
    NSData *extendData = [aGroup.subject base64DecodedData];
    NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
    
    GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
    
    NSDictionary *messageInfo = [self buildCommonGroupInfoWithName:@""
                                                     withGroupName:groupInfoExtend.name
                                                      withMessage:aInvitee
                                                   withAssistType:GJGCChatSystemNotiAssistTypeGroup
                                                     withNotiType:GJGCChatSystemGroupAssistNotiTypeAcceptInviteJoinGroup
                                                      withChatType:EMConversationTypeGroupChat
                                                      acceptState:GJGCChatSystemNotiAcceptStateFinish
                                                      withGroupExtendInf:groupInfoExtend
                                                       withGroupId:aGroup.groupId
                                 ];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  用户B拒绝用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组
 *  @param aInvitee  被邀请者
 *  @param aReason   拒绝理由
 *
 *  \~english
 *  After user B declined user A's group invitation, user A will receive the callback
 *
 *  @param aGroup    Group instance
 *  @param aInvitee  Invitee
 *  @param aReason   Decline reason
 */
- (void)didReceiveDeclinedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
                                   reason:(NSString *)aReason
{
    NSData *extendData = [aGroup.subject base64DecodedData];
    NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
    
    GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
    
    NSDictionary *messageInfo = [self buildCommonGroupInfoWithName:@""
                                                     withGroupName:groupInfoExtend.name
                                                      withMessage:aInvitee
                                                   withAssistType:GJGCChatSystemNotiAssistTypeGroup
                                                     withNotiType:GJGCChatSystemGroupAssistNotiTypeRejectJoinGroup
                                                      withChatType:EMConversationTypeGroupChat
                                                      acceptState:GJGCChatSystemNotiAcceptStateReject
                                                      withGroupExtendInf:groupInfoExtend
                                                       withGroupId:aGroup.groupId
                                 ];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
 *
 *  @param aGroup    群组实例
 *  @param aInviter  邀请者
 *  @param aMessage  邀请消息
 *
 *  \~english
 *  User B will receive this callback after SDK automatically accept user A's group invitation, need set EMOptions's isAutoAcceptGroupInvitation property to YES
 *
 *  @param aGroup    Group
 *  @param aInviter  Inviter
 *  @param aMessage  Invite message
 */
- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage
{
    NSData *extendData = [aGroup.subject base64DecodedData];
    NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
    
    GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
    
    NSDictionary *messageInfo = [self buildCommonGroupInfoWithName:@""
                                                     withGroupName:groupInfoExtend.name
                                                      withMessage:aMessage
                                                   withAssistType:GJGCChatSystemNotiAssistTypeGroup
                                                     withNotiType:GJGCChatSystemGroupAssistNotiTypeAcceptInviteJoinGroup
                                                      withChatType:EMConversationTypeGroupChat
                                                      acceptState:GJGCChatSystemNotiAcceptStateFinish
                                                      withGroupExtendInf:groupInfoExtend
                                                       withGroupId:aGroup.groupId
                                 ];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  离开群组回调
 *
 *  @param aGroup    群组实例
 *  @param aReason   离开原因
 *
 *  \~english
 *  Callback of leave group
 *
 *  @param aGroup    Group instance
 *  @param aReason   Leave reason
 */
- (void)didReceiveLeavedGroup:(EMGroup *)aGroup
                       reason:(EMGroupLeaveReason)aReason
{
    NSData *extendData = [aGroup.subject base64DecodedData];
    NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
    
    GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
    
    NSDictionary *reasonMap = @{
                                @(EMGroupLeaveReasonBeRemoved):@"被管理员移除出群",
                                @(EMGroupLeaveReasonUserLeave):@"已退出群组",
                                @(EMGroupLeaveReasonDestroyed):@"群组已解散",
                                };
    NSDictionary *notiTypeMap = @{
                                  @(EMGroupLeaveReasonBeRemoved):@(GJGCChatSystemGroupAssistNotiTypeDeleteMemeberByGroupAdmin),
                                  @(EMGroupLeaveReasonUserLeave):@(GJGCChatSystemGroupAssistNotiTypeMemeberExitGroup),
                                  @(EMGroupLeaveReasonDestroyed):@(GJGCChatSystemGroupAssistNotiTypeDeleteGroup),
                                  };
    
    NSDictionary *messageInfo = [self buildCommonGroupInfoWithName:@""
                                                     withGroupName:groupInfoExtend.name
                                                       withMessage:reasonMap[@(aReason)]
                                                    withAssistType:GJGCChatSystemNotiAssistTypeGroup
                                                      withNotiType:[notiTypeMap[@(aReason)] integerValue]
                                                      withChatType:EMConversationTypeGroupChat
                                                       acceptState:GJGCChatSystemNotiAcceptStateReject
                                                      withGroupExtendInf:groupInfoExtend
                                                       withGroupId:aGroup.groupId
                                 ];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  群组的群主收到用户的入群申请，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     群组实例
 *  @param aApplicant 申请者
 *  @param aReason    申请者的附属信息
 *
 *  \~english
 *  Group's owner receive user's applicaton of joining group, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     Group
 *  @param aApplicant The applicant
 *  @param aReason    The applicant's message
 */
- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason
{
    NSData *extendData = [aGroup.subject base64DecodedData];
    NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
    
    GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
    
    NSDictionary *messageInfo = [self buildCommonGroupInfoWithName:aApplicant
                                                     withGroupName:groupInfoExtend.name
                                                       withMessage:aReason
                                                    withAssistType:GJGCChatSystemNotiAssistTypeGroup
                                                      withNotiType:GJGCChatSystemGroupAssistNotiTypeApplyJoinGroup
                                                      withChatType:EMConversationTypeGroupChat
                                                       acceptState:GJGCChatSystemNotiAcceptStatePrepare
                                                withGroupExtendInf:groupInfoExtend
                                                       withGroupId:aGroup.groupId
                                 ];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  群主拒绝用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    群组ID
 *  @param aReason     拒绝理由
 *
 *  \~english
 *  User A will receive this callback after group's owner declined it's application, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    Group id
 *  @param aReason     Decline reason
 */
- (void)didReceiveDeclinedJoinGroup:(NSString *)aGroupId
                             reason:(NSString *)aReason
{
    NSDictionary *messageInfo = [self buildCommonGroupInfoWithName:@""
                                                     withGroupName:aGroupId
                                                       withMessage:aReason
                                                    withAssistType:GJGCChatSystemNotiAssistTypeGroup
                                                      withNotiType:GJGCChatSystemGroupAssistNotiTypeRejectJoinGroup
                                                      withChatType:EMConversationTypeGroupChat
                                                       acceptState:GJGCChatSystemNotiAcceptStateReject
                                                      withGroupExtendInf:nil
                                                       withGroupId:aGroupId
                                ];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  群主同意用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   通过申请的群组
 *
 *  \~english
 *  User A will receive this callback after group's owner accepted it's application, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   Group instance
 */
- (void)didReceiveAcceptedJoinGroup:(EMGroup *)aGroup
{
    NSData *extendData = [aGroup.subject base64DecodedData];
    NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
    
    GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
    
    NSDictionary *messageInfo = [self buildCommonGroupInfoWithName:@""
                                                     withGroupName:groupInfoExtend.name
                                                       withMessage:@"已通过申请"
                                                    withAssistType:GJGCChatSystemNotiAssistTypeGroup
                                                      withNotiType:GJGCChatSystemGroupAssistNotiTypeAcceptInviteJoinGroup
                                                      withChatType:EMConversationTypeGroupChat
                                                       acceptState:GJGCChatSystemNotiAcceptStateReject
                                                    withGroupExtendInf:groupInfoExtend
                                                       withGroupId:aGroup.groupId
                                 ];
    
    [self insertSystemMessageInfo:messageInfo];
}

/*!
 *  \~chinese
 *  群组列表发生变化
 *
 *  @param aGroupList  群组列表<EMGroup>
 *
 *  \~english
 *  Group List changed
 *
 *  @param aGroupList  Group list<EMGroup>
 */
- (void)didUpdateGroupList:(NSArray *)aGroupList
{
    
}

@end
