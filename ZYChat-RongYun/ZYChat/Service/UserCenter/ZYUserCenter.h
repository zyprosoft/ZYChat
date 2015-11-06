//
//  ZYUserCenter.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserModel.h"

@interface ZYUserCenter : NSObject

+ (ZYUserCenter *)shareCenter;

- (ZYUserModel *)currentLoginUser;

@end
