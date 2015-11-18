//
//  UIViewController.h
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCBaseViewController : UIViewController

- (void)leftButtonPressed:(UIButton *)sender;

- (void)rightButtonPressed:(UIButton *)sender;

- (void)setStrNavTitle:(NSString *)title;

/**
 *  创建右边按钮没有图片
 *
 *  @param title 设置右边按钮的title
 */
- (void)setRightButtonWithTitle:(NSString *)title;

- (void)setRightButtonWithStateImage:(NSString *)iconName stateHighlightedImage:(NSString *)highlightIconName stateDisabledImage:(NSString *)disableIconName titleName:(NSString *)title;

/**
 *  向导航栏右边添加一个item,在原来的项的右边还是左边
 *
 *  @param button
 *  @param state
 */
- (void)appendRightBarItemWithCustomButton:(UIButton *)button toOldLeft:(BOOL)state;

@end
