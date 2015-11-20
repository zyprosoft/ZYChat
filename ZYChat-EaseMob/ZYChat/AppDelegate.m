//
//  AppDelegate.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/10.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "GJGCRecentChatViewController.h"
#import "ZYUserListViewController.h"
#import "GJGCPublicGroupListViewController.h"

#define EaseMobAppKey     @"zyprosoft#zychat"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //注册环信
    [[EaseMob sharedInstance]registerSDKWithAppKey:EaseMobAppKey apnsCertName:nil];
    
    GJGCRecentChatViewController *recentVC = [[GJGCRecentChatViewController alloc]init];
    recentVC.title = @"消息";
    
    UINavigationController *nav0 = [[UINavigationController alloc]initWithRootViewController:recentVC];
    UIImage *navigationBarBack = GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], CGSizeMake(GJCFSystemScreenWidth * GJCFScreenScale, 64.f * GJCFScreenScale));
    [nav0.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
    
    //群组广场
    GJGCPublicGroupListViewController *groupListVC = [[GJGCPublicGroupListViewController alloc]init];
    groupListVC.title = @"群组";
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:groupListVC];
    [nav2.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
    
    ZYUserListViewController *userList = [[ZYUserListViewController alloc]init];
    userList.title = @"用户";
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:userList];
    [nav1.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
    
    UITabBarController *tabController = [[UITabBarController alloc]init];
    tabController.viewControllers = @[nav0,nav2,nav1];
    
    self.window.rootViewController = tabController;
    
    [[ZYUserCenter shareCenter]performSelector:@selector(autoLogin) withObject:nil afterDelay:3];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
