//
//  GJGCChatFriendTalkModel.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-24.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendTalkModel.h"

@implementation GJGCChatFriendTalkModel

+ (NSString *)talkTypeString:(GJGCChatFriendTalkType)talkType
{
    NSString *msgType = nil;
    switch (talkType) {
        case GJGCChatFriendTalkTypeGroup:
        {
            msgType = @"group";
        }
            break;
        case GJGCChatFriendTalkTypePost:
        {
            msgType = @"post_private";
        }
            break;
        case GJGCChatFriendTalkTypePrivate:
        {
            msgType = @"private";
        }
            break;
        case GJGCChatFriendTalkSystemAssist:
        {
            msgType = @"system";
        }
            break;
        case GJGCChatFriendTalkTypePostSystem:
        {
            msgType = @"post_system";
        }
            break;
        default:
            break;
    }

    return msgType;
}

@end
