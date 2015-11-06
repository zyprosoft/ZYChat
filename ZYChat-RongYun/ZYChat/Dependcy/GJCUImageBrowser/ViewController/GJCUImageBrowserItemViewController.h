//
//  GJCFImageBrowserItemViewController.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCUImageBrowserModel.h"

@class GJCUImageBrowserItemViewController;

@protocol GJCUImageBrowserItemViewControllerDataSource <NSObject>

/**
 *  返回当前预览的模型代理
 *
 *  @param index
 *
 *  @return
 */
- (GJCUImageBrowserModel *)imageModelAtIndex:(NSInteger)index;

/**
 *  告知需要开始下载
 *
 *  @param index
 */
- (void)imageShouldStartDownloadAtIndex:(NSInteger)index;

@end

@interface GJCUImageBrowserItemViewController : UIViewController

@property (nonatomic,weak)id<GJCUImageBrowserItemViewControllerDataSource> dataSource;

@property (nonatomic,readonly)UIImage *currentDisplayImage;

/* 当前索引 */
@property (nonatomic,assign)NSInteger pageIndex;

+ (instancetype)itemViewForPageIndex:(NSInteger)index;

@end
