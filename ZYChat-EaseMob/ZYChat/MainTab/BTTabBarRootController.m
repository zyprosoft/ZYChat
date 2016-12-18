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
#import "GJGCContactsViewController.h"
#import "ZYNavigationController.h"

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
    ZYNavigationController *homeNav = [[ZYNavigationController alloc]initWithRootViewController:homeVC];
    homeNav.type = ZYResourceTypeRecent;

    //我的
    GJGCPublicGroupListViewController *groupListVC = [[GJGCPublicGroupListViewController alloc]init];
    groupListVC.isMainMoudle = YES;
    ZYNavigationController *groupListNav = [[ZYNavigationController alloc]initWithRootViewController:groupListVC];
    groupListNav.type = ZYResourceTypeSquare;

    //我的
    GJGCContactsViewController *myCenter = [[GJGCContactsViewController alloc]init];
    myCenter.isMainMoudle = YES;
    ZYNavigationController *myCenterNav = [[ZYNavigationController alloc]initWithRootViewController:myCenter];
    myCenterNav.type = ZYResourceTypeHome;

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

- (void)pushChatVC:(GJGCBaseViewController *)viewController
{
    [self selectAtIndex:0 thenPushVC:viewController];
}

- (void)selectAtIndex:(NSInteger)index thenPushVC:(GJGCBaseViewController *)viewController
{
    [self setSelectedViewController:[self.viewControllers firstObject]];
    self.selectedIndex = index;
    self.customTabBar.selectedIndex = index;
    UINavigationController *nav = [self.viewControllers objectAtIndex:index];
    [nav pushViewController:viewController animated:YES];
}

#pragma mark - 自定义TabBar 数据元

- (NSArray *)customTabBarSourceItems:(BTCustomTabBar *)tabBar
{
    return @[
             
             @{
                 @"normal":@"icon_msg_normal",
                 @"selected":@"icon_msg_selected",
              },
             @{
                 @"normal":@"icon_square",
                 @"selected":@"icon_square",
                 },
             @{
                 @"normal":@"icon_home",
                 @"selected":@"icon_home",
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
