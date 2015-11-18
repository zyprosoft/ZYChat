//
//  GJCFImageBrowserScrollView.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCUImageBrowserItemViewController.h"
#import "GJCUAsyncImageView.h"

@interface GJCUImageBrowserScrollView : UIScrollView

/* 用来显示当前图片的 */
@property (nonatomic,strong)UIImageView *contentImageView;

/* 图片数据源 */
@property (nonatomic,weak)id<GJCUImageBrowserItemViewControllerDataSource> dataSource;

/* 当前索引 */
@property (nonatomic,assign)NSInteger index;

/**
 *  是否正在下载
 */
@property (nonatomic,assign)BOOL isDownloading;


@end
