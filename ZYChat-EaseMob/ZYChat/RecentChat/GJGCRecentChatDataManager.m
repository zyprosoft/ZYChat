//
//  GJGCRecentChatDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCRecentChatDataManager.h"
#import "GJGCRecentChatStyle.h"

@interface GJGCRecentChatDataManager ()<EMChatManagerChatDelegate>

@property (nonatomic,strong)NSMutableArray *sourceArray;

@end

@implementation GJGCRecentChatDataManager

- (instancetype)init
{
    if (self = [super init]) {
        
        self.sourceArray = [[NSMutableArray alloc]init];
        
        [GJCFNotificationCenter addObserver:self selector:@selector(observeLoginSuccess:) name:ZYUserCenterLoginEaseMobSuccessNoti object:nil];

    }
    return self;
}

- (void)dealloc
{
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
        
       NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
        
        for (EMConversation *conversation in conversations) {
            
            GJGCRecentChatModel *chatModel = [[GJGCRecentChatModel alloc]init];
            chatModel.name = [GJGCRecentChatStyle formateName:conversation.chatter];
            chatModel.toId = conversation.chatter;
            chatModel.headUrl = @"";
            chatModel.content = [GJGCRecentChatStyle formateContent:[self displayContentFromMessageBody:conversation.latestMessage]];
            chatModel.conversation = conversation;
            
            [self.sourceArray addObject:chatModel];
        }
        
        [self.delegate dataManagerRequireRefresh:self];
    }
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
            EMTextMessageBody *textBody = (EMTextMessageBody *)messageBody;
            
            resultString = textBody.text;
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
    [self loadRecentConversations];
}


@end
