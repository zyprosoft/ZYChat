//
//  ZYNavigationController.h
//  ZYNavigationController
//
//  Created by ZYVincent on 15-7-15.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYNavigationController : UINavigationController

// 是否支持右滑返回
@property (nonatomic, assign) BOOL canDragBack;
@property (nonatomic, assign) ZYResourceType type;

@end
