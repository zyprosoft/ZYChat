//
//  RCSettingController.h
//  RongIMKit
//
//  Created by Liv on 15/4/20.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCConversationSettingTableViewController.h"

/**
 *  定义block
 *
 *  @param isSuccess isSuccess description
 */
typedef void (^clearHistory)(BOOL isSuccess);

/**
 *  RCSettingViewController
 */
@interface RCSettingViewController : RCConversationSettingTableViewController

/**
 *  targetId
 */
@property(nonatomic, copy) NSString *targetId;

/**
 *  conversationType
 */
@property(nonatomic, assign) RCConversationType conversationType;

/**
 *  清除历史消息后，会话界面调用roload data
 */
@property(nonatomic, copy) clearHistory clearHistoryCompletion;

/**
 *  默认实现的三个cell
 */
@property(nonatomic, readonly, strong) NSArray *defaultCells;

/**
 *  UIActionSheet
 */
@property(nonatomic, readonly, strong) UIActionSheet *clearMsgHistoryActionSheet;

/**
 *  clearHistoryMessage
 */
- (void)clearHistoryMessage;

/**
 *  override 如果显示headerView时，最后一个+号点击事件
 *
 *  @param settingTableViewHeader  settingTableViewHeader description
 *  @param indexPathOfSelectedItem indexPathOfSelectedItem description
 *  @param users                   所有在headerView中的user
 */
- (void)settingTableViewHeader:(RCConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users;

/**
 *  override 如果显示headerView时，所点击的-号事件
 *
 *  @param indexPath 所点击左上角-号的索引
 */
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath;

@end
