//
//  ZYDatabaseOperation.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDatabaseCRUDCondition.h"
#import "FMResultSet.h"

typedef void (^ZYDatabaseOperationQuerySuccessBlock) (FMResultSet *resultSet);

typedef void (^ZYDatabaseOperationUpdateSuccessBlock) (void);

typedef void (^ZYDatabaseOperationFaildBlock) (NSError *error);

@interface ZYDatabaseOperation : NSObject

@property (nonatomic,readonly)NSString *dbPath;

@property (nonatomic,strong)ZYDatabaseCRUDCondition *actionCondition;

@property (nonatomic,copy)ZYDatabaseOperationQuerySuccessBlock QuerySuccess;

@property (nonatomic,copy)ZYDatabaseOperationUpdateSuccessBlock updateSuccess;

@property (nonatomic,copy)ZYDatabaseOperationFaildBlock faild;

@end
