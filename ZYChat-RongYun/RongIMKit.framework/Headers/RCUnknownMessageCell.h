//
//  RCUnknownMessageCell.h
//  RongIMKit
//
//  Created by xugang on 3/31/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#ifndef __RCUnknownMessageCell

#define __RCUnknownMessageCell

#import <RongIMKit/RongIMKit.h>

/**
 *  未知消息Cell
 */
@interface RCUnknownMessageCell : RCMessageBaseCell

/**
 *  消息TipLabel
 */
@property(strong, nonatomic) RCTipLabel *messageLabel;

/**
 *  设置消息数据模型
 *
 *  @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;
@end
#endif