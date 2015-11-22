//
//  ZYChatDatabaseManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/17.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserDatabaseManager.h"

@interface ZYChatDatabaseManager : NSObject

@property (nonatomic,strong)ZYUserDatabaseManager *userDatabase;

+ (ZYChatDatabaseManager *)shareManager;

- (void)buildEnvironment;

- (ZYDatabaseOperation *)commonMessageCreateTableOperation;

@end
