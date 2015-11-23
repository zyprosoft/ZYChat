//
//  shopModel.h
//  瀑布流demo
//
//  Created by yuxin on 15/6/6.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface shopModel : NSObject
@property(nonatomic,copy)NSString * img;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,assign)CGFloat w;
@property(nonatomic,assign)CGFloat h;
@end
