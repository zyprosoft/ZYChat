/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCInterruptMessage.h
//  Created by xugang on 15/1/12.

#import <Foundation/Foundation.h>
#import "RCMessageContent.h"

#define RCInterruptMessageTypeIdentifier @"RC:SpMsg"
/**
 *  客服挂断消息
 */
@interface RCSuspendMessage : RCMessageContent <RCMessageCoding, RCMessagePersistentCompatible>

/**
 *  init
 *
 *  @return return instance
 */
- (instancetype)init;

@end
