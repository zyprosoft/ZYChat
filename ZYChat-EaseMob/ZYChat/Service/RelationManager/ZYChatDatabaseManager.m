//
//  ZYChatDatabaseManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/17.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYChatDatabaseManager.h"

@implementation ZYChatDatabaseManager

+ (ZYChatDatabaseManager *)shareManager
{
    static ZYChatDatabaseManager *_dbManagerInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _dbManagerInstance = [[self alloc]init];
        
    });
    
    return _dbManagerInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self buildEnvironment];
    }
    return self;
}

- (void)buildEnvironment
{
    self.userDatabase = [[ZYUserDatabaseManager alloc]init];
    
    [self.userDatabase createUserTable];
}


@end
