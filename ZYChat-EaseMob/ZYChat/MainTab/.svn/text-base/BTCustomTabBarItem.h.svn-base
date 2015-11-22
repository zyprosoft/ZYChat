//
//  BTCustomTabBarItem.h
//  BabyTrip
//
//  Created by ZYVincent on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTCustomTabBarItem;

@protocol BTCustomTabBarItemDelegate <NSObject>

- (void)customTabBarItemDidTapped:(BTCustomTabBarItem *)item;

@end

@interface BTCustomTabBarItem : UIView

@property (nonatomic,weak)id<BTCustomTabBarItemDelegate> delegate;

@property (nonatomic,strong)UIImage *normalIcon;

@property (nonatomic,strong)UIImage *selectedIcon;

@property (nonatomic,strong)UIColor *normalTextColor;

@property (nonatomic,strong)UIColor *selectedTextColor;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,assign,getter=isSelected)BOOL selected;

@property (nonatomic,assign)CGFloat iconTextMargin;

@property (nonatomic,assign)CGFloat leftMargin;

@end
