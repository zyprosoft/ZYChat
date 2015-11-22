//
//  ZYDatabaseOperation.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYDatabaseOperation.h"

@implementation ZYDatabaseOperation

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString *userDBDir = @"database";
        
        NSString *dbDir = GJCFAppCachePath(userDBDir);
        
        if (!GJCFFileDirectoryIsExist(dbDir)) {
            
            GJCFFileDirectoryCreate(dbDir);
        }
        
        NSString *dbName = [NSString stringWithFormat:@"%@.db",[ZYUserCenter shareCenter].currentLoginUser.mobile];
        
        _dbPath = [dbDir stringByAppendingPathComponent:dbName];
    }
    return self;
}

@end
