/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCGroupNotification.h
//  Created by xugang on 14/11/24.

#import "RCMessageContent.h"

#define RCGroupNotificationMessageIdentifier @"RC:GrpNtf"

// 新成员加入群。
#define GroupNotificationMessage_GroupOperationAdd @"Add"
// 成员退出群。
#define GroupNotificationMessage_GroupOperationQuit @"Quit"
// 成员被管理员踢出。
#define GroupNotificationMessage_GroupOperationKicked @"Kicked"
// 群组重命名。
#define GroupNotificationMessage_GroupOperationRename @"Rename"
// 群组公告变更。
#define GroupNotificationMessage_GroupOperationBulletin @"Bulletin"

/**
 *  群组消息类
 */
@interface RCGroupNotificationMessage : RCMessageContent
/**
 *  操作人 UserId，可以为空
 */
@property(nonatomic, strong) NSString *operatorUserId;
/**
 *  操作名，对应 GroupOperationXxxx，或任意字符串。
 */
@property(nonatomic, strong) NSString *operation;
/**
 *  被操做人 UserId 或者操作数据（如改名后的名称）。
 */
@property(nonatomic, strong) NSString *data;
/**
 *  操作信息，可以为空，如：你被 xxx 踢出了群。
 */
@property(nonatomic, strong) NSString *message;
/**
 *  附加信息。
 */
@property(nonatomic, strong) NSString *extra; // 附加信息。

/**
 *  构造方法
 *
 *  @param operation      操作名，对应 GroupOperationXxxx，或任意字符串。
 *  @param operatorUserId 操作人 UserId，可以为空
 *  @param data           被操做人 UserId 或者操作数据（如改名后的名称）。
 *  @param message        操作信息，可以为空，如：你被 xxx 踢出了群。
 *  @param extra          附加信息
 *
 *  @return 类方法
 */
+ (instancetype)notificationWithOperation:(NSString *)operation
                           operatorUserId:(NSString *)operatorUserId
                                     data:(NSString *)data
                                  message:(NSString *)message
                                    extra:(NSString *)extra;

@end
