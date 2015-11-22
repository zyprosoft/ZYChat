//
//  GJGCRecentChatDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/18.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCRecentChatDataManager.h"
#import "GJGCRecentChatStyle.h"
#import "GJGCChatFriendCellStyle.h"
#import "GJGCMessageExtendModel.h"

static

@interface GJGCRecentChatDataManager ()<EMChatManagerDelegate>

@property (nonatomic,strong)NSMutableArray *sourceArray;

@property (nonatomic,strong)dispatch_queue_t recentChatDataManagerQueue;

@end

@implementation GJGCRecentChatDataManager

- (instancetype)init
{
    if (self = [super init]) {
        
        if (!self.recentChatDataManagerQueue) {
            self.recentChatDataManagerQueue = dispatch_queue_create("gjgc_recent_chat_queue", DISPATCH_QUEUE_SERIAL);
        }
        
        self.sourceArray = [[NSMutableArray alloc]init];
        
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:self.recentChatDataManagerQueue];
        
        [GJCFNotificationCenter addObserver:self selector:@selector(observeLoginSuccess:) name:ZYUserCenterLoginEaseMobSuccessNoti object:nil];

    }
    return self;
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
    [GJCFNotificationCenter removeObserver:self];
}

- (NSInteger)totalCount
{
    return self.sourceArray.count;
}

- (GJGCRecentChatModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.sourceArray objectAtIndex:indexPath.row];
}

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (void)loadRecentConversations
{
    if ([[ZYUserCenter shareCenter] isLogin]) {
        
       [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
        
    }
}

- (GJGCMessageExtendUserModel *)userInfoFromMessage:(EMMessage *)theMessage
{
    //根据扩展消息结构体进一步解析
    GJGCMessageExtendModel *extendModel = [[GJGCMessageExtendModel alloc]initWithDictionary:theMessage.ext];

    return extendModel.userInfo;
}

- (GJGCMessageExtendGroupModel *)groupInfoFromMessage:(EMMessage *)theMessage
{
    //根据扩展消息结构体进一步解析
    GJGCMessageExtendModel *extendModel = [[GJGCMessageExtendModel alloc]initWithDictionary:theMessage.ext];
    
    return extendModel.groupInfo;
}

- (NSString *)displayContentFromMessageBody:(EMMessage *)theMessage
{
    NSArray *bodies = theMessage.messageBodies;
    
    id<IEMMessageBody> messageBody = [bodies firstObject];
    
    MessageBodyType bodyType = [messageBody messageBodyType];
    
    NSString *resultString = nil;
    switch (bodyType) {
        case eMessageBodyType_Text:
        {
            //根据扩展消息结构体进一步解析
            GJGCMessageExtendModel *extendModel = [[GJGCMessageExtendModel alloc]initWithDictionary:[messageBody message].ext];
            
            //普通文本消息
            if (!extendModel.isExtendMessageContent) {
                EMTextMessageBody *textBody = (EMTextMessageBody *)messageBody;
                
                resultString = textBody.text;
            }
            
            //扩展消息类型
            if (extendModel.isExtendMessageContent) {
                
                resultString = extendModel.displayText;
            }
            
        }
            break;
        case eMessageBodyType_Voice:
        {
            EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)messageBody;
            
            resultString = voiceBody.displayName;
        }
            break;
        case eMessageBodyType_Image:
        {
            EMImageMessageBody *voiceBody = (EMImageMessageBody *)messageBody;
            
            resultString = voiceBody.displayName;
        }
            break;
        default:
            break;
    }
    
    return resultString;
}

- (void)observeLoginSuccess:(NSNotification *)noti
{
    GJGCRecentChatConnectState state = [[(NSDictionary *)noti.object objectForKey:@"state"]integerValue];
    
    [self.delegate dataManager:self requireUpdateTitleViewState:state];
    
    if (state == GJGCRecentChatConnectStateSuccess) {
        
        [self loadRecentConversations];

    }
}

#pragma mark - 环信监听会话生成的回调

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self updateConversationList:conversationList];
}

#pragma mark - 环信监听链接服务器状态

- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateConnecting];
}

- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    GJGCRecentChatConnectState resultState = error? GJGCRecentChatConnectStateFaild:GJGCRecentChatConnectStateSuccess;
    [self.delegate dataManager:self requireUpdateTitleViewState:resultState];
}

- (void)willAutoReconnect
{
    [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateConnecting];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    GJGCRecentChatConnectState resultState = error? GJGCRecentChatConnectStateFaild:GJGCRecentChatConnectStateSuccess;
    [self.delegate dataManager:self requireUpdateTitleViewState:resultState];
}

- (void)didLogoffWithError:(EMError *)error
{
    
}

- (void)didLoginFromOtherDevice
{
    
}

#pragma mark - 监听会话未读数的变化

- (void)didUnreadMessagesCountChanged
{
    NSArray *converstaionList = [[EaseMob sharedInstance].chatManager conversations];
    [self updateConversationList:converstaionList];
}

- (void)updateConversationList:(NSArray *)conversationList
{
    //重新载入一次会话列表
    if (self.sourceArray.count > 0) {
        [self.sourceArray removeAllObjects];
    }
    
    //按最后一条消息排序
    NSArray *sortConversationList = [conversationList sortedArrayUsingComparator:^NSComparisonResult(EMConversation *obj1, EMConversation *obj2) {
        
        NSComparisonResult result = obj1.latestMessage.timestamp > obj2.latestMessage.timestamp? NSOrderedAscending:NSOrderedDescending;
        
        return result;
        
    }];
    
    for (EMConversation *conversation in sortConversationList) {
        
        GJGCRecentChatModel *chatModel = [[GJGCRecentChatModel alloc]init];
        chatModel.toId = conversation.chatter;
        
        if (conversation.conversationType == eConversationTypeGroupChat && conversation.latestMessage) {
            
            GJGCMessageExtendGroupModel *groupInfo = [self groupInfoFromMessage:conversation.latestMessage];
            
            if (groupInfo&&[groupInfo toDictionary].count > 0) {
                chatModel.name = [GJGCRecentChatStyle formateName:groupInfo.groupName];
                chatModel.headUrl = groupInfo.groupHeadThumb;
            }else{
                chatModel.name = [GJGCRecentChatStyle formateName:conversation.chatter];
            }
            
            GJGCMessageExtendUserModel *userInfo = [self userInfoFromMessage:conversation.latestMessage];
          
            chatModel.groupInfo = groupInfo;
            chatModel.isGroupChat = YES;
            chatModel.unReadCount = conversation.unreadMessagesCount;
            NSString *displayContent = [self displayContentFromMessageBody:conversation.latestMessage];
            chatModel.content = [NSString stringWithFormat:@"%@:%@",userInfo.nickName,displayContent];
            chatModel.time = [GJGCRecentChatStyle formateTime:conversation.latestMessage.timestamp/1000];
            [GJGCChatFriendCellStyle formateSimpleTextMessage:chatModel.content];
        }
        
        if (conversation.conversationType == eConversationTypeChat && conversation.latestMessage) {
            
            chatModel.isGroupChat = NO;
            GJGCMessageExtendUserModel *userInfo = [self userInfoFromMessage:conversation.latestMessage];
            chatModel.name = [GJGCRecentChatStyle formateName:userInfo.nickName];
            chatModel.headUrl = userInfo.headThumb;
            chatModel.unReadCount = conversation.unreadMessagesCount;
            chatModel.content = [self displayContentFromMessageBody:conversation.latestMessage];
            chatModel.time = [GJGCRecentChatStyle formateTime:conversation.latestMessage.timestamp/1000];
            [GJGCChatFriendCellStyle formateSimpleTextMessage:chatModel.content];
        }
        
        chatModel.conversation = conversation;
        
        [self.sourceArray addObject:chatModel];
    }
    
    [self.delegate dataManagerRequireRefresh:self];
}

#pragma mark - 监听网络变化，尝试重新登录

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        
        if (![[EaseMob sharedInstance].chatManager isLoggedIn]) {
            
            [[ZYUserCenter shareCenter] autoLogin];
        }
    }
}

@end
