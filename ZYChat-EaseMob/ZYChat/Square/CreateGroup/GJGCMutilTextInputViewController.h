//
//  GJGCMutilTextInputViewController.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCBaseViewController.h"

@class GJGCMutilTextInputViewController;
@protocol GJGCMutilTextInputViewControllerDelegate <NSObject>

- (void)mutilTextInputViewController:(GJGCMutilTextInputViewController *)inputViewController didFinishInputText:(NSString *)text;

@end

@interface GJGCMutilTextInputViewController : GJGCBaseViewController

@property (nonatomic,weak)id<GJGCMutilTextInputViewControllerDelegate> delegate;
@property (nonatomic,assign)NSInteger userType;
@property (nonatomic,strong)NSString *paramString;

@end
