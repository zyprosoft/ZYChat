//
//  GJAlbumsViewController.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GJCFAssetsPickerStyle.h"

@class GJCFAlbumsViewController;

@protocol GJCFAlbumsViewControllerDelegate <NSObject>

@optional

/* 相册视图需要使用自定义的风格 */
- (GJCFAssetsPickerStyle*)albumsViewControllerShouldUseCustomStyle:(GJCFAlbumsViewController*)albumsViewController;

@end

@interface GJCFAlbumsViewController : UIViewController

@property (nonatomic,weak)id<GJCFAlbumsViewControllerDelegate> delegate;

/* 相册使用的过滤设置 */
@property (nonatomic,strong)ALAssetsFilter *assetsFilter;

/* 多选的最大数量 */
@property (nonatomic,assign)NSUInteger mutilSelectLimitCount;

/* 图片选择列表，每一行有多少列 */
@property (nonatomic,assign)NSUInteger photoControllerColums;

/*
 * 用来传递外层已经选中的Assets，用于加载新的Assets选择列表的时候，直接赋成选中状态，已实现
 * 但是目前需求和效率问题限制，调用暂时无效
 */
@property (nonatomic,strong)NSArray *shouldInitSelectedStateAssetArray;

/*
 *  推入默认的相册
 */
- (void)pushDefaultAlbums;

/*
 *  注册自定义的相册详情类
 */
- (void)registPhotoViewControllerClass:(Class)aPhotoViewControllerClass;

/*
 *  注册自定义的相册Cell,不带自定义高度
 */
- (void)registAlbumsCustomCellClass:(Class)aAlbumsCustomCellClass;

/*
 *  注册自定义的相册Cell,设置自定义高度
 */
- (void)registAlbumsCustomCellClass:(Class)aAlbumsCustomCellClass withCellHeight:(CGFloat)cellHeight;

@end
