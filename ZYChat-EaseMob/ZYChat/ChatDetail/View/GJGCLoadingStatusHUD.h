//
//  GJGCLoadingStatusHUD.h
//  ZYChat
//
//  Created by ZYVincent on 15-1-9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCLoadingStatusHUD : UIView

- (instancetype)initWithView:(UIView *)aView;

- (void)showWithStatusText:(NSString *)status;

- (void)dismiss;

@end
