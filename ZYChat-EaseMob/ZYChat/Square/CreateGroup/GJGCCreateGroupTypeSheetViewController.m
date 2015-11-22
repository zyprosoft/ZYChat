//
//  GJGCCreateGroupTypeSheetViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCCreateGroupTypeSheetViewController.h"
#import "GJGCCreateGroupTypeSheetDataManager.h"

@interface GJGCCreateGroupTypeSheetViewController ()

@end

@implementation GJGCCreateGroupTypeSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataManager
{
    self.dataManager = [[GJGCCreateGroupTypeSheetDataManager alloc]init];
    self.dataManager.delegate = self;
}
@end
