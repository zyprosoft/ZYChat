//
//  GJGCMusicPlayViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/25.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMusicPlayViewController.h"
#import "GJGCMusicSearchResultListViewController.h"

@interface GJGCMusicPlayViewController ()<UISearchBarDelegate>

@property (nonatomic,strong)UISearchBar *searchBar;

@end

@implementation GJGCMusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    
    [self setupSearchTitleView];
    
}

- (void)setupSearchTitleView
{
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.gjcf_width = GJCFSystemScreenWidth - 2*40.f;
    self.searchBar.gjcf_height = 36.f;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.placeholder = @"搜索歌曲";
    self.searchBar.delegate = self;
    
    self.searchBar.searchBarStyle = UISearchBarIconResultsList;
    self.navigationItem.titleView = self.searchBar;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    GJGCMusicSearchResultListViewController *resultVC = [[GJGCMusicSearchResultListViewController alloc]init];
    resultVC.title = @"搜索结果";
    resultVC.keyword = searchBar.text;
    
    resultVC.resultBlock = ^(BTActionSheetBaseContentModel *resultModel){
        
    };
    
    [resultVC showFromViewController:self];
}

@end
