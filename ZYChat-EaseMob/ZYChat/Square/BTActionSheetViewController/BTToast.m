//
//  BTToast.m
//  BabyTrip
//
//  Created by ZYVincent QQ:1003081775 on 15/7/19.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTToast.h"

#define kBTToastViewTag 875690


@implementation BTToast

+ (UIView *)toastWithTitle:(NSString *)title
{
    UIView *toastView = [[UIView alloc]init];
    toastView.layer.cornerRadius = 3.f;
    toastView.layer.masksToBounds = YES;
    toastView.backgroundColor = GJCFQuickHexColor(@"222222");
    toastView.layer.borderWidth = 0.5f;
    toastView.layer.borderColor = GJCFQuickHexColor(@"404040").CGColor;
    toastView.tag = kBTToastViewTag;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    
    toastView.gjcf_size = CGSizeMake(titleLabel.gjcf_width+ 2 * 10, titleLabel.gjcf_height + 2*4);
    [toastView addSubview:titleLabel];
    titleLabel.gjcf_centerX = toastView.gjcf_width/2;
    titleLabel.gjcf_centerY = toastView.gjcf_height/2;
    
    return toastView;
}

+ (void)showToast:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:kBTToastViewTag]) {
            [[[[UIApplication sharedApplication] keyWindow] viewWithTag:kBTToastViewTag] removeFromSuperview];
        }
        
        UIView *toastView = [BTToast toastWithTitle:title];
        
        [[[UIApplication sharedApplication] keyWindow]addSubview:toastView];
        toastView.gjcf_centerX = [[UIApplication sharedApplication] keyWindow].gjcf_width/2;
        toastView.gjcf_top = GJCFSystemScreenHeight - 120 - toastView.gjcf_height;
        toastView.alpha = 0.f;
        
        [UIView animateWithDuration:0.26 animations:^{
            
            toastView.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [BTToast makeToastHiddenAndRemove];
                
            });
            
        }];
        
    });

}

+ (void)showToastError:(NSError *)error
{
    NSString *errMsg = [error.userInfo objectForKey:@"errMsg"];
    
    [BTToast showToast:errMsg];
}

+ (void)makeToastHiddenAndRemove
{
    UIView *toastView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:kBTToastViewTag];
    
    [UIView animateWithDuration:0.26 animations:^{
        
        toastView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
       
        [toastView removeFromSuperview];
        
    }];
}

+ (void)showToast:(NSString *)title state:(BOOL)isSuccess
{
    
}

@end
