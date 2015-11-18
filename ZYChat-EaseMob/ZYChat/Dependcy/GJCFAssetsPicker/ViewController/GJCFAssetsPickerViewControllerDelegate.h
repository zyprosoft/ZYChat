//
//  GJAssetsPickerViewControllerDelegate.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAssetsPickerStyle.h"
#import "GJCFAssetsPickerConstans.h"

@class GJCFAssetsPickerViewController;

/* GJAssetsPickerViewController 可响应的一些代理方法 */
@protocol GJCFAssetsPickerViewControllerDelegate <NSObject>

/* 建议强制实现这些代理方法来监测异常行为，以避免自己忘了实现代理，而感觉图片无法继续点击选中而产生的困惑 */
@required

/*
 * 当图片选择视图达到了限制的多选数量的时候会执行
 *
 * @prama limitCount  返回最大限制的多选数量
 */
- (void)pickerViewController:(GJCFAssetsPickerViewController*)pickerViewController didReachLimitSelectedCount:(NSInteger)limitCount;


/*
 * 当图片选择想要预览却没有选中图片时执行
 *
 */
- (void)pickerViewControllerRequirePreviewButNoSelectedImage:(GJCFAssetsPickerViewController*)pickerViewController;

/*
 * 当图片选择没有访问授权时执行
 *
 */
- (void)pickerViewControllerPhotoLibraryAccessDidNotAuthorized:(GJCFAssetsPickerViewController*)pickerViewController;


@optional

/*
 * 图片选择视图需要通过pickerStyle来自定义一些UI的时候可以调用这个代理来实现，否则一律调用[GJAssetsPickerStyle defaultStyle]
 *
 */
- (GJCFAssetsPickerStyle*)pickerViewShouldUseCustomStyle:(GJCFAssetsPickerViewController*)pickerViewController;

/*
 * 当图片选择视图将要消失的时候执行
 */
- (void)pickerViewControllerWillCancel:(GJCFAssetsPickerViewController*)pickerViewController;

/*
 * 当图片选择完成之后执行这个代理方法，将选中的图片返回给调用者
 *
 * @param resultArray  返回的选中的图片 内容是  GJAsset 对象数组
 */
- (void)pickerViewController:(GJCFAssetsPickerViewController*)pickerViewController didFinishChooseMedia:(NSArray *)resultArray;

/*
 * 当图片选择发生错误的时候执行这个方法
 *
 * @param errorMsg 发生的错误消息内容 errorType 发生错误的类型
 */
- (void)pickerViewController:(GJCFAssetsPickerViewController*)pickerViewController didFaildWithErrorMsg:(NSString*)errorMsg withErrorType:(GJAssetsPickerErrorType)errorType;

@end