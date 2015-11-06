//
//  RCMessageBaseCell.h
//  RongIMKit
//
//  Created by xugang on 15/1/28.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RCMessageBaseCell
#define __RCMessageBaseCell

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>
#import "RCMessageModel.h"
#import "RCMessageCellNotificationModel.h"
#import "RCMessageCellDelegate.h"

/**
 *  消息发送状态通知回调Key
 */
UIKIT_EXTERN NSString *const KNotificationMessageBaseCellUpdateSendingStatus;

#define TIME_LABEL_HEIGHT 20

@class RCCollectionCellAttributes;
@class RCTipLabel;

/**
 *  消息Cell基类
 */
@interface RCMessageBaseCell : UICollectionViewCell

/**
 *  消息回调
 */
@property(nonatomic, weak) id<RCMessageCellDelegate> delegate;

/**
 *   显示时间的Label
 */
@property(strong, nonatomic) RCTipLabel *messageTimeLabel;

/**
 *  消息数据模型
 */
@property(strong, nonatomic) RCMessageModel *model;

/**
 *  父视图区域
 */
@property(strong, nonatomic) UIView *baseContentView;

/**
 *  消息方向
 */
@property(nonatomic) RCMessageDirection messageDirection;

/**
 *  是否显示消息时间
 */
@property(nonatomic, readonly) BOOL isDisplayMessageTime;

/**
 *  是否显示已读状态
 */
@property(nonatomic) BOOL isDisplayReadStatus;

/**
 *  类初始化方法
 *
 *  @param frame cellFrame
 *
 *  @return 当前对象实例
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  设置消息数据模型
 *
 *  @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;

/**
 *  消息发送状态通知
 *
 *  @param notification 通知对象
 */
- (void)messageCellUpdateSendingStatusEvent:(NSNotification *)notification;
@end

#endif