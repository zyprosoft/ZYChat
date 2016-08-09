//
//  GJGCContactsViewController.m
//  ZYChat
//
//  Created by ZYVincent on 16/8/8.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCContactsViewController.h"
#import "GJGCContactsDataManager.h"
#import "GJGCContactsBaseCell.h"
#import "GJGCChatFriendViewController.h"
#import "GJGCContactsHeaderView.h"
#import "GJGCForwardEngine.h"

@interface GJGCContactsViewController ()<GJGCContactsDataManagerDelegate,UITableViewDelegate,UITableViewDataSource,GJGCContactsHeaderViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)GJGCContactsDataManager *dataManager;

@end

@implementation GJGCContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的联系人";
    
    self.dataManager = [[GJGCContactsDataManager alloc]init];
    self.dataManager.delegate = self;
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.gjcf_width = GJCFSystemScreenWidth;
    self.tableView.gjcf_height = GJCFSystemScreenHeight - 64.f;
    [self.view addSubview:self.tableView];
    
    [self.dataManager requireContactsList];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.dataManager.totalSection;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    GJGCContactsSectionModel *sectionModel = [self.dataManager sectionModelAtSectionIndex:section];
    return sectionModel.showCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = [self.dataManager cellIdentifierAtIndexPath:indexPath];
    GJGCContactsBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Class cellClass = [self.dataManager cellClassAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GJGCContactsContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    [cell setContentModel:contentModel];
    [cell downloadImageWithConententModel:contentModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataManager contentHeightAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GJGCContactsHeaderView *header = [[GJGCContactsHeaderView alloc]initWithFrame:CGRectMake(0, 0, GJCFSystemScreenWidth, 44)];
    GJGCContactsSectionModel *sectionModel = [self.dataManager sectionModelAtSectionIndex:section];
    header.section = section;
    header.delegate = self;
    [header setTitle:sectionModel.sectionTitle withCount:sectionModel.countString isExpand:sectionModel.isExpand];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCContactsContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    [GJGCForwardEngine pushChatWithContactInfo:contentModel];
}

#pragma mark - DataManager Delegate

- (void)dataManagerrequireRefreshNow
{
    [self.tableView reloadData];
}

- (void)dataManagerRequireRefreshSection:(NSInteger)section
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - HeaderView Delegate

- (void)contactsHeaderViewDidTapped:(GJGCContactsHeaderView *)headerView
{
    [self.dataManager updateSectionIsChangeExpandStateAtSection:headerView.section];
}

@end
