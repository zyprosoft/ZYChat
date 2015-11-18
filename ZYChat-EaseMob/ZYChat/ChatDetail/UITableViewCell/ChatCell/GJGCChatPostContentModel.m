//
//  GJGCChatPostContentModel.m
//  ZYChat
//
//  Created by ZYVincent on 14-12-23.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatPostContentModel.h"

@implementation GJGCChatPostContentModel

- (instancetype)init
{
    if (self = [super init]) {
        
        self.talkType = GJGCChatFriendTalkTypePost;
        self.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
        
    }
    return self;
}


@end
