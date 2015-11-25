//
//  BTTabBarRootController.m
//  BabyTrip
//
//  Created by ZYVincent on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "BTTabBarRootController.h"
#import "BTCustomTabBar.h"
#import "GJGCRecentChatViewController.h"
#import "GJGCPublicGroupListViewController.h"
#import "GJGCMyHomePageViewController.h"

@interface BTTabBarRootController ()<BTCustomTabBarDelegate>

@property (nonatomic,strong)BTCustomTabBar *customTabBar;

@end

@implementation BTTabBarRootController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *navigationBarBack = GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], CGSizeMake(GJCFSystemScreenWidth * GJCFScreenScale, 64.f * GJCFScreenScale));
    
    //首页
    GJGCRecentChatViewController *homeVC = [[GJGCRecentChatViewController alloc]init];
    homeVC.isMainMoudle = YES;
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [homeNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];

    //我的
    GJGCPublicGroupListViewController *groupListVC = [[GJGCPublicGroupListViewController alloc]init];
    groupListVC.isMainMoudle = YES;
    UINavigationController *groupListNav = [[UINavigationController alloc]initWithRootViewController:groupListVC];
    [groupListNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];

    //我的
    GJGCMyHomePageViewController *myCenter = [[GJGCMyHomePageViewController alloc]init];
    myCenter.isMainMoudle = YES;
    UINavigationController *myCenterNav = [[UINavigationController alloc]initWithRootViewController:myCenter];
    [myCenterNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];

    self.viewControllers = @[
                             homeNav,
                             groupListNav,
                             myCenterNav,
                             ];
    
    //自定义TabBar
    self.customTabBar = [[BTCustomTabBar alloc]initWithFrame:self.tabBar.frame withDataSource:self];
    [self.view addSubview:self.customTabBar];
    self.tabBar.hidden = YES;
}

- (void)hiddenTabBar
{
    [UIView animateWithDuration:0.26 animations:^{
        self.customTabBar.alpha = 0.f;
    }];
}

- (void)showTabBar
{
    [UIView animateWithDuration:0.26 animations:^{
        self.customTabBar.alpha = 1.f;
    }];
}

- (NSArray *)recentConversations
{
    UINavigationController *recentChatNav = [self.viewControllers firstObject];
    GJGCRecentChatViewController *recentVC = [recentChatNav.viewControllers firstObject];
    
    return [recentVC allConversationModels];
}

#pragma mark - 自定义TabBar 数据元

- (NSArray *)customTabBarSourceItems:(BTCustomTabBar *)tabBar
{
    return @[
             
             @{
                 @"normal":@"msg",
                 @"selected":@"msg_selected",
              },
             @{
                 @"normal":@"square",
                 @"selected":@"square_selected",
                 },
             @{
                 @"normal":@"my",
                 @"selected":@"my_selected",
                 },
             ];
}

- (void)customTabBar:(BTCustomTabBar *)tabBar didChoosedIndex:(NSInteger)index
{
    if (self.selectedIndex == index) {
        return;
    }
    self.selectedIndex = index;
}


@end
