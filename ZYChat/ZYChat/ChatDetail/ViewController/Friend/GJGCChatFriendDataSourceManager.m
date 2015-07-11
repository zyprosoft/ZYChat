//
//  GJGCChatFriendDataSourceManager.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-12.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendDataSourceManager.h"

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
        
        /* 观察附件上传 */
        [self observeMediaUploadSuccessNoti];

        [self readLastMessagesFromDB];
        
    }
    return self;
}

#pragma mark - 观察好友关系变更

- (void)observeRemoveOrAddFriendNoti:(NSDictionary *)userInfo
{
    NSString *actionType = userInfo[@"type"];
    NSString *friendId = userInfo[@"friendId"];
    
    if (![friendId isEqualToString:self.taklInfo.toId]) {
        return;
    }
    
    if ([actionType isEqualToString:@"add"] || [actionType isEqualToString:@"update"]) {
        
        _isMyFriend = YES;
        
    }
    
    if ([actionType isEqualToString:@"remove"] || [actionType isEqualToString:@"none"]) {
        
        _isMyFriend = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireChangeAudioRecordEnableState:state:)]) {
        [self.delegate dataSourceManagerRequireChangeAudioRecordEnableState:self state:_isMyFriend];
    }

}

#pragma mark - 观察到UI更新了附件地址消息

- (void)observeMediaUploadSuccessNoti
{

}

- (void)recieveMediaUploadSuccessNoti:(NSNotification *)noti
{
    NSDictionary *notiInfo = noti.object;
    
    NSString *type = notiInfo[@"type"];
    NSString *url = notiInfo[@"data"];
    NSString *msgId = notiInfo[@"msgId"];
    NSString *toId = notiInfo[@"toId"];
    
    if (![toId isEqualToString:self.taklInfo.toId]) {
        return;
    }
    
    if ([type isEqualToString:@"audio"]) {
        
        [self updateAudioUrl:url withLocalMsg:msgId toId:toId];
    }
    
    if ([type isEqualToString:@"image"]) {
        
        [self updateImageUrl:url withLocalMsg:msgId toId:toId];
    }
}

#pragma mark - 观察本地发送消息创建成功和消息状态更新通知

- (void)observeLocalMessageUpdate:(NSNotification *)noti
{
    
}

#pragma mark - 观察收到的消息，自己发送的消息也会当成一条收到的消息来处理插入

- (void)observeRecieveFriendMsg:(NSNotification *)noti
{
    GJGCChatFriendTalkModel *talkModel = (GJGCChatFriendTalkModel *)noti.userInfo[@"data"];
    
    if (talkModel.talkType != GJGCChatFriendTalkTypePrivate) {
        return;
    }
    
    /*是否当前对话的信息 */
    if (![talkModel.toId isEqualToString:self.taklInfo.toId]) {
        
        NSLog(@"not this talk msg:%@",talkModel.toId);
        
        return;
        
    }
    
    NSLog(@"好友对话 收到一组消息 msg:%@",talkModel.msgArray);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self recieveFriendMsg:talkModel];
        
    });
}

- (void)recieveFriendMsg:(GJGCChatFriendTalkModel *)talkModel
{
    //收到消息
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireUpdateListTable:)]) {
        
        NSLog(@"chatVC reload data:%ld",(long)(self.totalCount-1));
        
        [self.delegate dataSourceManagerRequireUpdateListTable:self];
        
    }
}

#pragma mark - 观察历史消息
- (void)observeHistoryMessage:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self recieveHistoryMessage:noti];
        
    });
}

- (void)recieveHistoryMessage:(NSNotification *)noti
{
    /* 是否当前会话的历史消息 */
    
    /* 悬停在第一次加载后的第一条消息上 */
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireFinishRefresh:)]) {
        
        [self.delegate dataSourceManagerRequireFinishRefresh:self];
    }
    
    
    /* 如果没有历史消息了 */
    self.isFinishLoadAllHistoryMsg = YES;

}

- (GJGCChatFriendContentModel *)addFriendMsg
{
    /* 格式化消息 */
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.toId = @"88888";
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.isFromSelf = YES;
    chatContentModel.sendStatus = 1;
    chatContentModel.sendTime = [[NSDate date]timeIntervalSince1970];
    chatContentModel.senderId = @"444444";
    chatContentModel.localMsgId = @"133223444";
    chatContentModel.faildReason = @"";
    chatContentModel.faildType = 0;
    chatContentModel.talkType = self.taklInfo.talkType;
    chatContentModel.contentHeight = 0.f;
    chatContentModel.contentSize = CGSizeZero;
    chatContentModel.sessionId = @"88888";
    
    /* 格式内容字段 */
    //创造需要的内容
    
    
    [self addChatContentModel:chatContentModel];

    
    return chatContentModel;
}

#pragma mark - 数据库读取最后二十条信息

- (void)readLastMessagesFromDB
{
    //读取最近的20条消息
    
    /* 更新时间区间 */
    [self updateAllMsgTimeShowString];
    
    /* 设置加载完后第一条消息和最后一条消息 */
    [self resetFirstAndLastMsgId];
}

#pragma mark - 删除消息

- (NSArray *)deleteMessageAtIndex:(NSInteger)index
{    
    BOOL isDelete = YES;//数据库完成删除动作
    
    NSMutableArray *willDeletePaths = [NSMutableArray array];

    if (isDelete) {
        
        /* 更新最近联系人列表得最后一条消息 */
        if (index == self.totalCount - 1 && self.chatContentTotalCount > 1) {
            
            GJGCChatFriendContentModel *lastContentAfterDelete = nil;
            lastContentAfterDelete = (GJGCChatFriendContentModel *)[self contentModelAtIndex:index-1];
            if (lastContentAfterDelete.isTimeSubModel) {
                
                if (self.chatContentTotalCount - 1 >= 1) {
                    
                    lastContentAfterDelete = (GJGCChatFriendContentModel *)[self contentModelAtIndex:index - 2];
                    
                }
                
            }
            
            if (lastContentAfterDelete) {
                
                /* 更新最近会话信息 */
                [self updateLastMsg:lastContentAfterDelete];
                
            }

        }
        
        NSString *willDeleteTimeSubIdentifier = [self updateMsgContentTimeStringAtDeleteIndex:index];
        
        [self removeChatContentModelAtIndex:index];
        
        [willDeletePaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        
        if (willDeleteTimeSubIdentifier) {
            
            [willDeletePaths addObject:[NSIndexPath indexPathForRow:index - 1 inSection:0]];
            
            [self removeTimeSubByIdentifier:willDeleteTimeSubIdentifier];
        }
    }
    
    return willDeletePaths;
}

- (void)pushAddMoreMsg:(NSArray *)array
{
    /* 分发到UI层，添加一组消息 */
    
    
    /* 重排时间顺序 */
    [self resortAllChatContentBySendTime];
    
    /* 上一次悬停的第一个cell的索引 */    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireFinishRefresh:)]) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.delegate dataSourceManagerRequireFinishRefresh:weakSelf];
        });
        
        
    }
}

#pragma mark - 更新附件地址

- (void)updateAudioUrl:(NSString *)audioUrl withLocalMsg:(NSString *)localMsgId toId:(NSString *)toId
{
    for (GJGCChatFriendContentModel *contentModel in self.chatListArray) {
        
        if ([contentModel.localMsgId longLongValue] == [localMsgId longLongValue]) {
            
            NSLog(@"更新内存中语音的地址为:%@",audioUrl);
            contentModel.audioModel.localStorePath = [[GJCFCachePathManager shareManager]mainAudioCacheFilePathForUrl:audioUrl];
            
            break;
        }
        
    }
}

- (void)updateImageUrl:(NSString *)imageUrl withLocalMsg:(NSString *)localMsgId toId:(NSString *)toId
{
    for (GJGCChatFriendContentModel *contentModel in self.chatListArray) {
        
        if ([contentModel.localMsgId longLongValue] == [localMsgId longLongValue]) {
            
            contentModel.imageMessageUrl = imageUrl;
            
            NSLog(@"更新内存中图片的地址为:%@",imageUrl);
            
            break;
        }
        
    }
}

#pragma mark - 更新数据库中消息得高度

- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel
{
//    [[GJGCFriendMsgDBAPI share] updateMsgContentHeight:@(contentModel.contentHeight) contentSize:contentModel.contentSize withToId:self.taklInfo.toId withLocalMsgId:contentModel.localMsgId];
}

#pragma mark - 重新尝试所有发送状态的消息

- (void)reTryAllSendingStateMsgDetailAction
{

}

- (void)updateAudioFinishRead:(NSString *)localMsgId
{
//    [[GJGCFriendMsgDBAPI share] updateAudioMsgFinishRead:[localMsgId longLongValue] toId:self.taklInfo.toId];
}

- (void)testDriftMessage
{
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.toId = @"2334455";
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.isFromSelf = NO;
    chatContentModel.sendStatus = 1;
    chatContentModel.sendTime = [[NSDate date]timeIntervalSince1970];
    chatContentModel.senderId = GJCFStringFromInt([self.taklInfo.toId intValue]);
    chatContentModel.localMsgId = @"111111";
    chatContentModel.faildReason = @"null";
    chatContentModel.faildType = 0;
    chatContentModel.talkType = self.taklInfo.talkType;
    chatContentModel.contentHeight = 0.f;
    chatContentModel.contentSize = CGSizeZero;
    chatContentModel.sessionId = self.taklInfo.toId;
    chatContentModel.contentType = GJGCChatFriendContentTypeDriftBottle;
    
    chatContentModel.driftBottleContentString = [GJGCChatFriendCellStyle formateDriftBottleContent:@"多么美好的一天做个测试多么美好的一天做个测试多么美好的一天做个测试多么美好的一天做个测试多么美好的一天"];
    chatContentModel.imageMessageUrl = @"http://img4q.duitang.com/uploads/item/201312/05/20131205172457_JZzNH.jpeg";
    chatContentModel.headUrl = @"http://upload.wuhan.net.cn/2014/0721/1405909402350.jpg";
    
    /* 格式内容字段 */
    [self addChatContentModel:chatContentModel];

    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireUpdateListTable:)]) {
        
        [self.delegate dataSourceManagerRequireUpdateListTable:self];
        
    }
}



@end
