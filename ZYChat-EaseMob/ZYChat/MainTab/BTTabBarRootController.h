//
//  BTTabBarRootController.h
//  BabyTrip
//
//  Created by ZYVincent on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTTabBarRootController : UITabBarController

- (void)hiddenTabBar;

- (void)showTabBar;

- (NSArray *)recentConversations;

- (void)pushChatVC:(GJGCBaseViewController *)viewController;

- (void)selectAtIndex:(NSInteger)index thenPushVC:(GJGCBaseViewController *)viewController;

@end
