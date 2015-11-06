//
//  RCImageMessageCell.h
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCMessageCell.h"
#import "RCImageMessageProgressView.h"

/**
 *  图片消息Cell
 */
@interface RCImageMessageCell : RCMessageCell

/**
 *  发送图片视图
 */
@property(nonatomic, strong) UIImageView *pictureView;

/**
 *  发送进度视图
 */
@property(nonatomic, strong) RCImageMessageProgressView *progressView;

@end
