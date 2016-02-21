//
//  GJGCVideoRecordViewController.h
//  ZYChat
//
//  Created by ZYVincent on 16/2/21.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCBaseViewController.h"

@class GJGCVideoRecordViewController;
@protocol GJGCVideoRecordViewControllerDelegate <NSObject>

- (void)videoRecordViewController:(GJGCVideoRecordViewController *)recordVC didFinishRecordWithResult:(NSURL *)recordPath;

@end

@interface GJGCVideoRecordViewController : GJGCBaseViewController

@property (nonatomic,assign)NSTimeInterval maxDuration;

@property (nonatomic,weak)id<GJGCVideoRecordViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<GJGCVideoRecordViewControllerDelegate>)aDelegate;

@end
