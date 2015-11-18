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

- (instancetype)init
{
    if (self = [super init]) {
                
    }
    return self;
}

- (EMMessage *)sendMessageContent:(GJGCChatFriendContentModel *)messageContent
{
    EMMessage *sendMessage = nil;
    switch (messageContent.contentType) {
        case GJGCChatFriendContentTypeText:
        {
            sendMessage = [self sendTextMessage:messageContent];
        }
            break;
        case GJGCChatFriendContentTypeAudio:
        {
            sendMessage = [self sendAudioMessage:messageContent];
        }
            break;
        case GJGCChatFriendContentTypeImage:
        {
            sendMessage = [self sendImageMessage:messageContent];
        }
            break;
        default:
            break;
    }
    
    return [[EaseMob sharedInstance].chatManager asyncSendMessage:sendMessage progress:self];
}

- (EMMessage *)sendTextMessage:(GJGCChatFriendContentModel *)messageContent
{
    EMChatText *chatText = [[EMChatText alloc]initWithText:messageContent.originTextMessage];
    EMTextMessageBody *messageBody = [[EMTextMessageBody alloc]initWithChatObject:chatText];
    EMMessage *aMessage = [[EMMessage alloc]initWithReceiver:messageContent.toId bodies:@[messageBody]];
    
    return aMessage;
}

- (EMMessage *)sendAudioMessage:(GJGCChatFriendContentModel *)messageContent
{
    EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:messageContent.audioModel.localStorePath displayName:@"[语音]"];
    voice.duration = messageContent.audioModel.duration;
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:messageContent.toId bodies:@[body]];
    
    return message;
}

- (EMMessage *)sendImageMessage:(GJGCChatFriendContentModel *)messageContent
{
    EMChatImage *imgChat = [[EMChatImage alloc] initWithUIImage:[UIImage imageWithContentsOfFile:messageContent.imageLocalCachePath] displayName:@"[图片]"];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:imgChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:messageContent.toId bodies:@[body]];
    
    return message;
}

#pragma mark - 聊天消息发送回调

- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody
{
    
}

@end
