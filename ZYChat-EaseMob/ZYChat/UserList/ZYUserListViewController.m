//
//  ZYUserListViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYUserListViewController.h"
#import "ZYUserListDataManager.h"
#import "GJGCChatFriendViewController.h"

@interface ZYUserListViewController ()<UITableViewDataSource,UITableViewDelegate,ZYUserListDataManagerDelegate>

@property (nonatomic,strong)ZYUserListDataManager *dataManager;

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ZYUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [[ZYUserListDataManager alloc]init];
    self.dataManager.delegate = self;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.gjcf_width = GJCFSystemScreenWidth;
    self.tableView.gjcf_height = GJCFSystemScreenHeight - 64.f;
    [self.view addSubview:self.tableView];
    
    if ([ZYUserCenter shareCenter].isLogin) {
        [self.dataManager requestUserList];
    }
}

- (void)rightBarItemAction
{
    
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
