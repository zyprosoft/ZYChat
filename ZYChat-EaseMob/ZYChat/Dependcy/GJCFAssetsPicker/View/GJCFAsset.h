//
//  GJAsset.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

/* 照片对象 */
@interface GJCFAsset : NSObject

/* 真实的Asset对象 */
@property (nonatomic,strong)ALAsset *containtAsset;

/* 照片是否选中 */
@property (nonatomic,assign)BOOL    selected;

/* 等比缩略图 */
@property (nonatomic,readonly)UIImage *aspectRatioThumbnail;

/* 缩略图 */
@property (nonatomic,readonly)UIImage *thumbnail;

/* 图片大小 */
@property (nonatomic,readonly)CGSize   imageSize;

/* 高清大图 */
@property (nonatomic,readonly)UIImage *fullResolutionImage;

/* 全屏图片 */
@property (nonatomic,readonly)UIImage *fullScreenImage;

/* 图片文件名字 */
@property (nonatomic,readonly)NSString *fileName;

/* 缩放倍数 */
@property (nonatomic,readonly)CGFloat scale;

/* 占用内存大小 */
@property (nonatomic,readonly)long long size;

/* 倾斜方向 */
@property (nonatomic,readonly)ALAssetOrientation orientation;

/* 原始数据 */
@property (nonatomic,readonly)NSDictionary *metaData;

/* 是否已经被裁剪 */
@property (nonatomic,readonly)BOOL isHaveBeenEdit;

/* 被裁剪过的图片 */
@property (nonatomic,readonly)UIImage *editImage;

/* 图片的路径，和ALAssetPropertyAssetUrl取到的是一样的 */
@property (nonatomic,readonly)NSURL *url;

/* 图片的唯一标示符 */
@property (nonatomic,readonly)NSString *uniqueIdentifier;


- (id)initWithAsset:(ALAsset*)asset;

- (BOOL)isEqual:(GJCFAsset*)asset;


@end
