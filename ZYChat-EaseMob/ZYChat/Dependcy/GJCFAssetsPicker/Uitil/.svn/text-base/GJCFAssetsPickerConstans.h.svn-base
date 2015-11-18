//
//  GJAssetsPickerConstans.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GJCFAssetsPickerStyle.h"
#import "UIButton+GJCFAssetsPickerStyle.h"
#import "UILabel+GJCFAssetsPickerStyle.h"

/* 图片选择达到限制数量的通知 */
extern NSString * const kGJAssetsPickerPhotoControllerDidReachLimitCountNoti;

/* 图片选择视图需要退出的通知 */
extern NSString * const kGJAssetsPickerNeedCancelNoti;

/* 图片选择视图已经完成了图片选择通知 */
extern NSString * const kGJAssetsPickerDidFinishChooseMediaNoti;

/* 图片预览详情视图点击事件通知 */
extern NSString * const kGJAssetsPickerPreviewItemControllerDidTapNoti;

/* 图片预览但是没有已经选中图片的通知 */
extern NSString * const kGJAssetsPickerRequirePreviewButNoSelectPhotoTipNoti;

/* 图片选择视图发生错误 */
extern NSString * const kGJAssetsPickerComeAcrossAnErrorNoti;

/* 图片选择器自定义Error 的 Domain */
extern NSString * const kGJAssetsPickerErrorDomain;

/* 图片选择错误类型 */
typedef enum {
    
    /* 相册访问未授权 */
    GJAssetsPickerErrorTypePhotoLibarayNotAuthorize,
    
    /**
     *  相册选中了0张照片
     */
    GJAssetsPickerErrorTypePhotoLibarayChooseZeroCountPhoto,
    
}GJAssetsPickerErrorType;

@interface GJCFAssetsPickerConstans : NSObject

/* 全局使用的照片访问库 */
+ (ALAssetsLibrary *)shareAssetsLibrary;

/* 根据颜色创建图片 */
+ (UIImage *)imageForColor:(UIColor*)aColor withSize:(CGSize)aSize;

/* 当前系统版本是否iOS7 */
+ (BOOL)isIOS7;

/* 发送一个通知 */
+ (void)postNoti:(NSString*)noti;

/* 发送一个带对象的通知 */
+ (void)postNoti:(NSString*)noti withObject:(NSObject*)obj;

/* 发送一个带对象和UserInfo的通知 */
+ (void)postNoti:(NSString*)noti withObject:(NSObject*)obj withUserInfo:(NSDictionary*)userInfo;


@end
