//
//  AppDelegate.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/10.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "AppDelegate.h"
#import "GJGCRecentChatViewController.h"
#import "GJGCMyHomePageViewController.h"
#import "GJGCPublicGroupListViewController.h"
#import "HALoginViewController.h"
#import "BTTabBarRootController.h"
#import "GJGCChatSystemNotiReciever.h"
#import "GJGCCallDataManager.h"
#import "ZYThemeUitil.h"

#define EaseMobAppKey     @"zyprosoft#zychat"

@interface AppDelegate ()

@property (nonatomic,strong)UINavigationController *loginNav;

@end

@implementation AppDelegate

- (void)logOutAction
{
    if (!self.loginNav) {
        
        HALoginViewController *loginVC = [[HALoginViewController alloc]init];
        loginVC.title = @"王者荣耀－约战";
        
        self.loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        
        UIImage *navigationBarBack = ZYThemeImage(kThemeHomeNavBar);
        [self.loginNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
    }
    if (self.window.rootViewController) {
        self.window.rootViewController = nil;
    }
    self.window.rootViewController = self.loginNav;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@",GJCFAppCacheDirectory);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //注册环信
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobAppKey];
    options.apnsCertName = @"zychat_apns";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] dataMigrationTo3];
    
    HALoginViewController *loginVC = [[HALoginViewController alloc]init];
    loginVC.title = @"iOS码农之家";
    
    self.loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    UIImage *navigationBarBack = ZYThemeImage(kThemeHomeNavBar);
    [self.loginNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
    
    self.window.rootViewController = self.loginNav;
    
    [self.window makeKeyAndVisible];
    
    //观察登录结果
    [GJCFNotificationCenter addObserver:self selector:@selector(observeLoginStatus:) name:ZYUserCenterLoginEaseMobSuccessNoti object:nil];
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)setupTab
{
    BTTabBarRootController *tabBar = [[BTTabBarRootController alloc]init];
    
    self.window.rootViewController = tabBar;
}

- (void)observeLoginStatus:(NSNotification *)noti
{
    NSInteger state = [noti.object[@"state"] integerValue];
    
    if (state == 0) {
        
        BTToast(@"登陆失败");
    }
    
    if (state == 1) {
        
        BTToast(@"登录成功");
        
        //启动系统消息收发
        [[GJGCChatSystemNotiReciever shareReciever] systemAssistConversation];
        
        [GJGCCallDataManager sharedManager];
        
        [self setupTab];
    }
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

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [[EMClient sharedClient] bindDeviceToken:deviceToken];

}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

@end
