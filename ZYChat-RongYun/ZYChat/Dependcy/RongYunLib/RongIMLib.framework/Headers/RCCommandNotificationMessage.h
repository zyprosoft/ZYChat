/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCCommandNotificationMessage.h
//  Created by xugang on 14/11/28.

#import "RCMessageContent.h"

#define RCCommandNotificationMessageIdentifier @"RC:CmdNtf"
/**
 *  命令消息类
 */
@interface RCCommandNotificationMessage : RCMessageContent
/**
 *  命令名。
 */
@property(nonatomic, strong) NSString *name;
/**
 *  命令数据，可以为任意格式，如 JSON。
 */
@property(nonatomic, strong) NSString *data;
/**
 *  构造方法
 *
 *  @param name 命令名。
 *  @param data 命令数据，可以为任意格式，如 JSON。
 *
 *  @return 类实例
 */
+ (instancetype)notificationWithName:(NSString *)name data:(NSString *)data;

@end
