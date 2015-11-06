/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCMessageContentView.h
//  Created by litao on 15/4/27.

#ifndef RongIMLib_RCMessageContentView_h
#define RongIMLib_RCMessageContentView_h

/*
 * 自定义消息在会话列表的显示。
 * 当会话的最后一条消息是自定义消息时，需要在会话列表展现会话摘要。自定义消息只需要实现本协议，返回本消息的摘要，SDK会自动显示在会话列表上
 */
@protocol RCMessageContentView
- (NSString *)conversationDigest;
@end

#endif
