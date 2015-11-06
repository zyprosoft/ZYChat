//
//  GJCFImageBrowserViewControllerDelegate.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GJCUImageBrowserViewController;

@protocol GJCUImageBrowserViewControllerDataSource <NSObject>

/**
 *  设定自定义工具栏
 *
 *  @param browserController
 *
 *  @return
 */
- (UIView *)imageBrowserShouldCustomBottomToolBar:(GJCUImageBrowserViewController *)browserController;

/**
 *  设定自定义导航栏右上角
 *
 *  @param browserController
 *
 *  @return
 */
- (UIView *)imageBrowserShouldCustomRightNavigationBarItem:(GJCUImageBrowserViewController *)browserController;

/**
 *  设定自定义导航条背景
 *
 *  @param browserController
 *
 *  @return
 */
- (UIImage *)imageBrowserShouldCustomNavigationBar:(GJCUImageBrowserViewController *)browserController;

/**
 *  将要消失
 *
 *  @param browserController 
 */
- (void)imageBrowserWillCancel:(GJCUImageBrowserViewController *)browserController;


/**
 *  删除完显示指定位置的图片执行此回调
 *
 *  @param browserController
 *  @param index
 */
- (void)imageBrowser:(GJCUImageBrowserViewController *)browserController didFinishRemoveAtIndex:(NSInteger)index;

/**
 *  删除仅剩的最后一张图片的时候执行此回调
 *
 *  @param browserController 
 */
- (void)imageBrowserShouldReturnWhileRemoveLastOnlyImage:(GJCUImageBrowserViewController *)browserController;

@end
