/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCProfileNotificationMessage.h
//  Created by xugang on 14/11/28.

#import "RCMessageContent.h"

#define RCProfileNotificationMessageIdentifier @"RC:ProfileNtf"
/**
 *  资料变更消息
 */
@interface RCProfileNotificationMessage : RCMessageContent
/**
 *  资料变更的操作名。
 */
@property(nonatomic, strong) NSString *operation;
/**
 *  资料变更的数据，可以为任意格式，如 JSON。
 */
@property(nonatomic, strong) NSString *data;
/**
 *  附加信息。
 */
@property(nonatomic, strong) NSString *extra;
/**
 *  构造方法
 *
 *  @param operation 资料变更的操作名。
 *  @param data      资料变更的数据，可以为任意格式，如 JSON。
 *  @param extra     附加信息。
 *
 *  @return 类实例
 */
+ (instancetype)notificationWithOperation:(NSString *)operation data:(NSString *)data extra:(NSString *)extra;

@end
