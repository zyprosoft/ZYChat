//
//  GJGCChatMessageSender.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatFriendContentModel.h"

@interface GJGCChatMessageSender : NSObject

+ (GJGCChatMessageSender *)shareSender;

- (EMMessage *)sendMessageContent:(GJGCChatFriendContentModel *)messageContent;

@end
