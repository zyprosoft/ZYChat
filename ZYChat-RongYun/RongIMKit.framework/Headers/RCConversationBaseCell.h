//
//  RCConversationBaseTableCell.h
//  RongIMKit
//
//  Created by xugang on 15/1/24.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RCConversationBaseTableCell
#define __RCConversationBaseTableCell
#import <UIKit/UIKit.h>
#import "RCConversationModel.h"

/**
 *  会话Cell基类
 */
@interface RCConversationBaseCell : UITableViewCell

/**
 *  会话数据模型
 */
@property(nonatomic, strong) RCConversationModel *model;

/**
 *  设置会话数据模型
 *
 *  @param model 会话数据模型
 */
- (void)setDataModel:(RCConversationModel *)model;
@end

#endif