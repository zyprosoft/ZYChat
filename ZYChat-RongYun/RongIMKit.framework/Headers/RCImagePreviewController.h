//
//  PreviewViewController.h
//  RCIM
//
//  Created by Heq.Shinoda on 14-5-27.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCBaseViewController.h"

@class RCImageMessageProgressView;
@class RCMessageModel;

/**
 *  RCImagePreviewController
 */
@interface RCImagePreviewController : RCBaseViewController

/**
 *  原始图片视图
 */
@property(nonatomic, strong) UIImageView *originalImageView;

/**
 *  message数据模型
 */
@property(nonatomic, strong) RCMessageModel *messageModel;

/**
 *  message 图片进图视图
 */
@property(nonatomic, strong) RCImageMessageProgressView *rcImageProressView;

/**
 *  如果自定义导航按钮或者自定义按钮，请自定义该方法
 *
 *  @param sender 发送者
 */
- (void)leftBarButtonItemPressed:(id)sender;
/**
 *  如果自定义导航按钮或者自定义按钮，请自定义该方法
 *
 *  @param sender 发送者
 */
- (void)rightBarButtonItemPressed:(id)sender;

#pragma mark -override
/**
 *  图片下载完成事件
 */
- (void)imageDownloadDone;
@end