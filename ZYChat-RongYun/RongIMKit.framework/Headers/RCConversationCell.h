//
//  RCConversationTableCell.h
//  RongIMKit
//
//  Created by xugang on 15/1/24.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RCConversationTableCell
#define __RCConversationTableCell
#import <UIKit/UIKit.h>
#import "RCConversationBaseCell.h"

#import "RCMessageBubbleTipView.h"
#import "RCThemeDefine.h"

#define CONVERSATION_ITEM_HEIGHT 65.0f
@protocol RCConversationCellDelegate;
@class RCloudImageView;

/**
 *  会话Cell子类
 */
@interface RCConversationCell : RCConversationBaseCell

/**
 *  会话Cell 回调
 */
@property(weak, nonatomic) id<RCConversationCellDelegate> delegate;

/**
 *  会话头像背景图
 */
@property(strong, nonatomic) UIView *headerImageViewBackgroundView;

/**
 *  会话头像
 */
@property(strong, nonatomic) RCloudImageView *headerImageView;

/**
 *  会话title
 */
@property(strong, nonatomic) UILabel *conversationTitle;

/**
 *  会话内容label
 */
@property(strong, nonatomic) UILabel *messageContentLabel;

/**
 * 消息创建时间label
 */
@property(strong, nonatomic) UILabel *messageCreatedTimeLabel;

/**
 *  tip number视图
 */
@property(strong, nonatomic) RCMessageBubbleTipView *bubbleTipView;

/**
 *  会话状态视图
 */
@property(strong, nonatomic) UIImageView *conversationStatusImageView;

/**
 *  会话头像样式
 */
@property(nonatomic) RCUserAvatarStyle portraitStyle;

/**
 *  是否通知状态
 */
@property(nonatomic) BOOL enableNotification;

/**
 *  cell 背景颜色
 */
@property(nonatomic) UIColor *cellBackgroundColor;

/**
 *  置顶cell 背景颜色
 */
@property(nonatomic) UIColor *topCellBackgroundColor;

/**
 *  最后一条消息发送状态
 */
@property(strong, nonatomic) UILabel *lastSendMessageStatusLabel;

/**
 *  设置用户头像样式
 *
 *  @param portraitStyle 用户头像样式
 */
- (void)setHeaderImagePortraitStyle:(RCUserAvatarStyle)portraitStyle;

/**
 *  设置会话数据模型
 *
 *  @param model 会话数据模型
 */
- (void)setDataModel:(RCConversationModel *)model;

@end

/**
 *  会话Cell回调
 */
@protocol RCConversationCellDelegate <NSObject>

/**
 *  点击会话头像事件
 *
 *  @param model 会话的model
 */
- (void)didTapCellPortrait:(RCConversationModel *)model;

/**
 *  长按头像事件
 *
 *  @param model 会话的model
 */
- (void)didLongPressCellPortrait:(RCConversationModel *)model;

@end

#endif