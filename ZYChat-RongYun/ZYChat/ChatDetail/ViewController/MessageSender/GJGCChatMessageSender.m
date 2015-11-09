//
//  GJGCChatMessageSender.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatMessageSender.h"

@interface GJGCChatMessageSender ()<IEMChatProgressDelegate>

@end

@implementation GJGCChatMessageSender

+ (GJGCChatMessageSender *)shareSender
{
    static GJGCChatMessageSender *_messageSender = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _messageSender = [[self alloc]init];
        
    });
    return _messageSender;
}

- (void)sendMessageContent:(GJGCChatFriendContentModel *)messageContent
{
    switch (messageContent.contentType) {
        case GJGCChatFriendContentTypeText:
        {
            [self sendTextMessage:messageContent];
        }
            break;
        case GJGCChatFriendContentTypeAudio:
        {
            [self sendAudioMessage:messageContent];
        }
            break;
        case GJGCChatFriendContentTypeImage:
        {
            [self sendImageMessage:messageContent];
        }
            break;
        default:
            break;
    }
}

- (void)sendTextMessage:(GJGCChatFriendContentModel *)messageContent
{
    EMChatText *chatText = [[EMChatText alloc]initWithText:messageContent.originTextMessage];
    EMTextMessageBody *messageBody = [[EMTextMessageBody alloc]initWithChatObject:chatText];
    EMMessage *aMessage = [[EMMessage alloc]initWithReceiver:messageContent.toId bodies:@[messageBody]];
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:aMessage progress:self];
}

- (void)sendAudioMessage:(GJGCChatFriendContentModel *)messageContent
{
    
}

- (void)sendImageMessage:(GJGCChatFriendContentModel *)messageContent
{
    
}

#pragma mark - 聊天消息发送回调

- (void)setProgress:(float)progress
{
    
}

@end
