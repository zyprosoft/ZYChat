//
//  GJAssetsPreviewController.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFAsset.h"
#import "GJCFAssetsPickerStyle.h"

@class GJCFAssetsPreviewController;

@protocol GJCFAssetsPreviewControllerDelegate <NSObject>

/* 预览视图需要使用自定义风格 */
- (GJCFAssetsPickerStyle*)previewControllerShouldCustomStyle:(GJCFAssetsPreviewController*)previewController;

/* 预览视图的指定照片已经更新了选中状态 */
- (void)previewController:(GJCFAssetsPreviewController*)previewController didUpdateAssetSelectedState:(GJCFAsset*)asset;

@end

@interface GJCFAssetsPreviewController : UIPageViewController

@property (nonatomic,weak)id<GJCFAssetsPreviewControllerDelegate> previewDelegate;

/* 起始浏览位置 */
@property (nonatomic,assign)NSInteger pageIndex;

/* 照片数据源 */
@property (nonatomic,strong)NSMutableArray *assets;

/* 底部自定义工具栏 */
@property (nonatomic,strong)UIImageView    *customBottomToolBar;

/* 当不是预览模式下面，可以使用这个标题来覆盖预览模式下面的索引标题 */
@property (nonatomic,strong)NSString *importantTitle;

/* 多图选择模式下面最大选中数量 */
@property (nonatomic,assign)NSInteger mutilSelectLimitCount;

- (instancetype)initWithAssets:(NSArray*)sAsstes;

@end
