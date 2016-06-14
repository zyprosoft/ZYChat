//
//  GJGCGroupMemberListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCGroupMemberListViewController.h"
#import "GJGCGroupMemberListDataManager.h"
#import "GJGCChatFriendViewController.h"
#import "GJGCRecentChatDataManager.h"

@interface GJGCGroupMemberListViewController ()

@end

@implementation GJGCGroupMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"群成员列表"];

}

- (void)setGroupId:(NSString *)groupId
{
    [(GJGCGroupMemberListDataManager *)self.dataManager setGroupId:groupId];
}

- (NSString *)groupId
{
    return [(GJGCGroupMemberListDataManager *)self.dataManager groupId];
}

- (void)initDataManager
{
    self.dataManager = [[GJGCGroupMemberListDataManager alloc]init];
    self.dataManager.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCInfoBaseListContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    GJGCChatFriendTalkModel *talkModel = [[GJGCChatFriendTalkModel alloc]init];
    talkModel.talkType = GJGCChatFriendTalkTypePrivate;
    talkModel.toId = contentModel.title;
    talkModel.toUserName = contentModel.title;
    
    //如果有会话记录才插入这样一条会话，不然就什么都不做
    if ([GJGCRecentChatDataManager isConversationHasBeenExist:talkModel.conversation.conversationId]) {
        
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:talkModel.conversation.conversationId type:EMConversationTypeChat createIfNotExist:NO];
        talkModel.conversation = conversation;
        
    }
    
    GJGCChatFriendViewController *chatVC = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talkModel];
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
