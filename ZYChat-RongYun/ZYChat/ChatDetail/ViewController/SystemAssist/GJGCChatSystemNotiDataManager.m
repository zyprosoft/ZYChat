//
//  GJGCSystemNotiDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-11.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatSystemNotiDataManager.h"

@interface GJGCChatSystemNotiDataManager ()

@property (nonatomic,assign)NSInteger pageIndex;

@property (nonatomic,assign)BOOL isFinishLoadDataBaseMsg;

@end

@implementation GJGCChatSystemNotiDataManager

- (instancetype)initWithTalk:(GJGCChatFriendTalkModel *)talk withDelegate:(id<GJGCChatDetailDataSourceManagerDelegate>)aDelegate
{
    if (self = [super initWithTalk:talk withDelegate:aDelegate]) {
        
        self.title = @"系统助手";
        
        self.pageIndex = 0;
        
        [self readLastMessagesFromDB];
        
    }
    return self;
}

#pragma mark - 读取所有好友助手消息

- (void)readLastMessagesFromDB
{
    //读取最近20条消息
    
    /* 设置加载完后第一条消息和最后一条消息 */
    [self resetFirstAndLastMsgId];
}

#pragma mark - 观察好友助手消息
- (void)observeSystemNotiMessage:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        GJGCChatFriendTalkModel *talkModel = (GJGCChatFriendTalkModel *)noti.userInfo[@"data"];
        
        if (talkModel.talkType != GJGCChatFriendTalkSystemAssist) {
            return;
        }
        
        
        [self requireListUpdate];

    });
}

- (void)observeHistoryMessage:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self recieveHistoryMessage:noti];
        
    });
}

- (void)recieveHistoryMessage:(NSNotification *)noti
{
    /* 是否当前会话的历史消息 */
    
    /* 悬停在第一次加载后的第一条消息上 */
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireFinishRefresh:)]) {
        
        [self.delegate dataSourceManagerRequireFinishRefresh:self];
    }
    
    /* 如果没有历史消息了 */
    self.isFinishLoadAllHistoryMsg = YES;

}

- (void)pushAddMoreMsg:(NSArray *)array
{
    //添加系统消息
    
    /* 重排时间顺序 */
    [self resortAllSystemNotiContentBySendTime];
    
    /* 上一次悬停的第一个cell的索引 */
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireFinishRefresh:)]) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.delegate dataSourceManagerRequireFinishRefresh:weakSelf];
        });
    }
}

#pragma mark - 添加普通系统消息

- (void)addNormalSystemModel
{
    GJGCChatSystemNotiModel *notiModel = [[GJGCChatSystemNotiModel alloc]init];
    notiModel.assistType = GJGCChatSystemNotiAssistTypeNormal;
    notiModel.baseMessageType = GJGCChatBaseMessageTypeSystemNoti;
    notiModel.talkType = GJGCChatFriendTalkSystemAssist;
    notiModel.toId = @"88888";
    notiModel.contentHeight = 0.f;
    notiModel.sessionId = @"88888";
    
    notiModel.sendTime = [[NSDate date]timeIntervalSince1970];
    notiModel.timeString = [GJGCChatSystemNotiCellStyle formateSystemNotiTime:notiModel.sendTime];
    
    notiModel.notiType = GJGCChatSystemNotiTypeSystemOperationState;
    
    notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:@"普通系统消息"];
    
    [self addChatContentModel:notiModel];
}

#pragma mark - 添加好友助手消息

- (void)addFriendModel
{
    GJGCChatSystemNotiModel *notiModel = [[GJGCChatSystemNotiModel alloc]init];
    notiModel.assistType = GJGCChatSystemNotiAssistTypeFriend;
    notiModel.isUserContent = YES;
    notiModel.baseMessageType = GJGCChatBaseMessageTypeSystemNoti;
    notiModel.talkType = GJGCChatFriendTalkSystemAssist;
    notiModel.toId = @"88888";
    notiModel.contentHeight = 0.f;
    notiModel.sessionId = @"88888";

    NSString *applyTip = [NSString stringWithFormat:@"%@申请添加您为好友",@"lily"];
    
    GJGCChatSystemNotiAcceptState acceptState = GJGCChatSystemNotiAcceptStateApplying;
    
    
    GJGCChatSystemFriendAssistNotiType notiType = GJGCChatSystemFriendAssistNotiTypeAccept;
    /* 格式成数据源 */
    switch (notiType) {
        case GJGCChatSystemFriendAssistNotiTypeApply:
        {
            if (acceptState == GJGCChatSystemNotiAcceptStatePrepare) {
                
                notiModel.notiType = GJGCChatSystemNotiTypeOtherPersonApplyMyAuthoriz;
                notiModel.applyTip = [GJGCChatSystemNotiCellStyle formateApplyTip:applyTip];
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"你狠漂亮"];
                
                break;
            }
            
            notiModel.notiType = GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState;
            notiModel.applyTip = [GJGCChatSystemNotiCellStyle formateApplyTip:applyTip];
            
            if (acceptState == GJGCChatSystemNotiAcceptStateFinish) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已通过"];
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateReject) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已拒绝"];
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateYouHaveBePullBlack) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已被对方拉黑"];
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateHaveBePullBlackByYourself) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已被您拉黑"];
                
            }
            
        }
            break;
        case GJGCChatSystemFriendAssistNotiTypeAccept:
        {
            
            
        }
            break;
        case GJGCChatSystemFriendAssistNotiTypeReject:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeSystemOperationState;
            NSString *tip = [NSString stringWithFormat:@"用户%@拒绝了您的好友申请！",@"Tom"];
            notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:tip];
        }
            break;
        default:
            break;
    }
    
    notiModel.sendTime = [[NSDate date]timeIntervalSince1970];
    notiModel.timeString = [GJGCChatSystemNotiCellStyle formateSystemNotiTime:notiModel.sendTime];
    
    notiModel.userSex = @"1";
    notiModel.userId = 44444;
    
    NSDate *birthDate = GJCFDateFromString(@"1990-08-18");
    
    NSString *ageString = GJCFDateBirthDayToAge(birthDate);
    NSString *age = nil;
    if (![ageString hasSuffix:@"岁"]) {
        age = @"0";
    }else{
        age = [ageString stringByReplacingOccurrencesOfString:@"岁" withString:@""];
    }
    
    if ([notiModel.userSex intValue]) {
        
        notiModel.userAge = [GJGCChatSystemNotiCellStyle formateManAge:age];
    }else{
        
        notiModel.userAge = [GJGCChatSystemNotiCellStyle formateWomenAge:age];
    }
    
    notiModel.userStarName = [GJGCChatSystemNotiCellStyle formateStarName:GJCFDateToConstellation(birthDate)];
    
    notiModel.headUrl = @"";
    
    notiModel.name = [GJGCChatSystemNotiCellStyle formateNameString:@"Jim"];
    
    [self addChatContentModel:notiModel];
}

#pragma mark - 添加template推荐的消息

- (void)addTemplateModel
{
    /**
     *  请求参数，需要传入下一个界面
     */
    NSString *url = @"";
    
    // card题目
    NSString *title = @"活动引导标题";
    
    // 简介
    NSString *desc = @"活动简介";
    // 图片
    NSString *pic = @"";
    
    // 1 是推荐消息   2是H5页面消息 也许未来还会有更多，需要看wiki
    NSInteger type = 1;
    
    NSString *buttonTitle = @"立即参与";
    
    GJGCChatSystemNotiModel *notiModel = [[GJGCChatSystemNotiModel alloc] init];
    
    /* 如果没有按钮，那么就不显示按钮，并且可以卡片高亮 */
    if (GJCFStringIsNull(buttonTitle)) {
        notiModel.canShowHighlightState = YES;
    }
    
    notiModel.assistType = GJGCChatSystemNotiAssistTypeTemplate;
    notiModel.baseMessageType = GJGCChatBaseMessageTypeSystemNoti;
    notiModel.notiType = GJGCChatSystemNotiTypeSystemActiveGuide;
    notiModel.contentHeight = 0.f;
    notiModel.sessionId = @"888888";

    notiModel.systemActiveImageUrl = pic;
    notiModel.systemNotiTitle = [GJGCChatSystemNotiCellStyle formateNameString:title];
    notiModel.systemJumpUrl = url;
    notiModel.systemJumpType = type;
    notiModel.systemGuideButtonTitle = [GJGCChatSystemNotiCellStyle formateButtonTitle:buttonTitle];
    notiModel.talkType = GJGCChatFriendTalkSystemAssist;
    notiModel.toId = @"888888";
    notiModel.sendTime = [[NSDate date]timeIntervalSince1970];
    notiModel.timeString = [GJGCChatSystemNotiCellStyle formateSystemNotiTime:notiModel.sendTime];
    
    notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateActiveDescription:desc];
    
    [self addChatContentModel:notiModel];
}

- (void)addGroupNotiModel
{
    GJGCChatSystemNotiModel *notiModel = [[GJGCChatSystemNotiModel alloc]init];
    notiModel.assistType = GJGCChatSystemNotiAssistTypeGroup;
    notiModel.baseMessageType = GJGCChatBaseMessageTypeSystemNoti;
    notiModel.talkType = GJGCChatFriendTalkSystemAssist;
    notiModel.toId = @"888888";
    notiModel.contentHeight = 0.f;
    notiModel.sessionId = @"888888";
    
    notiModel.sendTime = [[NSDate date]timeIntervalSince1970];
    notiModel.timeString = [GJGCChatSystemNotiCellStyle formateSystemNotiTime:notiModel.sendTime];
    
    /* 群组基础信息 */
    notiModel.groupId = 999999;
    
    /* 用户基础信息 */
    notiModel.userId = 8888888;
    
    BOOL isMyNoti = notiModel.userId == 444444;
    
    NSString *formateTip = @"文案";
    
    GJGCChatSystemNotiAcceptState acceptState = GJGCChatSystemNotiAcceptStateApplying;

    GJGCChatSystemGroupAssistNotiType notiType = GJGCChatSystemGroupAssistNotiTypeApplyJoinGroup;
    notiModel.groupAssistNotiType = notiType;
    
    NSDictionary *userInfo = @{
                               @"groupAvatar":@"",
                               @"name":@"",
                               @"level":@"",
                               @"maxCount":@"",
                               @"currentCount":@"",
                               };
    /* 格式成数据源 */
    switch (notiType) {
        case GJGCChatSystemGroupAssistNotiTypeCreateGroupAccept:
        {
            [self setNotiModelGroupContent:notiModel withUserInfo:userInfo];
            
            notiModel.notiType = GJGCChatSystemNotiTypeInviteFriendJoinGroup;
            notiModel.groupOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:formateTip];
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeCreateGroupReject:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeSystemOperationState;
            notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:formateTip];
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeUpdateGroupInfoAccept:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeSystemOperationState;
            notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:formateTip];
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeUpdateGroupInfoReject:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeSystemOperationState;
            notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:formateTip];
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeApplyJoinGroup:
        {
            [self setNotiModelUserContent:notiModel withUserInfo:userInfo];
            
            if (acceptState == GJGCChatSystemNotiAcceptStatePrepare) {
                
                notiModel.notiType = GJGCChatSystemNotiTypeOtherGroupApply;
                notiModel.applyTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:[userInfo objectForKey:@"reason"]];
                
                break;
            }

            notiModel.notiType = GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState;
            notiModel.applyTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
            
            if (acceptState == GJGCChatSystemNotiAcceptStateFinish) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已通过"];
                
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateReject) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已拒绝"];
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateOtherAdminAccept) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"其他管理员已通过"];
                
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateOtherAdminRject) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"其他管理员已拒绝"];
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateTimeOut) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已过期"];
                
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateGroupHasBeenDelete) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"该群已解散"];
                
            }
            
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeInviteJoinGroup:
        {
            [self setNotiModelGroupContent:notiModel withUserInfo:userInfo];
            
            if (acceptState == GJGCChatSystemNotiAcceptStatePrepare) {
                
                notiModel.notiType = GJGCChatSystemNotiTypeOtherGroupApply;
                notiModel.applyTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
                
                break;
            }
            
            notiModel.notiType = GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState;
            notiModel.applyTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
            
            if (acceptState == GJGCChatSystemNotiAcceptStateFinish) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已同意"];
                
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateApplying) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"申请中"];

            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateReject) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已拒绝"];
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateOtherAdminAccept) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"其他管理员已通过"];
                
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateOtherAdminRject) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"其他管理员已拒绝"];
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateTimeOut) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已过期"];
                
            }
            
            if (acceptState == GJGCChatSystemNotiAcceptStateGroupHasBeenDelete) {
                
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"该群已解散"];
                
            }
            
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeRejectJoinGroup:
        {
            if (isMyNoti) {
                
                notiModel.notiType = GJGCChatSystemNotiTypeSystemOperationState;
                notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:formateTip];
                
                [self setNotiModelGroupContent:notiModel withUserInfo:userInfo];
                
            }else{
                
                [self setNotiModelUserContent:notiModel withUserInfo:userInfo];
                
                notiModel.notiType = GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState;
                notiModel.applyTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
                notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyTip:@"已拒绝"];
            }
            
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeAcceptJoinGroup:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState;
            notiModel.applyTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
            notiModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已通过"];
            
            if (isMyNoti) {
                
                [self setNotiModelGroupContent:notiModel withUserInfo:userInfo];
                
            }else{
                
                [self setNotiModelUserContent:notiModel withUserInfo:userInfo];
            }
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeAcceptInviteJoinGroup:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState;
            notiModel.groupOperationTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeAddGroupAdmin:
        {
            if (isMyNoti) {
                
                [self setNotiModelGroupContent:notiModel withUserInfo:userInfo];
                
                notiModel.notiType = GJGCChatSystemNotiTypeGroupOperationState;
                notiModel.groupOperationTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
                
            }
            
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeDeleteGroupAdmin:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeGroupOperationState;
            notiModel.groupOperationTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
            
            if (isMyNoti) {
                
                [self setNotiModelGroupContent:notiModel withUserInfo:userInfo];
            }
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeDeleteGroup:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeSystemOperationState;
            notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:formateTip];
            
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeDeleteMemeberByGroupAdmin:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeSystemOperationState;
            notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:formateTip];
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeMemeberExitGroup:
        {
            notiModel.notiType = GJGCChatSystemNotiTypeGroupOperationState;
            notiModel.groupOperationTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
        }
            break;
            
        case GJGCChatSystemGroupAssistNotiTypeRequestBeGroupOwner:
        {
            /**
             *  请求参数，需要传入下一个界面
             */
            NSString *url = userInfo[@"url"];
            
            // card题目
            NSString *title = userInfo[@"title"];
            
            // 简介
            NSString *desc = userInfo[@"desc"];
            
            // 图片
            NSString *pic = userInfo[@"pic"];
            
            // 1 是推荐消息   2是H5页面消息 也许未来还会有更多，需要看wiki
            NSInteger type = [userInfo[@"type"] integerValue];
            
            notiModel.assistType = GJGCChatSystemNotiAssistTypeTemplate;
            notiModel.notiType = GJGCChatSystemNotiTypeSystemActiveGuide;
            notiModel.systemActiveImageUrl = pic;
            notiModel.systemNotiTitle = [GJGCChatSystemNotiCellStyle formateNameString:title];
            notiModel.systemJumpUrl = url;
            notiModel.systemJumpType = type;
            notiModel.systemOperationTip = [GJGCChatSystemNotiCellStyle formateApplyTip:desc];

        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeRequestBeGroupOwnerSuccess:
        {
            [self setNotiModelGroupContent:notiModel withUserInfo:userInfo];
            notiModel.notiType = GJGCChatSystemNotiTypeGroupOperationState;
            notiModel.groupOperationTip = [GJGCChatSystemNotiCellStyle formateApplyTip:formateTip];
            
        }
            break;
        case GJGCChatSystemGroupAssistNotiTypeBeCancelGroupOwner:
        {
            [self setNotiModelGroupContent:notiModel withUserInfo:userInfo];
            notiModel.notiType = GJGCChatSystemNotiTypeGroupOperationState;
            notiModel.groupOperationTip = [GJGCChatSystemNotiCellStyle formateBaseContent:formateTip];
        }
            break;
            
        default:
            break;
    }
    
    [self addChatContentModel:notiModel];
}

- (void)setNotiModelUserContent:(GJGCChatSystemNotiModel *)notiModel withUserInfo:(NSDictionary *)userInfo
{
    /* 个人信息 */
    NSString *toUserName = [userInfo objectForKey:@"nickName"];
    NSString *birthday = [userInfo objectForKey:@"birthday"];
    NSString *gender = [userInfo objectForKey:@"gender"];
    NSString *toUserAvatar = [userInfo objectForKey:@"avatar"];
    
    notiModel.isUserContent = YES;
    notiModel.userSex = [gender isEqualToString:@"男"]? @"1":@"0";
    
    NSDate *birthDate = GJCFDateFromString(birthday);
    NSString *ageString = GJCFDateBirthDayToAge(birthDate);
    NSString *age = nil;
    if (![ageString hasSuffix:@"岁"]) {
        age = @"0";
    }else{
        age = [ageString stringByReplacingOccurrencesOfString:@"岁" withString:@""];
    }
    
    if ([notiModel.userSex intValue]) {
        
        notiModel.userAge = [GJGCChatSystemNotiCellStyle formateManAge:age];
    }else{
        
        notiModel.userAge = [GJGCChatSystemNotiCellStyle formateWomenAge:age];
    }
    
    notiModel.userStarName = [GJGCChatSystemNotiCellStyle formateStarName:GJCFDateToConstellation(birthDate)];
    notiModel.headUrl = toUserAvatar;
    notiModel.name = [GJGCChatSystemNotiCellStyle formateNameString:toUserName];
}

- (void)setNotiModelGroupContent:(GJGCChatSystemNotiModel *)notiModel withUserInfo:(NSDictionary *)userInfo
{
    /* 群信息 */
    NSString *groupAvatar = [userInfo objectForKey:@"groupAvatar"];
    NSString *groupName = [userInfo objectForKey:@"name"];
    NSString *groupLevel = [userInfo objectForKey:@"level"];
    NSString *maxMemberCount = [userInfo objectForKey:@"maxCount"];
    NSString *currentCount = [userInfo objectForKey:@"currentCount"];
    
    notiModel.isGroupContent = YES;
    notiModel.name = [GJGCChatSystemNotiCellStyle formateNameString:groupName];
    notiModel.groupLevel = [GJGCChatSystemNotiCellStyle formateGroupLevel:[NSString stringWithFormat:@"Lv.%@",groupLevel]];
    notiModel.groupMemberCount = [GJGCChatSystemNotiCellStyle formateGroupMember:[NSString stringWithFormat:@"%@/%@",currentCount,maxMemberCount]];
    notiModel.headUrl = groupAvatar;
}

- (void)requireListUpdate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireUpdateListTable:)]) {
        [self.delegate dataSourceManagerRequireUpdateListTable:self];
    }
}

- (BOOL)updateAcceptState:(GJGCChatSystemNotiAcceptState)state localMsgId:(NSInteger)localMsgId
{
   return YES;
}

#pragma mark - 更新数据库中消息得高度

- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel
{
   //更新内容高度
}


@end
