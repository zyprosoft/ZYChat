//
//  GJCFImageBrowserModel.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCUImageBrowserModel.h"
#import "GJCFUitils.h"
#import "GJCUImageBrowserConstans.h"
#import "GJCFCachePathManager.h"

@implementation GJCUImageBrowserModel

- (void)setImageUrl:(NSString *)imageUrl
{
    if ([_imageUrl isEqualToString:imageUrl]) {
        return;
    }
    _imageUrl = nil;
    _imageUrl = [imageUrl copy];
    
    NSString *fileName = [_imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *cacheDir = [[GJCFCachePathManager shareManager]mainImageCacheDirectory];
    self.cachePath = [cacheDir stringByAppendingPathComponent:fileName];
    self.filePath = self.cachePath;
    self.imageSize = GJCFQuickImageByFilePath(self.filePath).size;
}

@end
