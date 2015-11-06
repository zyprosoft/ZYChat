//
//  RCConversationListViewController.h
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RCConversationListViewController
#define __RCConversationListViewController
#import <UIKit/UIKit.h>
#import "RCConversationModel.h"
#import "RCBaseViewController.h"
#import "RCThemeDefine.h"

@class RCConversationBaseCell;
@class RCNetworkIndicatorView;
/**
 *  RCConversationListViewController
 */
@interface RCConversationListViewController : RCBaseViewController
/**
 *  conversationListDataSource
 */
@property(nonatomic, strong) NSMutableArray *conversationListDataSource;

/**
 *  conversationListTableView
 */
@property(nonatomic, strong) UITableView *conversationListTableView;
/**
 *  show network status view
 */
@property(nonatomic, strong) RCNetworkIndicatorView *networkIndicatorView;
/**
 *  displayConversationTypeArray
 */
@property(nonatomic, strong) NSArray *displayConversationTypeArray;
/**
 *  collectionConversationTypeArray
 */
@property(nonatomic, strong) NSArray *collectionConversationTypeArray;

/**
 *  标记是否进入聚合类型的viewcontroller
 */
@property(nonatomic, assign) BOOL isEnteredToCollectionViewController;

/**
 *  是否显示网络断开时提示
 */
@property(nonatomic, assign) BOOL isShowNetworkIndicatorView;

/**
 *  会话列表为空时的背景视图
 */
@property(nonatomic, strong) UIView *emptyConversationView;

/**
 *  是否在navigatorBar上显示连接中的状态。默认是关闭。
 *  如果开启，请实现setNavigationItemTitleView，当已连接时，用来更新标题.
 */
@property(nonatomic) BOOL showConnectingStatusOnNavigatorBar;

/**
 *  cell 背景颜色
 */
@property(nonatomic) UIColor *cellBackgroundColor;

/**
 *  置顶cell 背景颜色
 */
@property(nonatomic) UIColor *topCellBackgroundColor;

/**
 *  在navigationbar上更新连接状态
 */
- (void)updateConnectionStatusOnNavigatorBar;

/**
 *  在navigationbar上更标题View。如果showConnectingStatusOnNavigatorBar为YES，请实现该方法来设置title
 */
- (void)setNavigationItemTitleView;
/**
 *  init
 *
 *  @param conversationTypeArray1 需要显示的会话类型，NSNumber类型。
 *  @param conversationTypeArray2 需要聚合显示的会话类型，NSNumber类型。
 *
 *  @return conversationList
 */
- (id)initWithDisplayConversationTypes:(NSArray *)conversationTypeArray1
            collectionConversationType:(NSArray *)conversationTypeArray2;

/**
 *  设置需要显示的会话类型
 *
 *  @param conversationTypeArray 会话类型，NSNumber类型。
 */
- (void)setDisplayConversationTypes:(NSArray *)conversationTypeArray;
/**
 *  设置需要聚合显示的会话类型
 *
 *  @param conversationTypeArray 会话类型，NSNumber类型。
 */
- (void)setCollectionConversationType:(NSArray *)conversationTypeArray;

/**
 *  设置头像样式,请在viewDidLoad之前调用
 *
 *  @param avatarStyle avatarStyle
 */
- (void)setConversationAvatarStyle:(RCUserAvatarStyle)avatarStyle;
/**
 *  设置头像大小,请在viewDidLoad之前调用
 *
 *  @param size size
 */
- (void)setConversationPortraitSize:(CGSize)size;

/**
 *  刷新会话列表
 */
- (void)refreshConversationTableViewIfNeeded;

/**
 *  移除默认的空会话列表背景图
 *
 *  该接口已经废弃，在会话为空时 SDK 会自动显示emptyConversationView，app不需要进行处理
 */
- (void)resetConversationListBackgroundViewIfNeeded;

/**
 *  插入自定义会话数据模型到数据源，并且更新tableview
 *
 *  @param conversationModel 会话数据对象
 */
- (void)refreshConversationTableViewWithConversationModel:(RCConversationModel *)conversationModel;

#pragma mark override
/**
 *  表格选中事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath;

#pragma mark override
/**
 *  将要加载table数据
 *
 *  @param dataSource 数据源数组
 *
 *  @return 数据源数组，可以添加自己定义的数据源item
 */
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource;

#pragma mark override
/**
 *  将要显示会话列表单元，可以有限的设置cell的属性或者修改cell,例如：setHeaderImagePortraitStyle
 *
 *  @param cell      cell
 *  @param indexPath 索引
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;
#pragma mark override
/**
 *  重写方法，可以实现开发者自己添加数据model后，返回对应的显示的cell
 *
 *  @param tableView 表格
 *  @param indexPath 索引
 *
 *  @return RCConversationBaseTableCell
 */
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark override
/**
 *  重写方法，可以实现开发者自己添加数据model后，返回对应的显示的cell的高度
 *
 *  @param tableView 表格
 *  @param indexPath 索引
 *
 *  @return 高度
 */
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark override
/**
 *  重写方法，会话删除后的触发事件
 *
 *  @param model 会话model
 */
- (void)didDeleteConversationCell:(RCConversationModel *)model;

/**
 *  重写方法，自定义会话(RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION)删除按钮触发事件
 *
 *  @param tableView    表格
 *  @param editingStyle 编辑样式
 *  @param indexPath    索引
 */
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark override
/**
 *  点击头像事件
 *
 *  @param model 会话model
 */
- (void)didTapCellPortrait:(RCConversationModel *)model;

/**
 *  长按头像事件
 *
 *  @param model 会话model
 */
- (void)didLongPressCellPortrait:(RCConversationModel *)model;

/**
 *  收到新消息,用于刷新会话列表，如果派生类调用了父类方法，请不要再次调用refreshConversationTableViewIfNeeded，避免多次刷新
 *  当收到多条消息时，会在最后一条消息时在内部调用refreshConversationTableViewIfNeeded
 *
 *  @param notification notification
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification;

#pragma mark override
/**
 *  重写方法，通知更新未读消息数目，用于显示未读消息，当收到会话消息的时候，会触发一次。
 */
- (void)notifyUpdateUnreadMessageCount;

@end
#endif