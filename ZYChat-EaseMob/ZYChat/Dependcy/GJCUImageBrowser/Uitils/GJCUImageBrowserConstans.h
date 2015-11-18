//
//  GJCFImageBrowserConstans.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  点击了预览大图通知
 */
extern NSString *const GJCUImageBrowserItemViewControllerDidTapNoti;

/**
 *  开始下载大图通知
 */
extern NSString *const GJCUImageBrowserViewControllerDidBeginDownloadTaskNoti;

/**
 *  完成下载大图通知
 */
extern NSString *const GJCUImageBrowserViewControllerDidFinishDownloadTaskNoti;

/**
 *  下载大图失败通知
 */
extern NSString *const GJCUImageBrowserViewControllerDidFaildDownloadTaskNoti;

/**
 *  大图默认缓存目录
 */
extern NSString *const GJCUImageBrowserViewControllerCacheDirectory;

@interface GJCUImageBrowserConstans : NSObject

@end
