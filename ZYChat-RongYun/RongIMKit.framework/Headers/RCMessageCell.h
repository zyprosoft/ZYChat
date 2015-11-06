//
//  RCMessageCommonCell.h
//  RongIMKit
//
//  Created by xugang on 15/1/28.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RCMessageCommonCell
#define __RCMessageCommonCell
#import "RCMessageBaseCell.h"

#import "RCThemeDefine.h"
#import "RCMessageCellNotificationModel.h"
#import "RCMessageCellDelegate.h"
#import "RCContentView.h"
//#define PORTRAIT_WIDTH 45
//#define PORTRAIT_HEIGHT 45

@class RCloudImageView;

/**
 *  MessageBaseCell子类，用于创建基本的Cell内容
 */
@interface RCMessageCell : RCMessageBaseCell


/**
 *  用户头像
 */
@property(nonatomic, strong) RCloudImageView *portraitImageView;

/**
 *  用户昵称
 */
@property(nonatomic, strong) UILabel *nicknameLabel;

/**
 *  消息内容视图
 */
@property(nonatomic, strong) RCContentView *messageContentView;

/**
 *  消息状态视图
 */
@property(nonatomic, strong) UIView *statusContentView;

/**
 *  消息发送失败状态视图
 */
@property(nonatomic, strong) UIButton *messageFailedStatusView;

/**
 *  消息发送指示视图
 */
@property(nonatomic, strong) UIActivityIndicatorView *messageActivityIndicatorView;

/**
 *  消息内容视图宽度
 */
@property(nonatomic, readonly) CGFloat messageContentViewWidth;

/**
 *  用户头像样式
 */
@property(nonatomic, assign, setter=setPortraitStyle:) RCUserAvatarStyle portraitStyle;

/**
 *  是否显示用户昵称
 */
@property(nonatomic, readonly) BOOL isDisplayNickname;

/**
 *  消息已读状态视图
 */
@property(nonatomic, strong) UIView *messageHasReadStatusView;

/**
 *  消息发送成功状态视图
 */
@property(nonatomic, strong) UIView *messageSendSuccessStatusView;



/**
 *  设置数据模型
 *
 *  @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;

/**
 *  更新消息发送状态视图
 *
 *  @param model 消息数据模型
 */
- (void)updateStatusContentView:(RCMessageModel *)model;

@end

#endif