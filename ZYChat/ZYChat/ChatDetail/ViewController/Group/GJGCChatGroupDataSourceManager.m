//
//  GJGCChatGroupDataSourceManager.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-29.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatGroupDataSourceManager.h"
#import "GJGCChatFriendDataSourceManager.h"


@implementation GJGCChatGroupDataSourceManager

- (instancetype)initWithTalk:(GJGCChatFriendTalkModel *)talk withDelegate:(id<GJGCChatDetailDataSourceManagerDelegate>)aDelegate
{
    if (self = [super initWithTalk:talk withDelegate:aDelegate]) {

        self.title = talk.toUserName;
        
        [self observeMediaUploadSuccessNoti];
        
        [self readLastMessagesFromDB];
        
    }
    return self;
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
    NSDictionary *passResult = (NSDictionary *)noti.object;
}

#pragma mark - 观察收到的消息，自己发送的消息也会当成一条收到的消息来处理插入

- (void)observeRecievedGroupMessage:(NSNotification *)noti
{
    GJGCChatFriendTalkModel *talkModel = (GJGCChatFriendTalkModel *)noti.userInfo[@"data"];
    
    if (talkModel.talkType != GJGCChatFriendTalkTypeGroup) {
        return;
    }
    
    /*是否当前对话的信息 */
    if ([talkModel.toId intValue] != [self.taklInfo.toId intValue]) {
        
        NSLog(@"not this talk msg:%@",talkModel.toId);
        
        return;
        
    }
    
    NSLog(@"群聊对话收到一组消息:%@",talkModel.msgArray);
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self receievedGroupMessage:talkModel];
        
    });
}

- (void)receievedGroupMessage:(GJGCChatFriendTalkModel *)talkModel
{
    //收群消息
    
    /* 重新排序 */
    if (talkModel.msgArray.count >= 4) {
        
        [self resortAllChatContentBySendTime];
                
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireUpdateListTable:)]) {
        NSLog(@"chatVC reload data:%@",self.delegate);
        [self.delegate dataSourceManagerRequireUpdateListTable:self];
    }
}

- (void)observeHistoryMessage:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self recievedHistoryMessage:noti];
        
    });
}

- (void)recievedHistoryMessage:(NSNotification *)noti
{
    /* 是否当前会话的历史消息 */
    
    /* 悬停在第一次加载后的第一条消息上 */
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireFinishRefresh:)]) {
        
        [self.delegate dataSourceManagerRequireFinishRefresh:self];
    }

    /* 如果没有历史消息了 */
    self.isFinishLoadAllHistoryMsg = YES;

}

- (GJGCChatFriendContentModel *)addGroupMsg
{
    /* 格式化消息 */
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.toId = @"8888";
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.isFromSelf = YES;
    chatContentModel.sendStatus = 1;
    chatContentModel.sendTime = [[NSDate date]timeIntervalSince1970];
    chatContentModel.localMsgId = @"1223334";
    chatContentModel.senderId = @"4444444";
    chatContentModel.isGroupChat = YES;
    chatContentModel.senderName = [GJGCChatFriendCellStyle formateGroupChatSenderName:@"vincent"];
    chatContentModel.faildReason = @"";
    chatContentModel.faildType = 0;
    chatContentModel.talkType = self.taklInfo.talkType;
    chatContentModel.contentHeight = 0.f;
    chatContentModel.contentSize = CGSizeZero;
    chatContentModel.sessionId = @"88888";

    /* 解析内容 */
    
    //创建一条群消息内容
    
    [self addChatContentModel:chatContentModel];

    return chatContentModel;
}

#pragma mark - 读取最近历史消息

- (void)readLastMessagesFromDB
{
   //读取最近20条消息
    
    /* 更新时间 */
    [self updateAllMsgTimeShowString];
    
    /* 设置加载完后第一条消息和最后一条消息 */
    [self resetFirstAndLastMsgId];

}

- (void)pushAddMoreMsg:(NSArray *)array
{
    //添加消息数组
    
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

#pragma mark - 删除消息

- (NSArray *)deleteMessageAtIndex:(NSInteger)index
{
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self contentModelAtIndex:index];
    
    BOOL isDelete = YES;//数据库删除消息结果
    
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

- (void)updateAudioFinishRead:(NSString *)localMsgId
{
    
}

#pragma mark - 更新数据库中消息得高度

- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel
{

}

#pragma mark - 重试发送状态消息

- (void)reTryAllSendingStateMsgDetailAction
{
    
}

- (void)mockSendAnMesssage:(GJGCChatFriendContentModel *)messageContent
{
    //收到消息
    [self addChatContentModel:messageContent];
    
    [self updateTheNewMsgTimeString:messageContent];
    
    //模拟一条对方发来的消息
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.contentType = GJGCChatFriendContentTypeText;
    NSString *text = @"其实我也很喜欢和你聊天，网址:http://www.163.com 个人QQ:1003081775";
    NSDictionary *parseTextDict = [GJGCChatFriendCellStyle formateSimpleTextMessage:text];
    chatContentModel.simpleTextMessage = [parseTextDict objectForKey:@"contentString"];
    chatContentModel.originTextMessage = text;
    chatContentModel.emojiInfoArray = [parseTextDict objectForKey:@"imageInfo"];
    chatContentModel.phoneNumberArray = [parseTextDict objectForKey:@"phone"];
    chatContentModel.toId = self.taklInfo.toId;
    chatContentModel.toUserName = self.taklInfo.toUserName;
    NSDate *sendTime = GJCFDateFromStringByFormat(@"2015-7-15 10:22:11", @"Y-M-d HH:mm:ss");
    chatContentModel.sendTime = [sendTime timeIntervalSince1970];
    chatContentModel.timeString = [GJGCChatSystemNotiCellStyle formateTime:GJCFDateToString(sendTime)];
    chatContentModel.sendStatus = GJGCChatFriendSendMessageStatusSuccess;
    chatContentModel.isFromSelf = NO;
    chatContentModel.isGroupChat = YES;
    chatContentModel.senderName = [GJGCChatFriendCellStyle formateGroupChatSenderName:@"莱纳德"];
    chatContentModel.talkType = self.taklInfo.talkType;
    chatContentModel.headUrl = @"http://photocdn.sohu.com/20100131/Img269941132.jpg";
    [self addChatContentModel:chatContentModel];
    
    [self updateTheNewMsgTimeString:chatContentModel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireUpdateListTable:)]) {
        
        [self.delegate dataSourceManagerRequireUpdateListTable:self];
        
    }
}

@end
