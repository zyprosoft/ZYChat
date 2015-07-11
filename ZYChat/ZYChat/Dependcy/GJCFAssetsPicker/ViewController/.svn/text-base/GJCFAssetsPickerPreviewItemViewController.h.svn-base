//
//  GJAssetsPickerPreviewItemViewController.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-10.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFAsset.h"

@protocol GJCFAssetsPickerPreviewItemViewControllerDataSource <NSObject>

/* 当前需要显示的图片 */
- (GJCFAsset *)assetAtIndex:(NSInteger)index;

@end

@interface GJCFAssetsPickerPreviewItemViewController : UIViewController

@property (nonatomic,weak)id<GJCFAssetsPickerPreviewItemViewControllerDataSource> dataSource;

/* 当前索引 */
@property (nonatomic,assign)NSInteger pageIndex;

+ (instancetype)itemViewForPageIndex:(NSInteger)index;

@end
