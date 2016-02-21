//
//  GJGCInformationBaseViewController.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCBaseViewController.h"
#import "GJGCInformationBaseDataSourceManager.h"
#import "GJGCInformationBaseCell.h"
#import "GJGCInformationBaseCellDelegate.h"

@interface GJGCInformationBaseViewController : GJGCBaseViewController<GJGCInformationBaseCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *informationListTable;

@property (nonatomic,strong)GJGCInformationBaseDataSourceManager *dataSourceManager;

@end
