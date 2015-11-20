//
//  GJGCMutilTextInputViewController.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCBaseViewController.h"

@class GJGCMutilTextInputViewController;
@protocol GJGCMutilTextInputViewControllerDelegate <NSObject>

- (void)mutilTextInputViewController:(GJGCMutilTextInputViewController *)inputViewController didFinishInputText:(NSString *)text;

@end

@interface GJGCMutilTextInputViewController : GJGCBaseViewController

@property (nonatomic,weak)id<GJGCMutilTextInputViewControllerDelegate> delegate;
@property (nonatomic,assign)NSInteger userType;

@end
