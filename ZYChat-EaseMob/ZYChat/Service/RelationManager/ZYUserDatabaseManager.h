//
//  ZYUserDatabaseManager.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/17.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserModel.h"
#import "ZYDatabaseManager.h"

@interface ZYUserDatabaseManager : NSObject

- (BOOL)createUserTable;

- (void)insertUsers:(NSArray *)users;

@end
