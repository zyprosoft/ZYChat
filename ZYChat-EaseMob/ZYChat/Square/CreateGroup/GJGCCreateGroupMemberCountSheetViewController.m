//
//  GJGCCreateGroupMemberCountSheetViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCCreateGroupMemberCountSheetViewController.h"
#import "GJGCCreateGroupMemberCountSheetDataManager.h"

@interface GJGCCreateGroupMemberCountSheetViewController ()

@end

@implementation GJGCCreateGroupMemberCountSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataManager
{
    self.dataManager = [[GJGCCreateGroupMemberCountSheetDataManager alloc]init];
    self.dataManager.delegate = self;
}

@end
