//
//  GJGCForwardEngine.m
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCForwardEngine.h"
#import "AppDelegate.h"
#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatGroupViewController.h"

@implementation GJGCForwardEngine

+ (BTTabBarRootController *)tabBarVC
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    BTTabBarRootController *barVC = (BTTabBarRootController *)appDelegate.window.rootViewController;
    
    return barVC;
}

+ (void)pushChatWithContactInfo:(GJGCContactsContentModel *)contactModel
{
    
    if (contactModel.isGroupChat) {
       
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:contactModel.groupId type:EMConversationTypeGroupChat createIfNotExist:NO];
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypeGroup;
        talk.toId = contactModel.groupId;
        talk.toUserName = contactModel.groupInfo.groupName;
        talk.conversation = conversation;
        talk.groupInfo = contactModel.groupInfo;
        
        GJGCChatGroupViewController *groupChat = [[GJGCChatGroupViewController alloc]initWithTalkInfo:talk];
        
        [[GJGCForwardEngine tabBarVC] pushChatVC:groupChat];
        
    }else{
        
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:contactModel.userId type:EMConversationTypeChat createIfNotExist:NO];
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypePrivate;
        talk.toId = contactModel.userId;
        talk.toUserName = contactModel.userId;
        talk.conversation = conversation;

        GJGCChatFriendViewController *groupChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
        
        [[GJGCForwardEngine tabBarVC] pushChatVC:groupChat];
    }
}


@end
