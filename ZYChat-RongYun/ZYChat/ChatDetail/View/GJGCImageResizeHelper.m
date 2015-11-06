//
//  GJGCImageResizeHelper.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCImageResizeHelper.h"

@implementation GJGCImageResizeHelper

+ (CGSize)getCutImageSizeWithScreenScale:(CGSize)originalSize maxSize:(CGSize)maxSize
{
    return [GJGCImageResizeHelper getCutImageSize:originalSize maxSize:maxSize useScreenScale:YES];
}

+ (CGSize)getCutImageSize:(CGSize)originalSize maxSize:(CGSize)maxSize
{
    return [GJGCImageResizeHelper getCutImageSize:originalSize maxSize:maxSize useScreenScale:NO];
}

+ (CGSize)getCutImageSizeWithScreenScale:(CGSize)originalSize minSize:(CGSize)minSize
{
    CGSize rSize = CGSizeMake(0, 0);
    
    /*
     * 是否支持裁剪图片
     * 当按照高清倍率放大的到图片超过原始尺寸是不能裁剪的
     */
    CGFloat scaleMinWidth = minSize.width * GJCFScreenScale;
    CGFloat scaleMinHeight = minSize.height * GJCFScreenScale;
    
    BOOL canResize = YES;
    if (scaleMinWidth > originalSize.width || scaleMinHeight > originalSize.height) {
        canResize = NO;
    }
    if (!canResize) {
        return originalSize;
    }
    
    CGFloat widthDelta = minSize.width / originalSize.width;
    CGFloat heightDelta = minSize.height / originalSize.height;
    
    BOOL useWidthScale = widthDelta > heightDelta ? heightDelta:widthDelta;
    
    if (useWidthScale) {
        
        if (originalSize.width != 0) {
            
            rSize.width = minSize.width * GJCFScreenScale;
            rSize.height = originalSize.height * widthDelta * GJCFScreenScale;
        }
        
    }else{
        
        rSize.height = minSize.height * GJCFScreenScale;
        rSize.width = originalSize.width * heightDelta * GJCFScreenScale;
        
    }
    
    return rSize;
}

+ (CGSize)getCutImageSize:(CGSize)originalSize maxSize:(CGSize)maxSize useScreenScale:(BOOL)isUsed
{
    CGSize rSize = CGSizeMake(0, 0);
    
    if (originalSize.width > originalSize.height) {
        
        if (originalSize.width != 0) {
            
            rSize.width = maxSize.width;
            rSize.height = originalSize.height * (maxSize.width/originalSize.width);
        }
        
    }
    else
    {
        if (originalSize.height != 0) {
            
            rSize.height = maxSize.height;
            rSize.width = originalSize.width * (maxSize.height/originalSize.height);
            
        }
    }
    
    /* 是否支持获取高清图 */
    CGSize scaleSize = rSize;
    if(rSize.width * GJCFScreenScale <= originalSize.width && rSize.height * GJCFScreenScale <= originalSize.height ){
        scaleSize = CGSizeMake(rSize.width * GJCFScreenScale,rSize.height * GJCFScreenScale);
    }
    CGSize resultSize = isUsed? scaleSize:rSize;
    
    return resultSize;
}

@end
