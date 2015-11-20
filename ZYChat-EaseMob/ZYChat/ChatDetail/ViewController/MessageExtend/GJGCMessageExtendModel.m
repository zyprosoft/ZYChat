//
//  GJGCMessageExtendBaseModel.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMessageExtendModel.h"
#import "GJGCGIFLoadManager.h"

@implementation GJGCMessageExtendModel

- (NSDictionary *)contentDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (self.userInfo) {
        
        [result setObject:[self.userInfo toDictionary] forKey:kGJGCMessageExtendUserInfo];
        
    }
    
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
             };
}

+ (NSDictionary *)extendMsgTypeToChatFriendTypeDict
{
    return @{
             vGJGCMessageExtendContentGIF:@(GJGCChatFriendContentTypeGif),
             vGJGCMessageExtendContentMini:@(GJGCChatFriendContentTypeMini),
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
        case GJGCChatFriendContentTypeMini:
        {
    
        }
            break;
        default:
            break;
    }
    return resultString;
}


@end
