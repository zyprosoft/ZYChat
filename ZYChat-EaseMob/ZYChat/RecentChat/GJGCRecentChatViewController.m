//
//  GJGCRecentChatViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCRecentChatViewController.h"
#import "GJGCRecentChatCell.h"
#import "GJGCChatFriendViewController.h"
#import "GJGCChatGroupViewController.h"
#import "GJGCRecentChatDataManager.h"

@interface GJGCRecentChatViewController ()<UITableViewDelegate,UITableViewDataSource,GJGCRecentChatDataManagerDelegate>

@property (nonatomic,strong)GJGCRecentChatDataManager *dataManager;

@property (nonatomic,strong)UITableView *listTable;

@end

@implementation GJGCRecentChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStrNavTitle:@"最近会话"];
    
    self.dataManager = [[GJGCRecentChatDataManager alloc]init];
    self.dataManager.delegate = self;
    
    self.listTable = [[UITableView alloc]init];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    self.listTable.frame = self.view.bounds;
    [self.view addSubview:self.listTable];
    
    [self.dataManager loadRecentConversations];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataManager.totalCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    GJGCRecentChatCell *recentCell = (GJGCRecentChatCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!recentCell) {
        
        recentCell = [[GJGCRecentChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [recentCell setContentModel:[self.dataManager contentModelAtIndexPath:indexPath]];
    
    return recentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataManager contentHeightAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GJGCRecentChatModel *contenModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    if (contenModel.isGroupChat) {
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypeGroup;
        talk.toId = contenModel.toId;
        talk.toUserName = contenModel.name.string;
        
        GJGCChatGroupViewController *groupChat = [[GJGCChatGroupViewController alloc]initWithTalkInfo:talk];
        
        [self.navigationController pushViewController:groupChat animated:YES];
        
        return;
    }
    
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    talk.toId = contenModel.toId;
    talk.toUserName = contenModel.name.string;
    talk.conversation = contenModel.conversation;

    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];

    [self.navigationController pushViewController:privateChat animated:YES];
    
}

#pragma mark - RecentDataManager

- (void)dataManagerRequireRefresh:(GJGCRecentChatDataManager *)dataManager
{
    [self.listTable reloadData];
}



@end
