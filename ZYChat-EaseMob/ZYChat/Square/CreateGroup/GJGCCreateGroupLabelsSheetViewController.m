//
//  GJGCCreateGroupLabelsSheetViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCCreateGroupLabelsSheetViewController.h"
#import "GJGCCreateGroupLabelsSheetDataManager.h"

@interface GJGCCreateGroupLabelsSheetViewController ()

@end

@implementation GJGCCreateGroupLabelsSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataManager
{
    self.dataManager = [[GJGCCreateGroupLabelsSheetDataManager alloc]init];
    self.dataManager.delegate = self;
}

@end
