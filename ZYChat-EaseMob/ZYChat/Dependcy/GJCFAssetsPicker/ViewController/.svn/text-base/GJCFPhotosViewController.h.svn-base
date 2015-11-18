//
//  GJPhotosViewController.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFAssetsPickerCell.h"
#import "GJCFAlbums.h"

@class GJCFPhotosViewController;
@class GJCFAssetsPickerStyle;

@protocol GJCFPhotosViewControllerDelegate <NSObject>

@optional

/* 照片选择视图需要使用自定义风格 */
- (GJCFAssetsPickerStyle*)photoViewControllerShouldUseCustomStyle:(GJCFPhotosViewController*)photoViewController;

/* 照片已经枚举完了时候会执行 */
- (void)photoViewController:(GJCFPhotosViewController*)photoViewController didFinishEnumrateAssets:(NSArray *)assets forAlbums:(GJCFAlbums*)destAlbums;

@end

@interface GJCFPhotosViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GJCFAssetsPickerCellDelegate>

@property (nonatomic,weak)id<GJCFPhotosViewControllerDelegate> delegate;

/* 照片列表 */
@property (nonatomic,strong)UITableView *assetsTable;

/* 照片数据源 */
@property (nonatomic,strong)NSMutableArray *assetsArray;

/* 多选的最大数量 */
@property (nonatomic,assign)NSInteger mutilSelectLimitCount;

/* 每一行有多少列 */
@property (nonatomic,assign)NSInteger colums;

/* 每一行的两列之间的间隔 */
@property (nonatomic,assign)CGFloat    columSpace;

/* 真实的相册数据源 */
@property (nonatomic,strong)GJCFAlbums * albums;

/*
 * 用来传递外层已经选中的Assets，用于加载新的Assets选择列表的时候，直接赋成选中状态，已实现
 * 但是目前需求和效率问题限制，调用暂时无效
 */
@property (nonatomic,strong)NSArray *shouldInitSelectedStateAssetArray;

@end
