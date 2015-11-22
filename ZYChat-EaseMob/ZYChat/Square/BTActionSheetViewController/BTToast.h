//
//  BTToast.h
//  BabyTrip
//
//  Created by ZYVincent on 15/7/19.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

#define BTToast(title) [BTToast showToast:title]

#define BTToastError(error) [BTToast showToastError:error]

@interface BTToast : NSObject

+ (void)showToast:(NSString *)title;

+ (void)showToastError:(NSError *)error;

+ (void)showToast:(NSString *)title state:(BOOL)isSuccess;

@end
