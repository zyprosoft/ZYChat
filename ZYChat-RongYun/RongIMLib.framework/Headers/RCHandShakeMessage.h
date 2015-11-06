/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCHandShakeMessage.h
//  Created by Heq.Shinoda on 14-6-30.

#import "RCMessageContent.h"

#define RCHandShakeMessageTypeIdentifier @"RC:HsMsg"
/**
 *  客服握手消息
 */
@interface RCHandShakeMessage : RCMessageContent <RCMessageCoding, RCMessagePersistentCompatible>
/**
 *  init
 *
 *  @return return instance
 */
- (RCHandShakeMessage *)init;

@end
