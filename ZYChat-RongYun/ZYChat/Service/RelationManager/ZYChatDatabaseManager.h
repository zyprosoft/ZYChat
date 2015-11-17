//
//  ZYChatDatabaseManager.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/17.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserDatabaseManager.h"

@interface ZYChatDatabaseManager : NSObject

@property (nonatomic,strong)ZYUserDatabaseManager *userDatabase;

+ (ZYChatDatabaseManager *)shareManager;

- (void)buildEnvironment;

- (ZYDatabaseOperation *)commonMessageCreateTableOperation;

@end
