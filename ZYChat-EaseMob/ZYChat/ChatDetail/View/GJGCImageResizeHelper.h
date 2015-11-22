//
//  GJGCImageResizeHelper.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCImageResizeHelper : NSObject

/**
 *  返回大小，需要带屏幕的缩放比率
 *
 *  @param originalSize
 *  @param maxSize
 *
 *  @return
 */
+ (CGSize)getCutImageSizeWithScreenScale:(CGSize)originalSize maxSize:(CGSize)maxSize;

/**
 *  不待缩放比率大小裁剪
 *
 *  @param originalSize
 *  @param maxSize
 *
 *  @return
 */
+ (CGSize)getCutImageSize:(CGSize)originalSize maxSize:(CGSize)maxSize;

/**
 *  获取最小大小图片
 *
 *  @param originalSize
 *  @param minSize
 *
 *  @return
 */
+ (CGSize)getCutImageSizeWithScreenScale:(CGSize)originalSize minSize:(CGSize)minSize;

@end
