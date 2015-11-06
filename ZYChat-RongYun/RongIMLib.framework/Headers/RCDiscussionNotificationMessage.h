/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCDiscussionNotification.h
//  Created by Heq.Shinoda on 14-6-26.

#import "RCMessageContent.h"
#define RCDiscussionNotificationTypeIdentifier @"RC:DizNtf"

/**
 *  @enum RCDiscussionNotificationType
 */
typedef NS_ENUM(NSInteger, RCDiscussionNotificationType) {
    /** 加入讨论组通知类型 */
    RCInviteDiscussionNotification = 1,
    /**  退出讨论组通知类型 */
    RCQuitDiscussionNotification,
    /** 修改讨论组名称通知类型 */
    RCRenameDiscussionTitleNotification,
    /** 移除讨论组成员通知类型 */
    RCRemoveDiscussionMemberNotification,
    /** 开关成员邀请通知类型 */
    RCSwichInvitationAccessNotification
};

/**
 *  讨论组通知类定义
 */
@interface RCDiscussionNotificationMessage : RCMessageContent <NSCoding>
/** 通知类型 */
@property(nonatomic, assign) RCDiscussionNotificationType type;
/** 操作者ID */
@property(nonatomic, strong) NSString *operatorId;
/** 扩展字段，用于存储服务器下发扩展信息 */
@property(nonatomic, strong) NSString *extension;
/**
 *   根据字段创建新通知实例
 *
 *  @param type         讨论组通知类型
 *  @param operatorId   操作者ID
 *  @param extension    扩展字段，用于存储服务器下发扩展信息
 */
+ (instancetype)notificationWithType:(RCDiscussionNotificationType)type
operator:(NSString *)operatorId
                           extension:(NSString *)extension;
@end
