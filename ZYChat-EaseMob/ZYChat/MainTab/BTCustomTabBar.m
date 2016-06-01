//
//  BTCustomTabBar.m
//  BabyTrip
//
//  Created by ZYVincent on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "BTCustomTabBar.h"

#define BTCustomTabBarItemBaseTag 998789

@interface BTCustomTabBar ()<BTCustomTabBarItemDelegate,EMChatManagerDelegate>

@property (nonatomic,strong)UIImageView *topSeprateLine;

@property (nonatomic,strong)UILabel *redTipLabel;


@end

@implementation BTCustomTabBar

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(id<BTCustomTabBarDelegate>)aDelegate
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.delegate = aDelegate;
        
        self.redTipLabel = [[UILabel alloc]init];
        self.redTipLabel.gjcf_size = (CGSize){24,24};
        self.redTipLabel.backgroundColor = [UIColor redColor];
        self.redTipLabel.layer.cornerRadius = self.redTipLabel.gjcf_width/2.f;
        self.redTipLabel.textColor = [UIColor whiteColor];
        self.redTipLabel.font = [UIFont systemFontOfSize:13.f];
        self.redTipLabel.textAlignment = NSTextAlignmentCenter;
        self.redTipLabel.layer.masksToBounds = YES;
        [self addSubview:self.redTipLabel];
        
        [self setupSubViews];
        
        self.topSeprateLine = [[UIImageView alloc]init];
        self.topSeprateLine.gjcf_width = GJCFSystemScreenWidth;
        self.topSeprateLine.gjcf_height = 0.5f;
        self.topSeprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self addSubview:self.topSeprateLine];
        
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        
        [self refreshUnReadCount];
        
        if (self.selectedIndex == 0) {
            self.redTipLabel.hidden = YES;
        }
    }
    
    return self;
}

- (void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
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
            [self bringSubviewToFront:self.redTipLabel];
            self.redTipLabel.center = barItem.center;
            self.redTipLabel.gjcf_centerX += 12.f;
            self.redTipLabel.gjcf_centerY -= 12.f;
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
    
    if (self.selectedIndex != 0) {
        [self refreshUnReadCount];
    }else{
        self.redTipLabel.hidden = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customTabBar:didChoosedIndex:)]) {
        
        [self.delegate customTabBar:self didChoosedIndex:self.selectedIndex];
    }
}

#pragma mark - 未读数更新

- (void)didUnreadMessagesCountChanged
{
    if (self.selectedIndex != 0) {
        
        [self refreshUnReadCount];

    }else{
        
        self.redTipLabel.hidden = YES;
    }
}

- (void)refreshUnReadCount
{
    NSUInteger count = [self unreadCount];
    
    if (count > 99) {
        count = 99;
    }
    
    if (count > 0) {
        
        self.redTipLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        
        self.redTipLabel.hidden = NO;
        
    }else{
        
        self.redTipLabel.hidden = YES;
    }
}

- (NSUInteger)unreadCount {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    return unreadCount;
}

@end
