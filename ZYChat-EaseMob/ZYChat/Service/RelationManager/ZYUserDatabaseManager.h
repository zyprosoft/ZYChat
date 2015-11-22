//
//  ZYUserDatabaseManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/17.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserModel.h"
#import "ZYDatabaseManager.h"

@interface ZYUserDatabaseManager : NSObject

- (BOOL)createUserTable;

- (void)insertUsers:(NSArray *)users;

@end
