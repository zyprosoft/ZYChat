//
//  GJAssetsPickerStyle.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFAssetsPickerOverlayView.h"
#import "GJCFAssetsPickerCommonStyleDescription.h"

/* 设定一些持久有效的风格用到的存储Key */
#define kGJAssetsPickerStylePersistUDF @"kGJAssetsPickerStylePersistUDF"

/*
 *  通过继承这个对象来实现自己的UI自定义
 */
@interface GJCFAssetsPickerStyle : NSObject<NSCoding>

/*
 * 系统预览按钮的样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysPreviewBtnDes;

/*
 * 系统完成按钮样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysFinishDoneBtDes;

/*
 * 系统退出按钮样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysCancelBtnDes;

/*
 * 系统返回按钮样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysBackBtnDes;

/*
 * 系统选择相册的NavigationBar样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysAlbumsNavigationBarDes;

/*
 * 系统选择照片的NavigationBar样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysPhotoNavigationBarDes;

/*
 * 系统预览照片的NavigationBar样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysPreviewNavigationBarDes;

/*
 * 系统预览照片视图底部工具栏的样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysPreviewBottomToolBarDes;

/*
 * 系统预览照片改变照片状态的按钮的样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysPreviewChangeSelectStateBtnDes;

/*
 * 系统照片选择底部工具栏样式
 */
@property (nonatomic,readonly)GJCFAssetsPickerCommonStyleDescription *sysPhotoBottomToolBarDes;

/*
 * 图片选择列表时候，需要展示多少列,会影响overlayView的大小
 */
@property (nonatomic,readonly)NSInteger numberOfColums;

/*
 * 是否开启大图查看模式，默认开启
 */
@property (nonatomic,readonly)BOOL enableBigImageShowAction;

/*
 * 图片选择列表两个照片之间的间隔
 */
@property (nonatomic,readonly)CGFloat   columSpace;

/*
 * 覆盖在单张照片上的视图，用来改变选中和未选中状态的，大小和单张图片大小一样,必须是继承或者是GJCFAssetsPickerOverlayView
 */
@property (nonatomic,readonly)Class sysOverlayViewClass;

/**
 *  在大图详情模式下是否可以自动选中,默认可以自动选中
 */
@property (nonatomic,readonly)BOOL enableAutoChooseInDetail;

/* 系统默认的样式 */
+ (GJCFAssetsPickerStyle*)defaultStyle;

/* 添加自定义风格 */
+ (void)appendCustomStyle:(GJCFAssetsPickerStyle*)aCustomStyle forKey:(NSString *)customStyleKey;

/* 根据key获取设定过的风格 */
+ (GJCFAssetsPickerStyle*)styleByKey:(NSString *)customStyleKey;

/* 根据key删除设定过的风格 */
+ (void)removeCustomStyleByKey:(NSString *)customStyleKey;

/* 获取所有设定过的风格的key */
+ (NSArray *)existCustomStyleKeys;

/* 清除所有设定过的风格 */
+ (void)clearAllCustomStyles;

/* 获取所有设定过的风格 */
+ (NSMutableDictionary *)persistStyleDict;

/* 取系统默认图片 */
+ (UIImage *)bundleImage:(NSString*)imageName;

@end
