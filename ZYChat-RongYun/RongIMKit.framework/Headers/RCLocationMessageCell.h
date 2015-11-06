//
//  RCLocationMessageCell.h
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCMessageCell.h"
#import "RCImageMessageProgressView.h"

/**
 *  位置消息Cell
 */
@interface RCLocationMessageCell : RCMessageCell

/**
 *  位置图片
 */
@property(nonatomic, strong) UIImageView *pictureView;

/**
 *  位置内容Label
 */
@property(nonatomic, strong) UILabel *locationNameLabel;

@end
