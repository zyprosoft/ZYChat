//
//  BTCustomTabBar.m
//  BabyTrip
//
//  Created by ZYVincent on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "BTCustomTabBar.h"

#define BTCustomTabBarItemBaseTag 998789

@interface BTCustomTabBar ()<BTCustomTabBarItemDelegate>

@property (nonatomic,strong)UIImageView *topSeprateLine;

@property (nonatomic,strong)UIImageView *redTipView;

@end

@implementation BTCustomTabBar

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(id<BTCustomTabBarDelegate>)aDelegate
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.delegate = aDelegate;
        
        [self setupSubViews];
        
        self.topSeprateLine = [[UIImageView alloc]init];
        self.topSeprateLine.gjcf_width = GJCFSystemScreenWidth;
        self.topSeprateLine.gjcf_height = 0.5f;
        self.topSeprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self addSubview:self.topSeprateLine];
        
    }
    
    return self;
}

- (void)dealloc
{
    [GJCFNotificationCenter removeObserver:self];
}

- (void)setupSubViews
{
    NSArray *configData = [self.delegate customTabBarSourceItems:self];
    
    CGFloat itemWidth = GJCFSystemScreenWidth/configData.count;
    CGFloat itemHeight = 49.f;
    
    for (NSInteger index = 0; index < configData.count; index++) {
        
        CGFloat originX = index * itemWidth;
        
        CGFloat originY = 0;
        
        CGRect itemRect = CGRectMake(originX, originY, itemWidth, itemHeight);
        
        NSDictionary *itemDict = [configData objectAtIndex:index];
        UIImage *normalIcon = GJCFQuickImage(itemDict[@"normal"]);
        UIImage *selectedIcon = GJCFQuickImage(itemDict[@"selected"]);
        
        BTCustomTabBarItem *barItem = [[BTCustomTabBarItem alloc]initWithFrame:itemRect];
        barItem.backgroundColor = [UIColor whiteColor];
        barItem.normalIcon = normalIcon;
        barItem.selectedIcon = selectedIcon;
        barItem.tag = BTCustomTabBarItemBaseTag + index;
        barItem.delegate = self;
        
        [self addSubview:barItem];
        
        //默认选中第一个
        if (index == 0) {
            barItem.selected = YES;
            self.selectedIndex = index;
        }
    }
}

#pragma mark - Item Delegate

- (void)customTabBarItemDidTapped:(BTCustomTabBarItem *)item
{
    NSInteger currentIndex = item.tag - BTCustomTabBarItemBaseTag;
    
    BTCustomTabBarItem *barItem = (BTCustomTabBarItem *)[self viewWithTag:BTCustomTabBarItemBaseTag + self.selectedIndex];
    barItem.selected = NO;
    
    self.selectedIndex = currentIndex;
    item.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customTabBar:didChoosedIndex:)]) {
        
        [self.delegate customTabBar:self didChoosedIndex:self.selectedIndex];
    }
}

@end
