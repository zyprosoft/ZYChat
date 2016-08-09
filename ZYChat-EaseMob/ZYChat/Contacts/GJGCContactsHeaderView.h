//
//  GJGCContactsHeaderView.h
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJGCContactsHeaderView;
@protocol GJGCContactsHeaderViewDelegate <NSObject>

- (void)contactsHeaderViewDidTapped:(GJGCContactsHeaderView *)headerView;

@end

@interface GJGCContactsHeaderView : UIView

@property (nonatomic,assign)NSInteger section;

@property (nonatomic,weak)id<GJGCContactsHeaderViewDelegate> delegate;

- (void)setTitle:(NSString *)title withCount:(NSString *)count isExpand:(BOOL)isExpand;

@end
