//
//  GJGCPublicGroupListViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCPublicGroupListViewController.h"
#import "GJGCCreateGroupViewController.h"
#import "GJGCGroupInformationViewController.h"

@interface GJGCPublicGroupListViewController ()

@end

@implementation GJGCPublicGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.listTable setResourceType:ZYResourceTypeSquare];
    
    [self setStrNavTitle:@"广场"];

    [self setRightButtonWithTitle:@"创建群组"];    
}

- (void)rightButtonPressed:(UIButton *)sender
{
    GJGCCreateGroupViewController *createVC = [[GJGCCreateGroupViewController alloc]init];
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)initDataManager
{
    self.dataManager = [[GJGCPulicGroupListDataManager alloc]init];
    self.dataManager.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GJGCInfoBaseListContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    GJGCGroupInformationViewController *groupInfoVC = [[GJGCGroupInformationViewController alloc]initWithGroupId:contentModel.groupId];
    
    [self.navigationController pushViewController:groupInfoVC animated:YES];
}

@end
