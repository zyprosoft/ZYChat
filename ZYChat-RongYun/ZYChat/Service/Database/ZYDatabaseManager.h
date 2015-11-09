//
//  ZYDatabaseManager.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDatabaseOperation.h"

@interface ZYDatabaseManager : NSObject

+ (ZYDatabaseManager *)shareManager;

- (void)addOperation:(ZYDatabaseOperation *)operation;

@end
