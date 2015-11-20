//
//  GJGCPublicGroupListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCPublicGroupListViewController.h"
#import "GJGCCreateGroupViewController.h"

@interface GJGCPublicGroupListViewController ()

@end

@implementation GJGCPublicGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setRightButtonWithTitle:@"创建群组"];
}

- (void)rightButtonPressed:(UIButton *)sender
{
    GJGCCreateGroupViewController *createVC = [[GJGCCreateGroupViewController alloc]init];
    [self.navigationController pushViewController:createVC animated:YES];
}

@end
