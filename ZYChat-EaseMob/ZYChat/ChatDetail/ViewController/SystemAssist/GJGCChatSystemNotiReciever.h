//
//  GJGCChatSystemNotiReciever.h
//  ZYChat
//
//  Created by ZYVincent on 16/6/28.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SystemAssistConversationId @"zychat_system_assist"

#define GJGCChatSystemNotiRecieverDidReiceveSystemNoti @"GJGCChatSystemNotiRecieverDidReiceveSystemNoti"

@interface GJGCChatSystemNotiReciever : NSObject

+ (GJGCChatSystemNotiReciever *)shareReciever;
- (EMConversation *)systemAssistConversation;
- (void)insertSystemMessageInfo:(NSDictionary *)messageInfo;

@end
