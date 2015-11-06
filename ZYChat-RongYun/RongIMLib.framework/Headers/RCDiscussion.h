/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCDiscussion.h
//  Created by Heq.Shinoda on 14-6-23.

#ifndef __RCDiscussion
#define __RCDiscussion

#import <Foundation/Foundation.h>

/**
    讨论组类定义
 */
@interface RCDiscussion : NSObject
/** 讨论组ID */
@property(nonatomic, strong) NSString *discussionId;
/** 讨论组名称 */
@property(nonatomic, strong) NSString *discussionName;
/** 创建讨论组用户ID */
@property(nonatomic, strong) NSString *creatorId;
/** 会话类型 */
@property(nonatomic, assign) int conversationType;
/** 讨论组成员ID列表 */
@property(nonatomic, strong) NSArray *memberIdList;
/** 是否开放成员邀请 0表示开放，1表示关闭 */
@property(nonatomic, assign) int inviteStatus;
/** 是否推送消息通知 0表示开放，1表示关闭 */
@property(nonatomic, assign) int pushMessageNotificationStatus;
/**
 *  指派的初始化方法
 *
 *  @param discussionId                     讨论组ID
 *  @param discussionName                   讨论组名称
 *  @param creatorId                        创建者ID
 *  @param conversationType                 会话类型
 *  @param memberIdList                     成员ID列表
 *  @param inviteStatus                     是否开放成员邀请:0表示开放,1表示关闭
 *  @param pushMessageNotificationStatus    是否推送消息通知:0表示开放,1表示关闭
 */
- (instancetype)initWithDiscussionId:(NSString *)discussionId
                      discussionName:(NSString *)discussionName
                           creatorId:(NSString *)creatorId
                    conversationType:(int)conversationType
                        memberIdList:(NSArray *)memberIdList
                        inviteStatus:(int)inviteStatus
               msgNotificationStatus:(int)pushMessageNotificationStatus;
@end
#endif
