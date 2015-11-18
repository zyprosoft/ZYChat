//
//  GJAssetsPickerViewController.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFAssetsPickerViewControllerDelegate.h"
#import "GJCFAsset.h"
#import "GJCFAssetsPickerConstans.h"

/* 要求添加 ALAssetsLibrary.framework */
@interface GJCFAssetsPickerViewController : UINavigationController
@property (nonatomic,weak)id<GJCFAssetsPickerViewControllerDelegate> pickerDelegate;

/*
 * 用来传递外层已经选中的Assets，用于加载新的Assets选择列表的时候，直接赋成选中状态，已实现
 * 但是目前需求和效率问题限制，调用暂时无效
 */
@property (nonatomic,strong)NSArray *shouldInitSelectedStateAssetArray;

/*
 * 图片选择视图多选状态允许的最大选中数量
 */
@property (nonatomic,assign)NSInteger mutilSelectLimitCount;

/*
 *  立即消失图片选择器
 */
- (void)dismissPickerViewController;

/*
 *  注册自定义得照片选择详情类
 */
- (void)registPhotoViewControllerClass:(Class)aPhotoViewControllerClass;

/*
 *  注册自定义的相册Cell
 */
- (void)registAlbumsCustomCellClass:(Class)aAlbumsCustomCellClass;

/*
 *  注册自定义的相册Cell,设置自定义高度
 */
- (void)registAlbumsCustomCellClass:(Class)aAlbumsCustomCellClass withCellHeight:(CGFloat)cellHeight;

/*
 *  直接设置风格
 */
- (void)setCustomStyle:(GJCFAssetsPickerStyle*)aCustomStyle;

/*
 *  设置已经存储过的自定义风格
 */
- (void)setCustomStyleByKey:(NSString*)aExistCustomStyleKey;

@end
