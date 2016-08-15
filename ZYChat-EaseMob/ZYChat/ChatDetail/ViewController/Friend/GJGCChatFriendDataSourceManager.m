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
    chatContentModel.talkType = self.taklInfo.talkType;
    chatContentModel.contentHeight = 0.f;
    chatContentModel.contentSize = CGSizeZero;

    /* 格式内容字段 */
    GJGCChatFriendContentType contentType = [self formateChatFriendContent:chatContentModel withMsgModel:aMessage];
    
    if (contentType != GJGCChatFriendContentTypeNotFound) {
        [self addChatContentModel:chatContentModel];
        
        //置为已读
        [self.taklInfo.conversation markMessageAsReadWithId:aMessage.messageId];
    }
    
    return chatContentModel;
}

#pragma mark - 数据库读取最后二十条信息

- (void)readLastMessagesFromDB
{
    //如果会话不存在
    if (!self.taklInfo.conversation) {
        self.isFinishFirstHistoryLoad = YES;
        self.isFinishLoadAllHistoryMsg = YES;
        return;
    }
    
    //读取最近的20条消息
    long long beforeTime = [[NSDate date]timeIntervalSince1970]*1000;
    NSArray *messages = [self.taklInfo.conversation loadMoreMessagesContain:nil before:beforeTime limit:10 from:nil direction:EMMessageSearchDirectionUp];
    
    for (EMMessage *theMessage in messages) {
        
        [self addEaseMessage:theMessage];
    }
    
    /* 更新时间区间 */
    [self updateAllMsgTimeShowString];
    
    /* 设置加载完后第一条消息和最后一条消息 */
    [self resetFirstAndLastMsgId];
    
    self.isFinishFirstHistoryLoad = YES;
    self.isFinishLoadAllHistoryMsg = NO;
}

#pragma mark - 删除消息


- (void)pushAddMoreMsg:(NSArray *)array
{
    /* 分发到UI层，添加一组消息 */
    for (EMMessage *aMessage in array) {
        [self addEaseMessage:aMessage];
    }
    
    /* 重排时间顺序 */
    [self resortAllChatContentBySendTime];
    
    /* 上一次悬停的第一个cell的索引 */    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireFinishRefresh:)]) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.delegate dataSourceManagerRequireFinishRefresh:weakSelf];
        });
    }
}

#pragma mark - 更新数据库中消息得高度

- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel
{
//    [[GJGCFriendMsgDBAPI share] updateMsgContentHeight:@(contentModel.contentHeight) contentSize:contentModel.contentSize withToId:self.taklInfo.toId withLocalMsgId:contentModel.localMsgId];
}

- (void)updateAudioFinishRead:(NSString *)localMsgId
{
//    [[GJGCFriendMsgDBAPI share] updateAudioMsgFinishRead:[localMsgId longLongValue] toId:self.taklInfo.toId];
}

@end
