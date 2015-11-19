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
                
        [self readLastMessagesFromDB];
        
    }
    return self;
}

#pragma mark - 观察收到的消息，自己发送的消息也会当成一条收到的消息来处理插入

- (GJGCChatFriendContentModel *)addEaseMessage:(EMMessage *)aMessage
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

- (void)updateAudioFinishRead:(NSString *)localMsgId
{
    
}

#pragma mark - 更新数据库中消息得高度

- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel
{

}

#pragma mark - 重试发送状态消息

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
