//
//  GJCFImageBrowserModel.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFAsset.h"

@interface GJCUImageBrowserModel : NSObject

/**
 *  图片远程地址
 */
@property (nonatomic,strong)NSString *imageUrl;

/**
 *  本地图片路径
 */
@property (nonatomic,strong)NSString *filePath;

/**
 *  缓存图片路径，缓存成功之后会将路径设置到filePath
 */
@property (nonatomic,strong)NSString *cachePath;

/**
 *  预览索引
 */
@property (nonatomic,assign)NSInteger index;

/**
 *  大图的大小
 */
@property (nonatomic,assign)CGSize imageSize;

/**
 *  缩略图
 */
@property (nonatomic,strong)UIImage *thumbImage;

/**
 *  预览ALAsset
 */
@property (nonatomic,strong)ALAsset *contentAsset;

/**
 *  预览GJCFAsset对象
 */
@property (nonatomic,strong)GJCFAsset *gjcfAsset;

/**
 *  是否预览ALAsset
 */
@property (nonatomic,assign)BOOL isPreviewAsset;


@end
