//
//  GJCFImageBrowserViewController.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCUImageBrowserViewControllerDataSource.h"
#import "GJCUImageBrowserConstans.h"
#import "GJCUImageBrowserModel.h"
#import "GJCUImageBrowserScrollView.h"
#import "GJCUImageBrowserItemViewController.h"


@interface GJCUImageBrowserViewController : UIPageViewController

@property (nonatomic,weak)id<GJCUImageBrowserViewControllerDataSource> browserDataSource;

/* 起始浏览位置 */
@property (nonatomic,assign)NSInteger pageIndex;

/* 图片数据源 */
@property (nonatomic,strong)NSMutableArray *imageModelArray;

/**
 *  是否模态推出的
 */
@property (nonatomic,assign)BOOL isPresentModelState;

/**
 *  使用Model初始化
 *
 *  @param imageModels
 *
 *  @return
 */
- (instancetype)initWithImageModels:(NSArray*)imageModels;

/**
 *  使用图片地址数组初始化
 *
 *  @param imageUrls
 *
 *  @return
 */
- (instancetype)initWithImageUrls:(NSArray *)imageUrls;

/**
 *  使用本地图片路径组初始化
 *
 *  @param imageFilePaths
 *
 *  @return
 */
- (instancetype)initWithLocalImageFilePaths:(NSArray *)imageFilePaths;


/**
 *  预览ALAssets对象组
 *
 *  @param assetsArray
 *
 *  @return
 */
- (instancetype)initWithImageAssets:(NSArray *)assetsArray;

/**
 *  预览GJCFAssets对象组
 *
 *  @param assetsArray
 *
 *  @return
 */
- (instancetype)initWithGJCFAssets:(NSArray *)assetsArray;

/**
 *  删除索引为index处的图片
 *
 *  @param index
 */
- (void)removeImageAtIndex:(NSInteger)index;

@end
