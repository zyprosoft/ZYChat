//
//  GJGCAppWallAreaSheetViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/26.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCAppWallAreaSheetViewController.h"
#import "GJGCAppWallAreaSheetDataManager.h"

@interface GJGCAppWallAreaSheetViewController ()

@end

@implementation GJGCAppWallAreaSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataManager
{
    self.dataManager = [[GJGCAppWallAreaSheetDataManager alloc]init];
    self.dataManager.delegate = self;
}

@end
