//
//  GJCUFlashModeView.h
//  GJCoreUserInterface
//
//  Created by ZYVincent on 15-1-23.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GJCFUitils.h"
#import "UIView+GJCFViewFrameUitil.h"

@interface GJCUFlashModeView : UIView

@property (nonatomic,assign)AVCaptureFlashMode currentMode;

- (instancetype)initWithFrame:(CGRect)frame;

@end
