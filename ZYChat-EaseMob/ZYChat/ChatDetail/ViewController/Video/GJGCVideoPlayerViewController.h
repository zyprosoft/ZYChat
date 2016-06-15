//
//  GJGCVideoRecordViewController.h
//  ZYChat
//
//  Created by ZYVincent on 16/2/21.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCBaseViewController.h"

@class GJGCVideoPlayerViewController;
@protocol GJGCVideoPlayerViewControllerDelegate <NSObject>

- (void)videoPlayerDidTapped:(GJGCVideoPlayerViewController *)playerViewController;

@end

@interface GJGCVideoPlayerViewController : GJGCBaseViewController

@property (nonatomic,assign)NSTimeInterval maxDuration;

@property (nonatomic,weak)id<GJGCVideoPlayerViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<GJGCVideoPlayerViewControllerDelegate>)aDelegate withVideoUrl:(NSURL *)videoUrl;

@end
