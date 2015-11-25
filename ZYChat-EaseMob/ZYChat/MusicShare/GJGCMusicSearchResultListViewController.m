//
//  GJGCMusicSearchResultListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/25.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMusicSearchResultListViewController.h"
#import "GJGCMusicSearchResultListDataManager.h"

@interface GJGCMusicSearchResultListViewController ()

@end

@implementation GJGCMusicSearchResultListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataManager
{
    self.dataManager = [[GJGCMusicSearchResultListDataManager alloc]init];
    self.dataManager.delegate = self;
}

- (void)setKeyword:(NSString *)keyword
{
    [(GJGCMusicSearchResultListDataManager *)self.dataManager setKeyword:keyword];
}

- (NSString *)keyword
{
    return [(GJGCMusicSearchResultListDataManager *)self.dataManager keyword];
}

@end
