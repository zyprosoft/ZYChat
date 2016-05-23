//
//  GJGCRecentContactListDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCRecentContactListDataManager.h"
#import "AppDelegate.h"
#import "BTTabBarRootController.h"
#import "GJGCRecentChatModel.h"

@implementation GJGCRecentContactListDataManager

- (void)requestListData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    BTTabBarRootController *tabBarVC = (BTTabBarRootController *)appDelegate.window.rootViewController;
 
    NSArray *allConversationModels = [tabBarVC recentConversations];
    
    for (GJGCRecentChatModel *chatModel in allConversationModels) {
        
        GJGCInfoBaseListContentModel *contentModel = [[GJGCInfoBaseListContentModel alloc]init];
        contentModel.title = chatModel.name.string;
        contentModel.headUrl = chatModel.headUrl;
        contentModel.chatter = chatModel.conversation.conversationId;
        contentModel.conversation = chatModel.conversation;
        
        [self addContentModel:contentModel];
    }
    
    self.isReachFinish = YES;
    self.isRefresh = NO;
    
    [self.delegate dataManagerRequireRefresh:self];
}

@end
