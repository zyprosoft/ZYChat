//
//  RCTextMessageCell.h
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCMessageCell.h"
#import "RCAttributedLabel.h"

#define Text_Message_Font_Size 16

/**
 *  文本消息Cell
 */
@interface RCTextMessageCell : RCMessageCell<RCAttributedLabelDelegate>

/**
 *  消息显示Label
 */
@property(strong, nonatomic) RCAttributedLabel *textLabel;

/**
 *  消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 *  设置消息数据模型
 *
 *  @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;
@end
