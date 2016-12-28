//
//  BTCustomTabBar.h
//  BabyTrip
//
//  Created by ZYVincent on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTCustomTabBarItem.h"

@class BTCustomTabBar;

@protocol BTCustomTabBarDelegate <NSObject>

@required

/**
 *  数据源
 *
 *  @param tabBar
 *
 *  @return @[@{@"title":@"",@"normal":@"xxx.png",@"selected":@"",@"normalColor":[UIColor],@"selecedColor":[UIColor]}]
 */
- (NSArray *)customTabBarSourceItems:(BTCustomTabBar *)tabBar;

/**
 *  选中了哪个
 *
 *  @param tabBar
 *  @param index  
 */
- (void)customTabBar:(BTCustomTabBar *)tabBar didChoosedIndex:(NSInteger)index;

@end

@interface BTCustomTabBar : UIView

@property (nonatomic,assign)NSInteger selectedIndex;

@property (nonatomic,weak)id<BTCustomTabBarDelegate> delegate;

@property (nonatomic,strong)UIImageView *backgroundView;

@property (nonatomic,assign)ZYResourceType type;

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(id<BTCustomTabBarDelegate>)aDelegate;

@end
