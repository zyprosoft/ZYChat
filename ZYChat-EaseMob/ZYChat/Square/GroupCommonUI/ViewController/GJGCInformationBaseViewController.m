//
//  GJGCInformationBaseViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationBaseViewController.h"

#import "GJGCInformationTextAndIconCell.h"

@interface GJGCInformationBaseViewController ()

@end

@implementation GJGCInformationBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    
    [self initSubViews];
}

#pragma mark - 内部接口

- (void)initSubViews
{
    self.dataSourceManager = [[GJGCInformationBaseDataSourceManager alloc]init];
    
    self.informationListTable = [[UITableView alloc]init];
    self.informationListTable.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    self.informationListTable.frame = (CGRect){0,0,GJCFSystemScreenWidth,GJCFSystemScreenHeight - GJCFSystemNavigationBarHeight - 64.f};
    self.informationListTable.delegate = self;
    self.informationListTable.dataSource = self;
    self.informationListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.informationListTable];
    
}

#pragma mark - tableView Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceManager totalCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.dataSourceManager contentCellIdentifierAtIndex:indexPath.row];
    
    Class cellClass = [self.dataSourceManager contentCellAtIndex:indexPath.row];
    
    if (!cellClass) {
        
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    GJGCInformationBaseCell *baseCell = (GJGCInformationBaseCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!baseCell) {
        
        baseCell = [(GJGCInformationBaseCell *)[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        baseCell.delegate = self;
    }
    
    [baseCell setContentInformationModel:[self.dataSourceManager contentModelAtIndex:indexPath.row]];
    if ([baseCell isKindOfClass:NSClassFromString(@"GJGCInformationTextAndIconCell")]) {
        GJGCInformationTextAndIconCell *theCell = (GJGCInformationTextAndIconCell*)baseCell;
        __weak typeof(self) weakSelf = self;
        __weak typeof(UITableView*)weakTab = tableView;
        [theCell setTextAndIconCellHeaderClickBlock:^{
            [weakSelf tableView:weakTab didSelectRowAtIndexPath:indexPath];
        }];
    }
    
    return baseCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSourceManager rowHeightAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
