/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCInformationNotificationMessage.h
//  Created by xugang on 14/12/4.

#import "RCMessageContent.h"

#define RCInformationNotificationMessageIdentifier @"RC:InfoNtf"
/**
 *  系统消息类
 */
@interface RCInformationNotificationMessage : RCMessageContent

/**
 *  消息内容
 */
@property(nonatomic, strong) NSString *message;
/**
 *  附加信息。
 */
@property(nonatomic, strong) NSString *extra;
/**
 *  构造方法
 *
 *  @param message 消息内容
 *  @param extra   附加信息。
 *
 *  @return 类实例
 */
+ (instancetype)notificationWithMessage:(NSString *)message extra:(NSString *)extra;

@end
