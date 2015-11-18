//
//  GJAssetsPickerCell.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFAssetsView.h"

@class GJCFAssetsPickerCell;

@protocol GJCFAssetsPickerCellDelegate <NSObject>

/* 当cell中某个位置的照片标记状态改变时候调用  */
- (void)assetsPickerCell:(GJCFAssetsPickerCell*)assetsPickerCell didChangeStateAtIndex:(NSInteger)index withState:(BOOL)isSelected;

/* 决定cell中某个位置的照片是否可以选中 */
- (BOOL)assetsPickerCell:(GJCFAssetsPickerCell *)assetsPickerCell shouldChangeToSelectedStateAtIndex:(NSInteger)index;

/* 决定从这个Cell的某张照片开始进入大图模式 */
- (void)assetsPickerCell:(GJCFAssetsPickerCell *)assetsPickerCell shouldBeginBigImageShowAtIndex:(NSInteger)index;

@end

/* GJPhotosController 视图的单元行 */
@interface GJCFAssetsPickerCell : UITableViewCell<GJCFAssetsPickerOverlayViewDelegate>

/* 有多少列 */
@property (nonatomic,assign)NSInteger colums;

/* 两列之间的间隔距离 */
@property (nonatomic,assign)CGFloat   columSpace;

/* 代理 */
@property (nonatomic,weak)id<GJCFAssetsPickerCellDelegate> delegate;

/* 标记状态的视图 */
@property (nonatomic,strong)Class overlayViewClass;

/* 是否开启大图浏览模式 */
@property (nonatomic,assign)BOOL enableBigImageShowAction;

- (void)setAssets:(NSArray*)assets;

@end
