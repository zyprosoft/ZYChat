//
//  GJAssetsPickerOverlayView.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 * 如果有查看大图模式的功能下，继承实现的GJCFAssetsPickerOverlayView必须实现调用这三个协议方法，告诉GJCFAssetsPickerCell去响应 
 */
@class GJCFAssetsPickerOverlayView;
@protocol GJCFAssetsPickerOverlayViewDelegate <NSObject>

- (void)pickerOverlayView:(GJCFAssetsPickerOverlayView*)overlayView responseToChangeSelectedState:(BOOL)state;

- (void)pickerOverlayViewResponseToShowBigImage:(GJCFAssetsPickerOverlayView *)overlayView;

- (BOOL)pickerOverlayViewCanChangeToSelectedState:(GJCFAssetsPickerOverlayView*)overlayView;

@end
/*
 * 如果有需要持久化的属性，那么继承这个视图的子类需要实现NSCoding协议，否则无法正确的存储
 *
 * 通常情况下，这个视图的属性是不需要持久化的，所以不需要实现NSCoding协议
 */
@interface GJCFAssetsPickerOverlayView : UIView<NSCoding>

@property (nonatomic,weak)id<GJCFAssetsPickerOverlayViewDelegate> delegate;

/* 标记视图是否选中 */
@property (nonatomic,assign)BOOL selected;

/* 标记是否选中 */
@property (nonatomic,strong)UIImageView *selectIconImgView;

/*
 * 是否允许有查看大图模式，如果设置为YES的话，那么需要提供，供给选中标记的触摸范围 
 */
@property (nonatomic,assign)BOOL enableChooseToSeeBigImageAction;

/*
 * 当查看大图模式开启之后，这个触摸响应范围，用来标记触摸在了选中效果视图上,默认是选中视图标记的大小
 */
@property (nonatomic,assign)CGRect frameToShowSelectedWhileBigImageActionEnabled;

/* 使用系统默认风格的标记视图 */
+ (GJCFAssetsPickerOverlayView*)defaultOverlayView;

/*
 * 重写这两个方法来实现别的选中效果，默认采用隐藏和显示的方式来展示选中状态
 */

/*
 * 照片选中状态时调用 
 */
- (void)switchSelectState;

/*
 * 照片未选中状态时调用 
 */
- (void)switchNormalState;

@end
