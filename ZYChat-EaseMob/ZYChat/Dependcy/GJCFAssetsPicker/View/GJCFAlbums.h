//
//  GJAlbums.h
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

/* 相册对象 */
@interface GJCFAlbums : NSObject

/* 实际的相册数据对象 */
@property (nonatomic,strong)ALAssetsGroup *assetsGroup;

/* 该相册内实际的照片对象GJAsset数组 ，用来在第一次进入相册之后，就不用再次枚举统计 */
@property (nonatomic,strong)NSMutableArray *assetsArray;

/* 相册使用的类型过滤 */
@property (nonatomic,strong)ALAssetsFilter *filter;

/* 相册名字 */
@property (nonatomic,readonly)NSString  *name;

/* 该相册中图片数量 */
@property (nonatomic,readonly)NSInteger totalCount;

/* 相册的缩略图 */
@property (nonatomic,readonly)UIImage *posterImage;

- (id)initWithAssetsGroup:(ALAssetsGroup *)aGroup;

- (BOOL)isEqual:(GJCFAlbums*)aAlbums;

@end
