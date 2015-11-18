//
//  GJAssetsView.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFAsset.h"
#import "GJCFAssetsPickerOverlayView.h"

/* 照片显示视图 */
@interface GJCFAssetsView : UIView

/* 覆盖在照片上用来比较选中和非选中状态的视图 */
@property (nonatomic,strong)GJCFAssetsPickerOverlayView *overlayView;

- (void)setAsset:(GJCFAsset*)asset;

- (void)setOverlayView:(GJCFAssetsPickerOverlayView*)aOverlayView;

@end
