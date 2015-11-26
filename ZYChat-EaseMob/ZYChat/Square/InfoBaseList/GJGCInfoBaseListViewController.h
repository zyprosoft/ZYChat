//
//  GJGCInfoBaseListViewController.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCBaseViewController.h"
#import "GJGCInfoBaseListDataManager.h"
#import "GJGCRefreshFooterView.h"
#import "GJGCRefreshHeaderView.h"

@interface GJGCInfoBaseListViewController : GJGCBaseViewController<GJGCInfoBaseListDataManagerDelegate,
    GJGCRefreshFooterViewDelegate,
    GJGCRefreshHeaderViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate
    >

@property (nonatomic,strong)UITableView *listTable;

@property (nonatomic,strong)GJGCInfoBaseListDataManager *dataManager;

- (void)initDataManager;

- (void)startRefresh;

- (void)startLoadMore;

@end
