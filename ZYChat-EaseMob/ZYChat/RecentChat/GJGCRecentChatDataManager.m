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


#define GJGCRecentConversationNicknameListUDF @"GJGCRecentConversationNicknameListUDF"

#define GJGCRecentConversationHeadListUDF @"GJGCRecentConversationHeadListUDF"

@interface GJGCRecentChatDataManager ()<EMChatManagerDelegate>

@property (nonatomic,strong)NSMutableArray *sourceArray;

@property (nonatomic,strong)dispatch_queue_t recentChatDataManagerQueue;

@property (nonatomic,strong)dispatch_source_t updateListSource;

@end

@implementation GJGCRecentChatDataManager

- (instancetype)init
{
    if (self = [super init]) {
        
        if (!self.recentChatDataManagerQueue) {
            self.recentChatDataManagerQueue = dispatch_queue_create("gjgc_recent_chat_queue", DISPATCH_QUEUE_SERIAL);
        }
        
        //缓冲更新队列
        self.updateListSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_event_handler(self.updateListSource, ^{
            
            [self conversationListUpdate];
            
        });
        dispatch_resume(self.updateListSource);
        
        self.sourceArray = [[NSMutableArray alloc]init];
        
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:self.recentChatDataManagerQueue];
        
        [GJCFNotificationCenter addObserver:self selector:@selector(observeLoginSuccess:) name:ZYUserCenterLoginEaseMobSuccessNoti object:nil];

    }
    return self;
}

- (void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    [GJCFNotificationCenter removeObserver:self];
}

- (NSArray *)allConversationModels
{
    return self.sourceArray;
}

- (NSInteger)totalCount
{
    return self.sourceArray.count;
}

- (GJGCRecentChatModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row > self.sourceArray.count - 1) {
        return nil;
    }
    return [self.sourceArray objectAtIndex:indexPath.row];
}

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (void)deleteConversationAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCRecentChatModel *chatModel = [self contentModelAtIndexPath:indexPath];
    [[EMClient sharedClient].chatManager deleteConversation:chatModel.toId deleteMessages:YES];
    
    [self.sourceArray removeObject:chatModel];

    [self.delegate dataManagerRequireRefresh:self requireDeletePaths:@[indexPath]];
}

- (void)loadRecentConversations
{
    if ([[ZYUserCenter shareCenter] isLogin]) {
        
       [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        [self didUnreadMessagesCountChanged];
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
    
    EMMessageBody *messageBody = theMessage.body;
    
    EMMessageBodyType bodyType = messageBody.type;
    
    NSString *resultString = nil;
    switch (bodyType) {
        case EMMessageBodyTypeText:
        {
            //根据扩展消息结构体进一步解析
            GJGCMessageExtendModel *extendModel = [[GJGCMessageExtendModel alloc]initWithDictionary:theMessage.ext];
            
            //普通文本消息
            if (!extendModel.isExtendMessageContent || !extendModel) {
                EMTextMessageBody *textBody = (EMTextMessageBody *)messageBody;
                
                resultString = textBody.text;
            }
            
            //扩展消息类型
            if (extendModel.isExtendMessageContent && extendModel) {
                
                resultString = extendModel.displayText;
            }
            
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)messageBody;
            
            resultString = voiceBody.displayName;
        }
            break;
        case EMMessageBodyTypeImage:
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
    if (conversationList.count > 0) {
        [self updateConversationList:conversationList];
    }
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
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    if (self.sourceArray.count == 0 && conversations.count == 0) {
        return;
    }
    
    [self updateConversationList:conversations];
}

- (void)updateConversationList:(NSArray *)conversationList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (conversationList.count == 0) {
            return;
        }
        
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
            chatModel.toId = conversation.conversationId;
            
            if (conversation.type == EMConversationTypeGroupChat) {
                
                EMMessage *lastMessage = conversation.latestMessage;
                
                GJGCMessageExtendGroupModel *groupInfo = [self groupInfoFromMessage:lastMessage];
                
                if (lastMessage && groupInfo && [groupInfo toDictionary].count > 0) {
                    chatModel.name = [GJGCRecentChatStyle formateName:groupInfo.groupName];
                    chatModel.headUrl = groupInfo.groupHeadThumb;
                    chatModel.groupInfo = groupInfo;
                    
                }else{
                    chatModel.name = [GJGCRecentChatStyle formateName:conversation.conversationId];
                    chatModel.headUrl = @"";
                }
                
                GJGCMessageExtendUserModel *userInfo = [self userInfoFromMessage:conversation.latestMessage];
                NSString *displayContent = [self displayContentFromMessageBody:conversation.latestMessage];
                chatModel.content = [NSString stringWithFormat:@"%@:%@",userInfo.nickName,displayContent];
                chatModel.time = [GJGCRecentChatStyle formateTime:conversation.latestMessage.timestamp/1000];
                [GJGCChatFriendCellStyle formateSimpleTextMessage:chatModel.content];
                
                chatModel.isGroupChat = YES;
                chatModel.unReadCount = conversation.unreadMessagesCount;
            }
            
            if (conversation.type == EMConversationTypeChat) {
                
                //对方的最近一条消息
                EMMessage *lastMessage = conversation.latestMessageFromOthers;
                
                if (lastMessage) {
                    
                    GJGCMessageExtendUserModel *userInfo = [self userInfoFromMessage:lastMessage];
                    chatModel.name = [GJGCRecentChatStyle formateName:userInfo.nickName];
                    chatModel.headUrl = userInfo.headThumb;
                    
                }else{
                    
                    chatModel.name = [GJGCRecentChatStyle formateName:conversation.conversationId];
                    chatModel.headUrl = @"";
                }
                
                chatModel.unReadCount = conversation.unreadMessagesCount;
                chatModel.isGroupChat = NO;
                
                if (conversation.latestMessage) {
                    chatModel.content = [self displayContentFromMessageBody:conversation.latestMessage];
                    chatModel.time = [GJGCRecentChatStyle formateTime:conversation.latestMessage.timestamp/1000];
                    [GJGCChatFriendCellStyle formateSimpleTextMessage:chatModel.content];
                }
            }
            
            chatModel.conversation = conversation;
            
            [self.sourceArray addObject:chatModel];
        }

        dispatch_source_merge_data(self.updateListSource, 1);
        
    });
}

- (void)conversationListUpdate
{
    [self.delegate dataManagerRequireRefresh:self];
}

- (void)saveUser:(NSString *)userId nickname:(NSString *)nickname headUrl:(NSString *)headUrl
{
    
}


#pragma mark - 监听网络变化，尝试重新登录

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        
        if (![[EMClient sharedClient] isLoggedIn]) {
            
            [[ZYUserCenter shareCenter] autoLogin];
        }
    }
}

#pragma mark - 检测会话是否已经存在

+ (BOOL)isConversationHasBeenExist:(NSString *)chatter
{
    NSInteger findIndex = NSNotFound;
    
    for (EMConversation *conversation in [[EMClient sharedClient].chatManager getAllConversations]) {
        
        if ([conversation.conversationId isEqualToString:chatter]) {
            
            findIndex = 1;
            break;
        }
    }
    
    return findIndex == NSNotFound? NO:YES;
}

@end
