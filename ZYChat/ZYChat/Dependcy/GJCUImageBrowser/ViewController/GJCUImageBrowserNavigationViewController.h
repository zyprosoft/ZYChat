//
//  GJCFImageBrowserNavigationViewController.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCUImageBrowserViewControllerDataSource.h"
#import "GJCUImageBrowserViewController.h"

@interface GJCUImageBrowserNavigationViewController : UINavigationController

@property (nonatomic,weak)id<GJCUImageBrowserViewControllerDataSource> browserDataSource;

/* 起始浏览位置 */
@property (nonatomic,assign)NSInteger pageIndex;

/* 图片数据源 */
@property (nonatomic,strong)NSMutableArray *imageModelArray;

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
 *  移除指定Index位置的图片
 *
 *  @param index
 */
- (void)removeImageAtIndex:(NSInteger)index;

@end
