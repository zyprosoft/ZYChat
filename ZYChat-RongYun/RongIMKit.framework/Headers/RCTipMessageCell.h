//
//  RCTipMessageCell.h
//  RongIMKit
//
//  Created by xugang on 15/1/29.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCMessageBaseCell.h"

/**
 *  TipMessageCell
 */
@interface RCTipMessageCell : RCMessageBaseCell

/**
 *  tipMessage显示Label
 */
@property(strong, nonatomic) RCTipLabel *tipMessageLabel;

/**
 *  设置消息数据模型
 *
 *  @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;

@end
