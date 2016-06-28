//
//  GJGCMessageExtendBaseModel.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCMessageExtendModel.h"
#import "GJGCGIFLoadManager.h"
#import "GJGCMessageExtendMusicShareModel.h"
#import "GJGCMessageExtendSendFlowerModel.h"
#import "GJGCMessageExtendMiniMessageModel.h"

@implementation GJGCMessageExtendModel

- (NSDictionary *)contentDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (self.userInfo) {
        
        [result setObject:[self.userInfo toDictionary] forKey:kGJGCMessageExtendUserInfo];
        
    }
    
    if (self.isGroupMessage && self.groupInfo) {
        
        [result setObject:[self.groupInfo toDictionary] forKey:kGJGCMessageExtendGroupInfo];
    }
    
    [result setObject:@(self.isGroupMessage) forKey:kGJGCMessageExtendIsGroupMessage];
    
    if (self.messageContent) {
        
        [result setObject:[self.messageContent toDictionary] forKey:kGJGCMessageExtendContentData];
    }
    
    [result setObject:@(self.isExtendMessageContent) forKey:kGJGCMessageExtendIsExtendMessageContent];
    
    if (self.isExtendMessageContent) {
        [result setObject:self.contentType forKey:kGJGCMessageExtendMessageType];
    }
    
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        self.isExtendMessageContent = [contentDict[kGJGCMessageExtendIsExtendMessageContent]boolValue];
        
        self.userInfo = [[GJGCMessageExtendUserModel alloc]initWithDictionary:contentDict[kGJGCMessageExtendUserInfo] error:nil];
        
        self.isGroupMessage = [contentDict[kGJGCMessageExtendIsGroupMessage] boolValue];
        
        if (self.isGroupMessage) {
            
            self.groupInfo = [[GJGCMessageExtendGroupModel alloc]initWithDictionary:contentDict[kGJGCMessageExtendGroupInfo] error:nil];
        }
        
        if (self.isExtendMessageContent) {
            
            self.contentType = contentDict[kGJGCMessageExtendMessageType];

            Class jsonModelClass = [GJGCMessageExtendConst jsonModelClassForMessageContentType:self.contentType];
            self.messageContent = [[jsonModelClass alloc]initWithDictionary:contentDict[kGJGCMessageExtendContentData] error:nil];
        }
    }
    return self;
}

- (void)setChatFriendContentType:(GJGCChatFriendContentType)chatFriendContentType
{
    _chatFriendContentType = chatFriendContentType;
    
    if (GJCFStringIsNull(_contentType)) {
        NSString *changeType = [GJGCMessageExtendModel chatFriendTypeToExtendMsgTypeDict][@(chatFriendContentType)];
        if (!GJCFStringIsNull(changeType)) {
            _contentType = [changeType copy];
        }
    }
}

- (void)setContentType:(NSString *)contentType
{
    if (_contentType) {
        _contentType = nil;
    }
    _contentType = [contentType copy];
    NSLog(@"_contentType:%@",_contentType);
    
    NSNumber *chatContentType = [GJGCMessageExtendModel extendMsgTypeToChatFriendTypeDict][_contentType];
    
    if (chatContentType) {
        
        _chatFriendContentType = [chatContentType integerValue];
    }
}

+ (NSDictionary *)chatFriendTypeToExtendMsgTypeDict
{
    return @{
             @(GJGCChatFriendContentTypeGif):vGJGCMessageExtendContentGIF,
             @(GJGCChatFriendContentTypeMini):vGJGCMessageExtendContentMini,
             @(GJGCChatFriendContentTypeWebPage):vGJGCMessageExtendContentWebPage,
             @(GJGCChatFriendContentTypeMusicShare):vGJGCMessageExtendContentMusicShare,
             @(GJGCChatFriendContentTypeSendFlower):vGJGCMessageExtendContentSendFlower,
             };
}

+ (NSDictionary *)extendMsgTypeToChatFriendTypeDict
{
    return @{
             vGJGCMessageExtendContentGIF:@(GJGCChatFriendContentTypeGif),
             vGJGCMessageExtendContentMini:@(GJGCChatFriendContentTypeMini),
             vGJGCMessageExtendContentWebPage:@(GJGCChatFriendContentTypeWebPage),
             vGJGCMessageExtendContentMusicShare:@(GJGCChatFriendContentTypeMusicShare),
             vGJGCMessageExtendContentSendFlower:@(GJGCChatFriendContentTypeSendFlower),

             };
}

- (BOOL)isSupportDisplay
{
    //首先判定存不存在
    BOOL isMessageTypeSupport = [[GJGCMessageExtendConst extendContentSupportTypes] containsObject:self.contentType]? YES:NO;
    
    if (!isMessageTypeSupport) {
        return isMessageTypeSupport;
    }
    
    //如果是gif特殊处理
    if (self.contentType == vGJGCMessageExtendContentGIF) {
        
        GJGCMessageExtendContentGIFModel *gifContent = (GJGCMessageExtendContentGIFModel *)self.messageContent;

        return [GJGCGIFLoadManager gifEmojiIsExistById:gifContent.emojiCode];
        
    }else{
        
        return isMessageTypeSupport;
    }
}

- (NSString *)displayText
{
    NSString *resultString = @"[未知内容]";
    switch (self.chatFriendContentType) {
        case GJGCChatFriendContentTypeGif:
        {
            GJGCMessageExtendContentGIFModel *gifContent = (GJGCMessageExtendContentGIFModel *)self.messageContent;
            
            resultString = [[GJGCMessageExtendConst extendContentSupportTypes] containsObject:self.contentType]? gifContent.displayText:gifContent.notSupportDisplayText;
            if (self.isSupportDisplay) {
                resultString = [NSString stringWithFormat:@"[GIF:%@]",resultString];
            }else{
                resultString = [NSString stringWithFormat:@"%@",resultString];
            }
        }
            break;
        case GJGCChatFriendContentTypeMusicShare:
        {
            GJGCMessageExtendMusicShareModel *webContent = (GJGCMessageExtendMusicShareModel *)self.messageContent;
            
            resultString = [[GJGCMessageExtendConst extendContentSupportTypes] containsObject:self.contentType]? webContent.displayText:webContent.notSupportDisplayText;
            if (self.isSupportDisplay) {
                resultString = [NSString stringWithFormat:@"[音乐:%@]",resultString];
            }else{
                resultString = [NSString stringWithFormat:@"%@",resultString];
            }
        }
            break;
        case GJGCChatFriendContentTypeWebPage:
        {
            GJGCMessageExtendContentWebPageModel *webContent = (GJGCMessageExtendContentWebPageModel *)self.messageContent;
            
            resultString = [[GJGCMessageExtendConst extendContentSupportTypes] containsObject:self.contentType]? webContent.displayText:webContent.notSupportDisplayText;
            if (self.isSupportDisplay) {
                resultString = [NSString stringWithFormat:@"[网页:%@]",resultString];
            }else{
                resultString = [NSString stringWithFormat:@"%@",resultString];
            }
        }
            break;
        case GJGCChatFriendContentTypeSendFlower:
        {
            GJGCMessageExtendSendFlowerModel *webContent = (GJGCMessageExtendSendFlowerModel *)self.messageContent;
            
            resultString = [[GJGCMessageExtendConst extendContentSupportTypes] containsObject:self.contentType]? webContent.displayText:webContent.notSupportDisplayText;
            if (self.isSupportDisplay) {
                resultString = [NSString stringWithFormat:@"[鲜花:%@]",resultString];
            }else{
                resultString = [NSString stringWithFormat:@"%@",resultString];
            }
        }
        break;
        case GJGCChatFriendContentTypeMini:
        {
            GJGCMessageExtendMiniMessageModel *webContent = (GJGCMessageExtendMiniMessageModel *)self.messageContent;
            
            resultString = [[GJGCMessageExtendConst extendContentSupportTypes] containsObject:self.contentType]? webContent.displayText:webContent.notSupportDisplayText;
            if (self.isSupportDisplay) {
                resultString = [NSString stringWithFormat:@"[系统消息:%@]",resultString];
            }else{
                resultString = [NSString stringWithFormat:@"%@",resultString];
            }
        }
            break;
        default:
            break;
    }
    return resultString;
}


@end
