//
//  GJGCInfoBaseListViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCInfoBaseListViewController.h"
#import "GJGCInfoBaseListContentModel.h"
#import "GJGCInfoBaseListBaseCell.h"

@interface GJGCInfoBaseListViewController ()

@property (nonatomic,strong)GJGCRefreshHeaderView *refreshHeader;

@property (nonatomic,strong)GJGCRefreshFooterView *refreshFooter;

@end

@implementation GJGCInfoBaseListViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initDataManager];
    }
    return self;
}

- (void)initDataManager
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    
    self.listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GJCFSystemScreenWidth, GJCFSystemScreenHeight  - self.contentOriginY - self.tabBarController.tabBar.gjcf_height) style:UITableViewStylePlain];
    self.listTable.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTable.dataSource = self;
    self.listTable.delegate = self;
    self.listTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.listTable];
    
    //refresh Header
    self.refreshHeader = [[GJGCRefreshHeaderView alloc]init];
    self.refreshHeader.delegate = self;
    [self.listTable addSubview:self.refreshHeader];
    
    //refreshFooter
    self.refreshFooter = [[GJGCRefreshFooterView alloc]init];
    self.refreshFooter.delegate = self;
    [self.listTable addSubview:self.refreshFooter];
    [self.refreshFooter resetFrameWithTableView:self.listTable];
    
    [self.refreshHeader startLoadingForScrollView:self.listTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataManager.totalCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self.dataManager cellIdentifierAtIndexPath:indexPath];
    
    GJGCInfoBaseListBaseCell *cell = (GJGCInfoBaseListBaseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Class cellClass = [self.dataManager cellClassAtIndexPath:indexPath];

    if (!cell) {
        
        cell = [(GJGCInfoBaseListBaseCell *)[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell setContentModel:[self.dataManager contentModelAtIndexPath:indexPath]];
    [cell downloadImageWithContentModel:[self.dataManager contentModelAtIndexPath:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataManager contentHeightAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}

- (void)dataManagerRequireRefresh:(GJGCInfoBaseListDataManager *)dataManager
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self stopRefresh];
        [self stopLoadMore];
        
        [self.listTable reloadData];
        
        //清除加载更多
        if (self.dataManager.totalCount == 0 || self.dataManager.isReachFinish) {
            [self.refreshFooter removeFromSuperview];
            self.refreshFooter = nil;
        }else{
            if (!self.refreshFooter) {
                self.refreshFooter = [[GJGCRefreshFooterView alloc]init];
                self.refreshFooter.delegate = self;
                [self.listTable addSubview:self.refreshFooter];
            }
            [self.refreshFooter resetFrameWithTableView:self.listTable];
        }
        
    });

}

#pragma mark - refreshHeaderDelegate

- (void)refreshHeaderViewTriggerRefresh:(GJGCRefreshHeaderView *)headerView
{
    [self.dataManager refresh];
}

#pragma mark - refreshFooterDelegate

- (void)refreshFooterViewDidTriggerLoadMore:(GJGCRefreshFooterView *)footerView
{
    [self.dataManager loadMore];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.refreshHeader scrollViewWillBeginDragging:scrollView];
    
    if (!self.dataManager.isReachFinish) {
        [self.refreshFooter scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshHeader scrollViewDidScroll:scrollView];
    if (!self.dataManager.isReachFinish) {
        [self.refreshFooter scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeader scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!self.dataManager.isReachFinish) {
        [self.refreshFooter scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)stopRefresh
{
    [self.refreshHeader stopLoadingForScrollView:self.listTable];
}

- (void)stopLoadMore
{
    [self.refreshFooter stopLoadingForScrollView:self.listTable];
}

- (void)startRefresh
{
    [self.refreshHeader startLoadingForScrollView:self.listTable];
}

- (void)startLoadMore
{
    [self.refreshFooter startLoadingForScrollView:self.listTable];
}

@end
