//
//  ZYUserListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "ZYUserListViewController.h"
#import "ZYUserListDataManager.h"
#import "ZYLoginViewController.h"
#import "GJGCChatFriendViewController.h"

@interface ZYUserListViewController ()<ZYUserListDataManagerDelegate>

@property (nonatomic,strong)ZYUserListDataManager *dataManager;

@end

@implementation ZYUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [[ZYUserListDataManager alloc]init];
    self.dataManager.delegate = self;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if ([ZYUserCenter shareCenter].isLogin) {
        [self.dataManager requestUserList];
    }
}

- (void)rightBarItemAction
{
    ZYLoginViewController *loginVC = [[ZYLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataManager.totalCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    ZYUserListContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:contentModel.headThumb]];
    cell.textLabel.text = contentModel.mobile;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYUserListContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    GJGCChatFriendTalkModel *talkModel = [[GJGCChatFriendTalkModel alloc]init];
    talkModel.toUserName = contentModel.nickname;
    talkModel.toId = contentModel.mobile;
    
    GJGCChatFriendViewController *chatVC = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talkModel];
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - DataManager Delegate

- (void)dataManagerRequireRefresh:(ZYUserListDataManager *)dataManager
{
    [self.tableView reloadData];
}

@end
