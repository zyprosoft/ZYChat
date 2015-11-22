//
//  GJGCLoadingStatusHUD.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15-1-9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCLoadingStatusHUD : UIView

- (instancetype)initWithView:(UIView *)aView;

- (void)showWithStatusText:(NSString *)status;

- (void)dismiss;

@end
