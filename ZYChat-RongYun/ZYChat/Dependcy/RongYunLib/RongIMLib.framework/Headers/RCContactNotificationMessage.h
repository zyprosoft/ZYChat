/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCContactNotificationMessage.h
//  Created by xugang on 14/11/28.

#import "RCMessageContent.h"

#define RCContactNotificationMessageIdentifier @"RC:ContactNtf"

// 加好友请求。
#define ContactNotificationMessage_ContactOperationRequest @"Request"
// 加好友请求。
#define ContactNotificationMessage_ContactOperationAcceptResponse @"AcceptResponse"
// 加好友请求。
#define ContactNotificationMessage_ContactOperationRejectResponse @"RejectResponse"

/**
 *  好友消息类。
 */
@interface RCContactNotificationMessage : RCMessageContent <NSCoding>
/**
 *  操作名，对应 ContactOperationXxxx，或自己传任何字符串。
 */
@property(nonatomic, strong) NSString *operation;
/**
 *  请求者或者响应者的 UserId。
 */
@property(nonatomic, strong) NSString *sourceUserId;
/**
 *  被请求者或者被响应者的 UserId。
 */
@property(nonatomic, strong) NSString *targetUserId;
/**
 *  请求或者响应消息，如添加理由或拒绝理由。
 */
@property(nonatomic, strong) NSString *message;
/**
 *  附加信息。
 */
@property(nonatomic, strong) NSString *extra;
/**
 *  构造方法
 *
 *  @param operation    操作名，对应 ContactOperationXxxx，或自己传任何字符串。
 *  @param sourceUserId 请求者或者响应者的 UserId。
 *  @param targetUserId 被请求者或者被响应者的 UserId。
 *  @param message      请求或者响应消息，如添加理由或拒绝理由。
 *  @param extra        附加信息。
 *
 *  @return 类实例
 */
+ (instancetype)notificationWithOperation:(NSString *)operation
                             sourceUserId:(NSString *)sourceUserId
                             targetUserId:(NSString *)targetUserId
                                  message:(NSString *)message
                                    extra:(NSString *)extra;

@end
