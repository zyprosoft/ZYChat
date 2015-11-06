//
//  ZYUserListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "ZYUserListViewController.h"
#import "ZYUserListDataManager.h"

@interface ZYUserListViewController ()<ZYUserListDataManagerDelegate>

@property (nonatomic,strong)ZYUserListDataManager *dataManager;

@end

@implementation ZYUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [[ZYUserListDataManager alloc]init];
    self.dataManager.delegate = self;

    [self.dataManager requestUserList];
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
    cell.textLabel.text = contentModel.nickname;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

#pragma mark - DataManager Delegate

- (void)dataManagerRequireRefresh:(ZYUserListDataManager *)dataManager
{
    [self.tableView reloadData];
}

@end
