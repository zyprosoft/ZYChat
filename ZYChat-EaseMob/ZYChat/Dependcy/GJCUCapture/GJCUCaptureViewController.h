//
//  GJCUCaptureViewController.h
//  GJCoreUserInterface
//
//  Created by ZYVincent QQ:1003081775 on 15-1-23.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFUitils.h"
#import "UIView+GJCFViewFrameUitil.h"

@class GJCUCaptureViewController;

@protocol GJCUCaptureViewControllerDelegate <NSObject>

- (void)captureViewController:(GJCUCaptureViewController *)captureViewController didFinishChooseMedia:(NSDictionary *)mediaInfo;

- (void)captureViewControllerAccessCamerouNotAuthorized:(GJCUCaptureViewController *)captureViewController;

@end

@interface GJCUCaptureViewController : UIViewController

@property (nonatomic,assign)BOOL isNeedAutoSaveToAlbum;

@property (nonatomic,weak)id<GJCUCaptureViewControllerDelegate> delegate;

@end
