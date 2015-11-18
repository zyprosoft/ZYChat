//
//  GJAssetsPickerScrollView.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFAssetsPickerPreviewItemViewController.h"

/* 支持缩放的UIScrollView */
@interface GJCFAssetsPickerScrollView : UIScrollView<UIScrollViewDelegate>

/* 用来显示当前图片的 */
@property (nonatomic,strong)UIImageView *contentImageView;

/* 图片数据源 */
@property (nonatomic,weak)id<GJCFAssetsPickerPreviewItemViewControllerDataSource> dataSource;

/* 当前索引 */
@property (nonatomic,assign)NSInteger index;

@end
