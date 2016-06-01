//
//  GJGCChatDetailDataSourceManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatDetailDataSourceManager.h"
#import "GJGCMessageExtendModel.h"
#import "GJGCGIFLoadManager.h"
#import "EMMessage.h"
#import "EMMessageBody.h"
#import "Base64.h"
#import "GJGCMessageExtendContentGIFModel.h"
#import "GJGCMessageExtendMusicShareModel.h"
#import "GJGCMessageExtendSendFlowerModel.h"

NSString * GJGCChatForwardMessageDidSendNoti = @"GJGCChatForwardMessageDidSendNoti";

@interface GJGCChatDetailDataSourceManager ()<EMChatManagerDelegate>

@property (nonatomic,strong)dispatch_queue_t messageSenderQueue;

@property (nonatomic,strong)dispatch_source_t refreshListSource;

@end

@implementation GJGCChatDetailDataSourceManager

- (instancetype)initWithTalk:(GJGCChatFriendTalkModel *)talk withDelegate:(id<GJGCChatDetailDataSourceManagerDelegate>)aDelegate
{
    if (self = [super init]) {
        
        _talkInfo = talk;
        
        _uniqueIdentifier = [NSString stringWithFormat:@"GJGCChatDetailDataSourceManager_%@",GJCFStringCurrentTimeStamp];
        
        self.delegate = aDelegate;
        
        //观察转发消息
        [GJCFNotificationCenter addObserver:self selector:@selector(observeForwardSendMessage:) name:GJGCChatForwardMessageDidSendNoti object:nil];
        
        //清除会话的未读数
        [self.talkInfo.conversation markAllMessagesAsRead];
        
        //最短消息间隔500毫秒
        self.lastSendMsgTime = 0;
        self.sendTimeLimit = 500;
        
        [self initState];
        
    }
    return self;
}

#pragma mark - 插入新消息

- (void)insertNewMessageWithStartIndex:(NSInteger)startIndex Count:(NSInteger)count
{
    NSMutableArray *willUpdateIndexPaths = [NSMutableArray array];
    for (NSInteger index = startIndex + 1; index < startIndex + count; index++ ) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [willUpdateIndexPaths addObject:indexPath];
    }
    if (willUpdateIndexPaths.count > 0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireUpdateListTable:insertIndexPaths:)]) {
            [self.delegate dataSourceManagerRequireUpdateListTable:self insertIndexPaths:willUpdateIndexPaths];
        }
    }
}

- (void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [GJCFNotificationCenter removeObserver:self];
}

#pragma mark - 内部接口

- (NSArray *)heightForContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return nil;
    }
    
    Class cellClass;
    
    switch (contentModel.baseMessageType) {
        case GJGCChatBaseMessageTypeSystemNoti:
        {
            GJGCChatSystemNotiModel *notiModel = (GJGCChatSystemNotiModel *)contentModel;
            cellClass = [GJGCChatSystemNotiConstans classForNotiType:notiModel.notiType];
        }
            break;
        case GJGCChatBaseMessageTypeChatMessage:
        {
            GJGCChatFriendContentModel *chatContentModel = (GJGCChatFriendContentModel *)contentModel;
            cellClass = [GJGCChatFriendConstans classForContentType:chatContentModel.contentType];
        }
            break;
        default:
            break;
    }
    
    GJGCChatBaseCell *baseCell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [baseCell setContentModel:contentModel];
    
    CGFloat contentHeight = [baseCell heightForContentModel:contentModel];
    CGSize  contentSize = [baseCell contentSize];
    
    return @[@(contentHeight),[NSValue valueWithCGSize:contentSize]];
}

- (void)initState
{
    if (!self.messageSenderQueue) {
        self.messageSenderQueue = dispatch_queue_create("_gjgc_message_sender_queue", DISPATCH_QUEUE_SERIAL);
    }
    
    //缓冲刷新
    if (!self.refreshListSource) {
        self.refreshListSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, _messageSenderQueue);
        dispatch_source_set_event_handler(_refreshListSource, ^{
           
            [self dispatchOptimzeRefresh];
        });
    }
    dispatch_resume(self.refreshListSource);
    
    //注册监听
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:_messageSenderQueue];
    
    self.isFinishFirstHistoryLoad = NO;
    
    self.chatListArray = [[NSMutableArray alloc]init];
    
    self.timeShowSubArray = [[NSMutableArray alloc]init];
}

#pragma mark - update UI By Dispatch_Source_t

#pragma mark - 公开接口

- (NSInteger)totalCount
{
    return self.chatListArray.count;
}

- (NSInteger)chatContentTotalCount
{
    return self.chatListArray.count - self.timeShowSubArray.count;
}

- (Class)contentCellAtIndex:(NSInteger)index
{
    Class resultClass;
    
    if (index > self.totalCount - 1) {
        return nil;
    }
    
    /* 分发信息 */
    GJGCChatContentBaseModel *contentModel = [self.chatListArray objectAtIndex:index];
    
    switch (contentModel.baseMessageType) {
        case GJGCChatBaseMessageTypeSystemNoti:
        {
            GJGCChatSystemNotiModel *notiModel = (GJGCChatSystemNotiModel *)contentModel;
            resultClass = [GJGCChatSystemNotiConstans classForNotiType:notiModel.notiType];
        }
            break;
        case GJGCChatBaseMessageTypeChatMessage:
        {
            GJGCChatFriendContentModel *messageModel = (GJGCChatFriendContentModel *)contentModel;
            resultClass = [GJGCChatFriendConstans classForContentType:messageModel.contentType];
        }
            break;
        default:
            
            break;
    }
    
    return resultClass;
}

- (NSString *)contentCellIdentifierAtIndex:(NSInteger)index
{
    if (index > self.totalCount - 1) {
        return nil;
    }
    
    NSString *resultIdentifier = nil;
    
    /* 分发信息 */
    GJGCChatContentBaseModel *contentModel = [self.chatListArray objectAtIndex:index];
    
    switch (contentModel.baseMessageType) {
        case GJGCChatBaseMessageTypeSystemNoti:
        {
            GJGCChatSystemNotiModel *notiModel = (GJGCChatSystemNotiModel *)contentModel;
            resultIdentifier = [GJGCChatSystemNotiConstans identifierForNotiType:notiModel.notiType];
        }
            break;
        case GJGCChatBaseMessageTypeChatMessage:
        {
            GJGCChatFriendContentModel *messageModel = (GJGCChatFriendContentModel *)contentModel;
            resultIdentifier = [GJGCChatFriendConstans identifierForContentType:messageModel.contentType];
        }
            break;
        default:
        
            break;
    }
    
    return resultIdentifier;
}

- (GJGCChatContentBaseModel *)contentModelAtIndex:(NSInteger)index
{
    return [self.chatListArray objectAtIndex:index];
}

- (CGFloat)rowHeightAtIndex:(NSInteger)index
{
    if (index > self.totalCount - 1) {
        return 0.f;
    }
    
    GJGCChatContentBaseModel *contentModel = [self contentModelAtIndex:index];
    
    return contentModel.contentHeight;
}

- (NSNumber *)updateContentModel:(GJGCChatContentBaseModel *)contentModel atIndex:(NSInteger)index
{
    NSArray *contentHeightArray = [self heightForContentModel:contentModel];
    contentModel.contentHeight = [[contentHeightArray firstObject] floatValue];
    contentModel.contentSize = [[contentHeightArray lastObject] CGSizeValue];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self updateMsgContentHeightWithContentModel:contentModel];

    });
    
    [self.chatListArray replaceObjectAtIndex:index withObject:contentModel];
    
    return @(contentModel.contentHeight);
}

- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel
{
    
}

- (GJGCChatContentBaseModel *)contentModelByLocalMsgId:(NSString *)localMsgId
{
    for (int i = 0 ; i < self.chatListArray.count ; i ++) {
        
        GJGCChatContentBaseModel *contentItem = [self.chatListArray objectAtIndex:i];
        
        if ([contentItem.localMsgId isEqualToString:localMsgId]) {
            
            return contentItem;
            
            break;
        }
    }
    return nil;
}

- (void)updateContentModelValuesNotEffectRowHeight:(GJGCChatContentBaseModel *)contentModel atIndex:(NSInteger)index
{
    [self.chatListArray replaceObjectAtIndex:index withObject:contentModel];
}

- (void)addChatContentModel:(GJGCChatContentBaseModel *)contentModel
{
    contentModel.contentSourceIndex = self.chatListArray.count;
    
    if (contentModel.contentHeight == 0) {
        
        NSArray *contentHeightArray = [self heightForContentModel:contentModel];
        contentModel.contentHeight = [[contentHeightArray firstObject] floatValue];
        contentModel.contentSize = [[contentHeightArray lastObject] CGSizeValue];
        
        [self updateMsgContentHeightWithContentModel:contentModel];
        
    }else{
        
        NSLog(@"不需要计算内容高度:%f",contentModel.contentHeight);
        
    }
    
    [self.chatListArray addObject:contentModel];
    
    if ([contentModel.class isSubclassOfClass:[GJGCChatFriendContentModel class]]) {
        [self.delegate dataSourceManagerDidRecievedChatContent:(GJGCChatFriendContentModel *)contentModel];
    }
}

- (void)removeChatContentModelAtIndex:(NSInteger)index
{
    [self.chatListArray removeObjectAtIndex:index];
}

- (void)readLastMessagesFromDB
{
    //如果会话不存在
    if (!self.talkInfo.conversation) {
        self.isFinishFirstHistoryLoad = YES;
        self.isFinishLoadAllHistoryMsg = YES;
        return;
    }

    //读取最近20条消息
    NSArray *messages = [self.talkInfo.conversation loadMoreMessagesFromId:nil limit:20 direction:EMMessageSearchDirectionUp];

    for (EMMessage *theMessage in messages) {

        [self addEaseMessage:theMessage];
    }

    /* 更新时间 */
    [self updateAllMsgTimeShowString];

    /* 设置加载完后第一条消息和最后一条消息 */
    [self resetFirstAndLastMsgId];

    self.isFinishFirstHistoryLoad = YES;
    self.isFinishLoadAllHistoryMsg = NO;
}

#pragma mark - 删除消息

- (NSArray *)deleteMessageAtIndex:(NSInteger)index
{
    GJGCChatFriendContentModel *deleteContentModel = [self.chatListArray objectAtIndex:index];
    BOOL isDelete = [self.talkInfo.conversation deleteMessageWithId:deleteContentModel.localMsgId];
    
    //消息删没了，把会话也删掉
    if (![self.talkInfo.conversation latestMessage]) {
        [[EMClient sharedClient].chatManager deleteConversation:self.talkInfo.toId deleteMessages:YES];
    }
    
    NSMutableArray *willDeletePaths = [NSMutableArray array];
    
    if (isDelete) {
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

#pragma mark - 加载历史消息

- (void)trigglePullHistoryMsgForEarly
{
    NSLog(@"聊天详情触发拉取更早历史消息 talkType:%@ toId:%@",GJGCTalkTypeString(self.talkInfo.talkType),self.talkInfo.toId);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        if (self.chatListArray && [self.chatListArray count] > 0) {
            
            /* 去掉时间模型，找到最上面一条消息内容 */
            GJGCChatFriendContentModel *lastMsgContent;
            for (int i = 0; i < self.totalCount ; i++) {
                GJGCChatFriendContentModel *item = (GJGCChatFriendContentModel *)[self contentModelAtIndex:i];
                
                if (!item.isTimeSubModel) {
                    lastMsgContent = item;
                    break;
                }
                
            }
            
            //环信精确到毫秒所以要*1000
            NSArray *localHistoryMsgArray = [self.talkInfo.conversation loadMoreMessagesFromId:lastMsgContent.localMsgId limit:20 direction:EMMessageSearchDirectionUp];
            
            if (localHistoryMsgArray && localHistoryMsgArray.count > 0 ) {
                
                [self pushAddMoreMsg:localHistoryMsgArray];
                
            }else{
                
                self.isFinishLoadAllHistoryMsg = YES;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    /* 悬停在第一次加载后的第一条消息上 */
                    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireFinishRefresh:)]) {
                        
                        [self.delegate dataSourceManagerRequireFinishRefresh:self];
                    }
                    
                });
            }
        }
    });
    
}

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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.delegate dataSourceManagerRequireFinishRefresh:weakSelf];
        });
    }
}

#pragma mark - 所有内容重排时间

- (void)resortAllChatContentBySendTime
{
    
    /* 去掉时间区间model */
    for (GJGCChatContentBaseModel *contentBaseModel in self.timeShowSubArray) {
        
        /* 去掉时间区间重新排序 */
        if (contentBaseModel.isTimeSubModel) {
            [self.chatListArray removeObject:contentBaseModel];
        }
        
    }
    
    NSArray *sortedArray = [self.chatListArray sortedArrayUsingSelector:@selector(compareContent:)];
    [self.chatListArray removeAllObjects];
    [self.chatListArray addObjectsFromArray:sortedArray];
    
    /* 重设时间区间 */
    [self updateAllMsgTimeShowString];
}

- (void)resortAllSystemNotiContentBySendTime
{
    NSArray *sortedArray = [self.chatListArray sortedArrayUsingSelector:@selector(compareContent:)];
    [self.chatListArray removeAllObjects];
    [self.chatListArray addObjectsFromArray:sortedArray];
}

#pragma mark - 重设第一条消息的msgId
- (void)resetFirstAndLastMsgId
{
    /* 重新设置第一条消息的Id */
    if (self.chatListArray.count > 0) {
        
        GJGCChatContentBaseModel *firstMsgContent = [self.chatListArray firstObject];
        
        NSInteger nextMsgIndex = 0;
        
        while (firstMsgContent.isTimeSubModel) {
            
            nextMsgIndex++;
            
            firstMsgContent = [self.chatListArray objectAtIndex:nextMsgIndex];
            
        }
        
        self.lastFirstLocalMsgId = firstMsgContent.localMsgId;
    }
}

#pragma mark - 更新所有聊天消息的时间显示块

- (void)updateAllMsgTimeShowString
{
  /* 始终以当前时间为计算基准 最后最新一条时间开始往上计算*/
  [self.timeShowSubArray removeAllObjects];
  
    NSTimeInterval firstMsgTimeInterval = 0;
    
    GJGCChatFriendContentModel *currentTimeSubModel = nil;
    for (NSInteger i = 0; i < self.totalCount; i++) {
        
        GJGCChatFriendContentModel *contentModel = [self.chatListArray objectAtIndex:i];
        if (contentModel.contentType == GJGCChatFriendContentTypeTime) {
            NSLog(@"contentModel is time :%@",contentModel.uniqueIdentifier);
        }
        
        NSString *timeString = [GJGCChatSystemNotiCellStyle timeAgoStringByLastMsgTime:contentModel.sendTime lastMsgTime:firstMsgTimeInterval];
        
        if (timeString) {
            
            /* 创建时间块，插入到数据源 */
            firstMsgTimeInterval = contentModel.sendTime;
            
            GJGCChatFriendContentModel *timeSubModel = [GJGCChatFriendContentModel timeSubModel];
            timeSubModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
            timeSubModel.contentType = GJGCChatFriendContentTypeTime;
            timeSubModel.timeString = [GJGCChatSystemNotiCellStyle formateTime:timeString];
            NSArray *contentHeightArray = [self heightForContentModel:timeSubModel];
            timeSubModel.contentHeight = [[contentHeightArray firstObject] floatValue];
            timeSubModel.sendTime = contentModel.sendTime;
            timeSubModel.timeSubMsgCount = 1;
            
            currentTimeSubModel = timeSubModel;
            
            contentModel.timeSubIdentifier = timeSubModel.uniqueIdentifier;
            
            [self.chatListArray replaceObjectAtIndex:i withObject:contentModel];
            
            [self.chatListArray insertObject:timeSubModel atIndex:i];
            
            i++;
        
            [self.timeShowSubArray addObject:timeSubModel];
            
        }else{
            
            contentModel.timeSubIdentifier = currentTimeSubModel.uniqueIdentifier;
            currentTimeSubModel.timeSubMsgCount = currentTimeSubModel.timeSubMsgCount + 1;
            
            [self updateContentModelByUniqueIdentifier:contentModel];
            [self updateContentModelByUniqueIdentifier:currentTimeSubModel];
            
        }
    }
}

- (void)updateContentModelByUniqueIdentifier:(GJGCChatContentBaseModel *)contentModel
{
    for (NSInteger i = 0; i < self.totalCount ; i++) {
        
        GJGCChatContentBaseModel *itemModel = [self.chatListArray objectAtIndex:i];
        
        if ([itemModel.uniqueIdentifier isEqualToString:contentModel.uniqueIdentifier]) {
            
            [self.chatListArray replaceObjectAtIndex:i withObject:contentModel];
            
            break;
        }
    }
}

- (GJGCChatContentBaseModel *)timeSubModelByUniqueIdentifier:(NSString *)identifier
{
    for (GJGCChatContentBaseModel *timeSubModel in self.chatListArray) {
        
        if ([timeSubModel.uniqueIdentifier isEqualToString:identifier]) {
            
            return timeSubModel;
        }
    }
    return nil;
}

- (void)updateTheNewMsgTimeString:(GJGCChatContentBaseModel *)contentModel
{
    NSTimeInterval lastSubTimeInterval;
     GJGCChatFriendContentModel *lastTimeSubModel = [self.timeShowSubArray lastObject];
    if (self.timeShowSubArray.count > 0) {
        lastSubTimeInterval = lastTimeSubModel.sendTime;
    }else{
        lastSubTimeInterval = 0;
    }
    
    NSString *timeString = [GJGCChatSystemNotiCellStyle timeAgoStringByLastMsgTime:contentModel.sendTime lastMsgTime:lastSubTimeInterval];
    
    if (timeString) {
        
        GJGCChatFriendContentModel *newLastTimeSubModel = [GJGCChatFriendContentModel timeSubModel];
        newLastTimeSubModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
        newLastTimeSubModel.contentType = GJGCChatFriendContentTypeTime;
        newLastTimeSubModel.sendTime = contentModel.sendTime;
        newLastTimeSubModel.timeString = [GJGCChatSystemNotiCellStyle formateTime:timeString];
        NSArray *contentHeightArray = [self heightForContentModel:newLastTimeSubModel];
        newLastTimeSubModel.contentHeight = [[contentHeightArray firstObject] floatValue];
        newLastTimeSubModel.timeSubMsgCount = 1;
        
        contentModel.timeSubIdentifier = newLastTimeSubModel.uniqueIdentifier;
        
        [self updateContentModelByUniqueIdentifier:contentModel];
        
        [self.chatListArray insertObject:newLastTimeSubModel atIndex:self.totalCount - 1];
        
        [self.timeShowSubArray addObject:newLastTimeSubModel];

    }else{
        
        contentModel.timeSubIdentifier = lastTimeSubModel.uniqueIdentifier;
        lastTimeSubModel.timeSubMsgCount = lastTimeSubModel.timeSubMsgCount + 1;
        
        [self updateContentModelByUniqueIdentifier:contentModel];
        [self updateContentModelByUniqueIdentifier:lastTimeSubModel];
        
    }
    
}

/* 删除某条消息，更新下一条消息的区间 */
- (NSString *)updateMsgContentTimeStringAtDeleteIndex:(NSInteger)index
{
    GJGCChatContentBaseModel *contentModel = [self.chatListArray objectAtIndex:index];
    
    GJGCChatContentBaseModel *timeSubModel = [self timeSubModelByUniqueIdentifier:contentModel.timeSubIdentifier];
    timeSubModel.timeSubMsgCount = timeSubModel.timeSubMsgCount - 1;
    
    if (timeSubModel.timeSubMsgCount == 0) {
        
        return timeSubModel.uniqueIdentifier;
        
    }else{
        
        [self updateContentModelByUniqueIdentifier:timeSubModel];
        
        return nil;
    }
}

- (void)removeContentModelByIdentifier:(NSString *)identifier
{
    for (GJGCChatContentBaseModel *item in self.chatListArray) {
        
        if ([item.uniqueIdentifier isEqualToString:identifier]) {
            
            [self.chatListArray removeObject:item];
            
            break;
        }
    }
}

- (void)removeTimeSubByIdentifier:(NSString *)identifier
{
    [self removeContentModelByIdentifier:identifier];
    
    for (GJGCChatContentBaseModel *item in self.timeShowSubArray) {
        
        if ([item.uniqueIdentifier isEqualToString:identifier]) {
            
            [self.timeShowSubArray removeObject:item];
            
            break;
        }
    }
}

- (NSInteger)getContentModelIndexByLocalMsgId:(NSString *)msgId
{
    NSInteger resultIndex = NSNotFound;
 
    if (GJCFStringIsNull(msgId)) {
        return resultIndex;
    }
    
    for ( int i = 0; i < self.chatListArray.count; i++) {
        
        GJGCChatContentBaseModel *contentModel = [self.chatListArray objectAtIndex:i];
        
        if ([contentModel.localMsgId isEqualToString:msgId]) {
            
            resultIndex = i;
            
            break;
        }

    }
    
    return resultIndex;
}

- (GJGCChatContentBaseModel *)contentModelByMsgId:(NSString *)msgId
{
    NSInteger resultIndex = [self getContentModelIndexByLocalMsgId:msgId];
    
    if (resultIndex != NSNotFound) {
        
        return [self.chatListArray objectAtIndex:resultIndex];
    }
    return nil;
}

- (void)updateLastSystemMessageForRecentTalk
{

}

#pragma mark - 清除过早历史消息

- (void)clearOverEarlyMessage
{
    if (self.totalCount > 40) {
        
        [self.chatListArray removeObjectsInRange:NSMakeRange(0, self.totalCount - 40)];
        self.isFinishLoadAllHistoryMsg = NO;//重新可以数据库翻页
        [self resetFirstAndLastMsgId];
        
        dispatch_source_merge_data(_refreshListSource, 1);
    }
}

#pragma mark - 格式化消息内容

- (GJGCChatFriendContentType)formateChatFriendContent:(GJGCChatFriendContentModel *)chatContentModel withMsgModel:(EMMessage *)msgModel
{
    GJGCChatFriendContentType type = GJGCChatFriendContentTypeNotFound;
    
//    NSArray *bodies = msgModel.messageBodies;
    
    EMMessageBody *messageBody = msgModel.body;
    chatContentModel.messageBody = messageBody;
    chatContentModel.contentType = type;
    
    //普通文本消息和依靠普通文本消息扩展出来的消息类型
    GJGCMessageExtendModel *extendModel = [[GJGCMessageExtendModel alloc]initWithDictionary:msgModel.ext];
    
    switch ([messageBody type]) {
        case EMMessageBodyTypeImage:
        {
            chatContentModel.contentType = GJGCChatFriendContentTypeImage;
        }
            break;
        case EMMessageBodyTypeText:
        {
            NSLog(@"解析扩展内容:%@",[extendModel contentDictionary]);
            
            //普通文本消息
            if (!extendModel.isExtendMessageContent) {
                
                chatContentModel.contentType = GJGCChatFriendContentTypeText;
                
                EMTextMessageBody *textMessageBody = (EMTextMessageBody *)messageBody;
                
                if (!GJCFNSCacheGetValue(textMessageBody.text)) {
                    [GJGCChatFriendCellStyle formateSimpleTextMessage:textMessageBody.text];
                }
                chatContentModel.originTextMessage = textMessageBody.text;
                
            }
            
            //扩展消息类型
            if (extendModel.isExtendMessageContent) {
                
                chatContentModel.contentType = extendModel.chatFriendContentType;
                
                //是否支持显示的扩展消息
                if (extendModel.isSupportDisplay) {
                    
                    //进一步解析消息内容
                    switch (extendModel.chatFriendContentType) {
                        case GJGCChatFriendContentTypeGif:
                        {
                            GJGCMessageExtendContentGIFModel *gifContent = (GJGCMessageExtendContentGIFModel *)extendModel.messageContent;
                            chatContentModel.gifLocalId = gifContent.emojiCode;
                        }
                            break;
                        case GJGCChatFriendContentTypeMusicShare:
                        {
                            GJGCMessageExtendMusicShareModel  *musicContent = (GJGCMessageExtendMusicShareModel *)extendModel.messageContent;
                            chatContentModel.audioModel.remotePath = musicContent.songUrl;
                            chatContentModel.audioModel.localStorePath = [[GJCFCachePathManager shareManager]mainAudioCacheFilePathForUrl:musicContent.songId];
                            chatContentModel.audioModel.isNeedConvertEncodeToSave = NO;
                            chatContentModel.musicSongId = musicContent.songId;
                            chatContentModel.musicSongName = musicContent.title;
                            chatContentModel.musicSongUrl = musicContent.songUrl;
                            chatContentModel.musicSongAuthor = musicContent.author;
                        }
                            break;
                        case GJGCChatFriendContentTypeWebPage:
                        {
                            GJGCMessageExtendContentWebPageModel *webPageContent = (GJGCMessageExtendContentWebPageModel *)extendModel.messageContent;
                            chatContentModel.webPageThumbImageData = [webPageContent.thumbImageBase64 base64DecodedData];
                            chatContentModel.webPageTitle = webPageContent.title;
                            chatContentModel.webPageSumary = webPageContent.sumary;
                            chatContentModel.webPageUrl = webPageContent.url;
                            
                        }
                            break;
                        case GJGCChatFriendContentTypeSendFlower:
                        {
                            GJGCMessageExtendSendFlowerModel *flowerContent = (GJGCMessageExtendSendFlowerModel *)extendModel.messageContent;
                            chatContentModel.flowerTitle = flowerContent.title;
                            
                        }
                            break;
                        default:
                            break;
                    }
                }
                
                //如果不支持，需要将消息显示成文本消息
                if (![extendModel isSupportDisplay]) {
                    
                    chatContentModel.contentType = GJGCChatFriendContentTypeText;
                    
                    EMTextMessageBody *textMessageBody = (EMTextMessageBody *)messageBody;
                    
                    if (!GJCFNSCacheGetValue(textMessageBody.text)) {
                        [GJGCChatFriendCellStyle formateSimpleTextMessage:textMessageBody.text];
                    }
                    chatContentModel.originTextMessage = textMessageBody.text;
                }
            }
        }
            break;
        case EMMessageBodyTypeCmd:
        {
            
        }
            break;
        case EMMessageBodyTypeFile:
        {
            
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            chatContentModel.contentType = GJGCChatFriendContentTypeLimitVideo;
            
            EMVideoMessageBody *voiceMessageBody = (EMVideoMessageBody *)messageBody;
            
            chatContentModel.videoUrl = [NSURL fileURLWithPath:voiceMessageBody.localPath];
            
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            chatContentModel.contentType = GJGCChatFriendContentTypeAudio;
            
            EMVoiceMessageBody *voiceMessageBody = (EMVoiceMessageBody *)messageBody;
            
            chatContentModel.audioModel.localStorePath = voiceMessageBody.localPath;
            chatContentModel.audioModel.duration = voiceMessageBody.duration;
            chatContentModel.audioDuration =  [GJGCChatFriendCellStyle formateAudioDuration:GJCFStringFromInt(chatContentModel.audioModel.duration)];
        }
            break;
        default:
            break;
    }
    type = chatContentModel.contentType;
    
    //解析用户信息
    chatContentModel.headUrl = extendModel.userInfo.headThumb;
    if (chatContentModel.talkType == GJGCChatFriendTalkTypeGroup) {
        chatContentModel.senderName = [GJGCChatFriendCellStyle formateGroupChatSenderName:extendModel.userInfo.nickName];
    }
    
    return type;
}

- (BOOL)sendMessage:(GJGCChatFriendContentModel *)messageContent
{
    /*
     * 只有文本和gif这类消息会产生速度检测，
     * 如果不加这个判定的话，在发送多张图片的时候，
     * 分割成单张，会被认为间隔时间太短
     */
     if (messageContent.contentType == GJGCChatFriendContentTypeText || messageContent.contentType == GJGCChatFriendContentTypeGif || messageContent.contentType == GJGCChatFriendContentTypeGif ) {
         if (self.lastSendMsgTime != 0) {
            
            //间隔太短
            NSTimeInterval now = [[NSDate date]timeIntervalSince1970]*1000;
            if (now - self.lastSendMsgTime < self.sendTimeLimit) {
                return NO;
            }
        }
    }
    
    messageContent.sendStatus = GJGCChatFriendSendMessageStatusSending;
    EMMessage *message = [self sendMessageContent:messageContent];
    messageContent.messageBody = message.body;
    messageContent.localMsgId = message.messageId;
    messageContent.easeMessageTime = message.timestamp;
    messageContent.sendTime = (NSInteger)(message.timestamp/1000);
    [messageContent setupUserInfoByExtendUserContent:[[ZYUserCenter shareCenter]extendUserInfo]];

    //收到消息
    [self addChatContentModel:messageContent];
    
    [self updateTheNewMsgTimeString:messageContent];
    
    //缓冲刷新
    dispatch_source_merge_data(_refreshListSource, 1);
    
    self.lastSendMsgTime = [[NSDate date]timeIntervalSince1970]*1000;
    
    return YES;
}

- (void)reSendMessage:(GJGCChatFriendContentModel *)messageContent
{
    GJCFWeakSelf weakSelf = self;
    EMMessage *message = [self.talkInfo.conversation loadMessageWithId:messageContent.localMsgId];
    dispatch_async(_messageSenderQueue, ^{
        [[EMClient sharedClient].chatManager asyncResendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
            GJGCChatFriendSendMessageStatus status = GJGCChatFriendSendMessageStatusSending;
            switch (message.status) {
                case EMMessageStatusPending:
                case EMMessageStatusDelivering:
                {
                    status = GJGCChatFriendSendMessageStatusSending;
                }
                    break;
                case EMMessageStatusSuccessed:
                {
                    status = GJGCChatFriendSendMessageStatusSuccess;
                }
                    break;
                case EMMessageStatusFailed:
                {
                    status = GJGCChatFriendSendMessageStatusFaild;
                }
                    break;
                default:
                    break;
            }
            
            [weakSelf updateMessageState:message state:status];
            
        }];
    });
}

#pragma mark - 收环信消息到数据源，子类具体实现
- (GJGCChatFriendContentModel *)addEaseMessage:(EMMessage *)aMessage
{
    return nil;
}

#pragma mark -  环信发送消息过程

- (EMMessage *)sendMessageContent:(GJGCChatFriendContentModel *)messageContent
{
    //如果当前会话信息不存在，创建一个
    if (!self.talkInfo.conversation) {
        EMConversationType conversationType;
        switch (self.talkInfo.talkType) {
            case GJGCChatFriendTalkTypePrivate:
                conversationType = EMConversationTypeChat;
                break;
            case GJGCChatFriendTalkTypeGroup:
                conversationType = EMConversationTypeGroupChat;
                break;
            default:
                break;
        }
        self.talkInfo.conversation = [[EMClient sharedClient].chatManager getConversation:messageContent.toId type:conversationType createIfNotExist:YES];
    }
    
    EMMessage *sendMessage = nil;
    switch (messageContent.contentType) {
        case GJGCChatFriendContentTypeText:
        {
            sendMessage = [self buildTextMessage:messageContent];
        }
            break;
        case GJGCChatFriendContentTypeAudio:
        {
            sendMessage = [self buildAudioMessage:messageContent];
        }
            break;
        case GJGCChatFriendContentTypeImage:
        {
            sendMessage = [self buildImageMessage:messageContent];
        }
            break;
        case GJGCChatFriendContentTypeLimitVideo:
        {
            sendMessage = [self buildVideoMessage:messageContent];
        }
            break;
        default:
            break;
    }
    
    //添加用户扩展信息
    GJGCMessageExtendModel *extendInfo = [[GJGCMessageExtendModel alloc]init];
    extendInfo.userInfo = [[ZYUserCenter shareCenter]extendUserInfo];
    extendInfo.isExtendMessageContent = NO;
    sendMessage.ext = [extendInfo contentDictionary];
    
    //添加群组扩展信息
    if (self.talkInfo.talkType == GJGCChatFriendTalkTypeGroup) {
        GJGCMessageExtendGroupModel *groupInfo = [[GJGCMessageExtendGroupModel alloc]init];
        
        //是否有扩展信息
        if (self.talkInfo.groupInfo) {
            
            groupInfo.groupName = self.talkInfo.groupInfo.groupName;
            groupInfo.groupHeadThumb = self.talkInfo.groupInfo.groupHeadThumb;
            
        }else{
            
            groupInfo.groupName = self.talkInfo.toUserName;
            groupInfo.groupHeadThumb = @"";
            
        }
        

        extendInfo.isGroupMessage = YES;
        extendInfo.groupInfo = groupInfo;
    }
    
    //发送扩展类型的消息
    switch (messageContent.contentType) {
        case GJGCChatFriendContentTypeGif:
        {
            extendInfo.isExtendMessageContent = YES;
            
            GJGCMessageExtendContentGIFModel *gifContent = [[GJGCMessageExtendContentGIFModel alloc]init];
            gifContent.emojiCode = messageContent.gifLocalId;
            gifContent.emojiVersion = GJCFSystemAppStringVersion;
            gifContent.displayText = [GJGCGIFLoadManager gifNameById:messageContent.gifLocalId];
            gifContent.notSupportDisplayText = [NSString stringWithFormat:@"[GIF:%@]请更新你的源代码以支持此表情显示",gifContent.displayText];
            
            messageContent.originTextMessage = gifContent.notSupportDisplayText;
            sendMessage = [self buildTextMessage:messageContent];
            
            extendInfo.messageContent = gifContent;
            extendInfo.chatFriendContentType = messageContent.contentType;
        }
            break;
        case GJGCChatFriendContentTypeMini:
        {
            
        }
            break;
        default:
            break;
    }
    
    //设置消息类型
    switch (messageContent.talkType) {
        case GJGCChatFriendTalkTypePrivate:
            sendMessage.chatType = EMChatTypeChat;
            break;
        case GJGCChatFriendTalkTypeGroup:
            sendMessage.chatType = EMChatTypeGroupChat;
            break;
        default:
            break;
    }
    sendMessage.ext = [extendInfo contentDictionary];
    NSLog(@"sendMessage Ext:%@",sendMessage.ext);
    
    GJCFWeakSelf weakSelf = self;
    dispatch_async(_messageSenderQueue, ^{
        [[EMClient sharedClient].chatManager asyncSendMessage:sendMessage progress:nil completion:^(EMMessage *message, EMError *aError) {
            GJGCChatFriendSendMessageStatus status = GJGCChatFriendSendMessageStatusSending;
            switch (message.status) {
                case EMMessageStatusPending:
                case EMMessageStatusDelivering:
                {
                    status = GJGCChatFriendSendMessageStatusSending;
                }
                    break;
                case EMMessageStatusSuccessed:
                {
                    status = GJGCChatFriendSendMessageStatusSuccess;
                }
                    break;
                case EMMessageStatusFailed:
                {
                    status = GJGCChatFriendSendMessageStatusFaild;
                }
                    break;
                default:
                    break;
            }
            
            [weakSelf updateMessageState:message state:status];
        }];
    });
    
    return sendMessage;
}

- (EMMessage *)buildTextMessage:(GJGCChatFriendContentModel *)messageContent
{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:messageContent.originTextMessage];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *aMessage = [[EMMessage alloc] initWithConversationID:messageContent.toId from:from to:messageContent.toId body:body ext:nil];
    
    return aMessage;
}

- (EMMessage *)buildAudioMessage:(GJGCChatFriendContentModel *)messageContent
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:messageContent.audioModel.localStorePath displayName:@"[语音]"];
    body.duration = messageContent.audioModel.duration;
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:messageContent.toId from:from to:messageContent.toId body:body ext:nil];
    
    return message;
}

- (EMMessage *)buildImageMessage:(GJGCChatFriendContentModel *)messageContent
{
    NSString *filePath = [[GJCFCachePathManager shareManager]mainImageCacheFilePath:messageContent.imageLocalCachePath];
    
    // 生成message
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithLocalPath:filePath displayName:@"[图片]"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:messageContent.toId from:from to:messageContent.toId body:body ext:nil];
    
    return message;
}

- (EMMessage *)buildVideoMessage:(GJGCChatFriendContentModel *)messageContent
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithLocalPath:[messageContent.videoUrl relativePath] displayName:@"[短视频]"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:messageContent.toId from:from to:messageContent.toId body:body ext:nil];
    
    return message;
}

#pragma mark - 聊天消息发送回调

- (void)updateMessageState:(EMMessage *)theMessage state:(GJGCChatFriendSendMessageStatus)status
{
    GJGCChatFriendContentModel *findContent = nil;
    NSInteger findIndex = NSNotFound;
    
    for (NSInteger index =0 ;index < self.chatListArray.count;index++) {
        
        GJGCChatFriendContentModel *content = [self.chatListArray objectAtIndex:index];
        
        if (content.easeMessageTime == theMessage.timestamp) {
            
            findContent = content;
            findIndex = index;
            
            break;
        }
    }
    
    if (findContent && findIndex !=NSNotFound) {
        findContent.sendStatus = status;
        [self.delegate dataSourceManagerRequireUpdateListTable:self reloadAtIndex:findIndex];
    }
}

#pragma mark - Dispatch 缓冲刷新会话列表

- (void)dispatchOptimzeRefresh
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireUpdateListTable:)]) {
        
        [self.delegate dataSourceManagerRequireUpdateListTable:self];
    }
}

- (void)observeForwardSendMessage:(NSNotification *)noti
{
    EMMessage *message = noti.object;
    
    [self didReceiveMessage:message];
}

#pragma mark - 接收消息回调

- (void)didReceiveMessages:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        [self didReceiveMessage:message];
    }
}

- (void)didReceiveMessage:(EMMessage *)message
{
    if ([message.conversationId isEqualToString:self.talkInfo.toId]) {
        
        GJGCChatContentBaseModel *contentModel = [self addEaseMessage:message];
        
        [self updateTheNewMsgTimeString:contentModel];
        
        dispatch_source_merge_data(_refreshListSource, 1);
    }
}

- (void)didReceiveMessageId:(NSString *)messageId chatter:(NSString *)conversationChatter error:(EMError *)error
{
    
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    
}

#pragma mark - 检测网络变化

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        
        //把所有发送状态的消息改为失败
        for (NSInteger index = 0; index < self.chatListArray.count; index++) {
            
            GJGCChatFriendContentModel *contentModel = self.chatListArray[index];
            
            if (contentModel.sendStatus == GJGCChatFriendSendMessageStatusSending) {
                
                contentModel.sendStatus = GJGCChatFriendSendMessageStatusFaild;
                
                EMMessage *message = [self.talkInfo.conversation loadMessageWithId:contentModel.localMsgId];
                message.status = EMMessageStatusFailed;
                [self.talkInfo.conversation updateMessage:message];
                
                [self.chatListArray replaceObjectAtIndex:index withObject:contentModel];
            }
        }
        
        dispatch_source_merge_data(self.refreshListSource, 1);
    }
}

- (NSDictionary *)easeMessageStateRleations
{
    return @{
             @(EMMessageStatusSuccessed):@(GJGCChatFriendSendMessageStatusSuccess),
             @(EMMessageStatusDelivering):@(GJGCChatFriendSendMessageStatusSending),
             @(EMMessageStatusPending):@(GJGCChatFriendSendMessageStatusSending),
             @(EMMessageStatusFailed):@(GJGCChatFriendSendMessageStatusFaild),
             };
}

@end
