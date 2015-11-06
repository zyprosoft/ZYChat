/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCUnknownMessage.h
//  Created by xugang on 15/1/24.

#import "RCMessageContent.h"
#define RCUnknownMessageTypeIdentifier @"RC:UnknownMsg"

/**
 *  未知消息，所有未注册，未实现的消息都会通过未知消息返回
 */
@interface RCUnknownMessage : RCMessageContent

@end
