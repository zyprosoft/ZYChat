//
//  GJGCChatFriendDataSourceManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-12.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendDataSourceManager.h"
#import "GJGCMessageExtendModel.h"

@interface GJGCChatFriendDataSourceManager ()
{
    
}

@end

@implementation GJGCChatFriendDataSourceManager

- (void)dealloc
{
    
}

- (instancetype)initWithTalk:(GJGCChatFriendTalkModel *)talk withDelegate:(id<GJGCChatDetailDataSourceManagerDelegate>)aDelegate
{
    if (self = [super initWithTalk:talk withDelegate:aDelegate]) {
        self.title = talk.toUserName;
        
        _isMyFriend = YES;
        
        [self readLastMessagesFromDB];
        
    }
    return self;
}

#pragma mark - 观察本地发送消息创建成功和消息状态更新通知

- (GJGCChatFriendContentModel *)addEaseMessage:(EMMessage *)aMessage
{
    /* 格式化消息 */
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.toId = aMessage.to;
    chatContentModel.toUserName = aMessage.to;
    chatContentModel.isFromSelf = [aMessage.from isEqualToString:[ZYUserCenter shareCenter].currentLoginUser.mobile]? YES:NO;
    chatContentModel.sendStatus = [[self easeMessageStateRleations][@(aMessage.status)]integerValue];
    chatContentModel.sendTime = (NSInteger)(aMessage.timestamp/1000);
    chatContentModel.senderId = aMessage.from;
    chatContentModel.localMsgId = aMessage.messageId;
    chatContentModel.faildReason = @"";
    chatContentModel.faildType = 0;
    chatContentModel.talkType = self.talkInfo.talkType;
    chatContentModel.contentHeight = 0.f;
    chatContentModel.contentSize = CGSizeZero;

    /* 格式内容字段 */
    GJGCChatFriendContentType contentType = [self formateChatFriendContent:chatContentModel withMsgModel:aMessage];
    
    if (contentType != GJGCChatFriendContentTypeNotFound) {
        [self addChatContentModel:chatContentModel];
        
        //置为已读
        [self.talkInfo.conversation markMessageAsReadWithId:aMessage.messageId];
    }
    
    return chatContentModel;
}

#pragma mark - 更新数据库中消息得高度

- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel
{
//    [[GJGCFriendMsgDBAPI share] updateMsgContentHeight:@(contentModel.contentHeight) contentSize:contentModel.contentSize withToId:self.talkInfo.toId withLocalMsgId:contentModel.localMsgId];
}

@end
