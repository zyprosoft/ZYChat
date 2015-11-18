//
//  GJGCChatSystemNotiConstans.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GJGCChatSystemNotiType) {
    
    /**
     *  群管理的操作消息
     */
    GJGCChatSystemNotiTypeGroupOperationState = 1,
    
    /**
     *  别人申请加我为好友
     */
    GJGCChatSystemNotiTypeOtherPersonApplyMyAuthoriz = 2,
    
    /**
     *  群组邀请我加入
     */
    GJGCChatSystemNotiTypeOhtherGroupApplyMyAuthoriz = 3,
    
    /**
     *  别人申请加群
     */
    GJGCChatSystemNotiTypeOtherGroupApply = 4,
    
    /**
     *  别人或者群的申请，并且携带了我之前对这个群或者人申请的操作
     */
    GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState = 5,
    
    /**
     *  系统操作消息
     */
    GJGCChatSystemNotiTypeSystemOperationState = 6,
    
    /**
     *  系统活动引导
     */
    GJGCChatSystemNotiTypeSystemActiveGuide = 7,
    
    /**
     *  灰度提醒
     */
    GJGCChatSystemNotiTypeMiniMessage = 8,
    
    /**
     *  邀请好友加群
     */
    GJGCChatSystemNotiTypeInviteFriendJoinGroup = 9,
    /**
     *  帖子系统消息
     */
    GJGCChatSystemNotiTypePostSystemNoti,
    
};

/**
 *  好友助手通知类型
 */
typedef NS_ENUM(NSUInteger, GJGCChatSystemFriendAssistNotiType) {
    /**
     *  申请加好友
     */
    GJGCChatSystemFriendAssistNotiTypeApply = 1,
    /**
     *  接受好友申请
     */
    GJGCChatSystemFriendAssistNotiTypeAccept = 2,
    /**
     *  拒绝好友申请
     */
    GJGCChatSystemFriendAssistNotiTypeReject = 3,
};

/**
 *  群助手通知类型
 */
typedef NS_ENUM(NSUInteger, GJGCChatSystemGroupAssistNotiType) {
    /**
     *  创建群审核通过
     */
    GJGCChatSystemGroupAssistNotiTypeCreateGroupAccept = 1,
    /**
     *  创建群审核被拒绝
     */
    GJGCChatSystemGroupAssistNotiTypeCreateGroupReject = 2,
    /**
     *  更新群资料信息通过
     */
    GJGCChatSystemGroupAssistNotiTypeUpdateGroupInfoAccept = 3,
    /**
     *  更新群资料信息被拒绝
     */
    GJGCChatSystemGroupAssistNotiTypeUpdateGroupInfoReject = 4,
    /**
     *  收到加入群的请求
     */
    GJGCChatSystemGroupAssistNotiTypeApplyJoinGroup = 5,
    /**
     *  收到邀请加入群的请求
     */
    GJGCChatSystemGroupAssistNotiTypeInviteJoinGroup = 6,
    /**
     *  收到别人同意加群的通知，我是这个群的管理员
     */
    GJGCChatSystemGroupAssistNotiTypeAcceptJoinGroup = 7,
    /**
     *  收到别人同意加入群的通知，我是这个群的成员
     */
    GJGCChatSystemGroupAssistNotiTypeAcceptInviteJoinGroup = 8,
    /**
     *  收到别人拒绝加群的通知
     */
    GJGCChatSystemGroupAssistNotiTypeRejectJoinGroup = 9,
    /**
     *  解散群通知
     */
    GJGCChatSystemGroupAssistNotiTypeDeleteGroup = 10,
    /**
     *  添加群管理员通知
     */
    GJGCChatSystemGroupAssistNotiTypeAddGroupAdmin = 11,
    /**
     *  删除群管理员通知
     */
    GJGCChatSystemGroupAssistNotiTypeDeleteGroupAdmin = 12,
    /**
     *  踢出群成员
     */
    GJGCChatSystemGroupAssistNotiTypeDeleteMemeberByGroupAdmin = 13,
    /**
     *  有人主动退群
     */
    GJGCChatSystemGroupAssistNotiTypeMemeberExitGroup = 14,
    /**
     *  竞选群主
     */
    GJGCChatSystemGroupAssistNotiTypeRequestBeGroupOwner = 20,
    /**
     *  竞选群主成功
     */
    GJGCChatSystemGroupAssistNotiTypeRequestBeGroupOwnerSuccess = 21,
    /**
     *  卸任系统群群主
     */
    GJGCChatSystemGroupAssistNotiTypeBeCancelGroupOwner = 22
};

/**
 *  群内角色
 */
typedef NS_ENUM(NSUInteger, GJGCChatSystemNotiGroupRoleType) {
    /**
     *   群主
     */
    GJGCChatSystemNotiGroupRoleTypeOwner = 1,
    /**
     *  管理员
     */
    GJGCChatSystemNotiGroupRoleTypeAdmin = 2,
    /**
     *  成员
     */
    GJGCChatSystemNotiGroupRoleTypeMember = 3,
    /**
     *  陌生人
     */
    GJGCChatSystemNotiGroupRoleTypeStranger = 4,
    /**
     *  超级管理员
     */
    GJGCChatSystemNotiGroupRoleTypeSuperAdmin = 5
};

/**
 *  需要显示在哪个会话中
 */
typedef NS_ENUM(NSUInteger, GJGCChatSystemNotiRemindType) {
    /**
     *  无内容
     */
    GJGCChatSystemNotiRemindTypeNothing = 0,
    /**
     *  系统助手更新加数字提示
     */
    GJGCChatSystemNotiRemindTypeAssistUnReadCountRemind = 2,
    /**
     *  系统助手更新无数字提示
     */
    GJGCChatSystemNotiRemindTypeAssistUpdateNoCountRemind = 3
};

@interface GJGCChatSystemNotiConstans : NSObject


+ (NSString *)identifierForNotiType:(GJGCChatSystemNotiType)notiType;

+ (Class)classForNotiType:(GJGCChatSystemNotiType)notiType;

@end
