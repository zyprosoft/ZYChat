//
//  ZYDatabaseManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYDatabaseManager.h"
#import "FMDB.h"

@interface ZYDatabaseManager ()

@property (nonatomic,strong)NSMutableArray *databasePools;

@end

@implementation ZYDatabaseManager

+ (ZYDatabaseManager *)shareManager
{
    static ZYDatabaseManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manager = [[self alloc]init];
        
    });
    
    return _manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.databasePools = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)addOperation:(ZYDatabaseOperation *)operation
{
    FMDatabaseQueue *findQueue = nil;
    for (FMDatabaseQueue *dbQueue in self.databasePools) {
        
        if ([dbQueue.path isEqualToString:operation.dbPath]) {
            findQueue = dbQueue;
            break;
        }
    }
    
    //如果能找到对应的数据库路径
    if (!findQueue) {
        
        //创建一个新的库
        FMDatabaseQueue *queue = [[FMDatabaseQueue alloc]initWithPath:operation.dbPath];
        [self.databasePools addObject:queue];
        NSLog(@"dbPath:%@",operation.dbPath);
        
        findQueue = queue;
    }
    
    //操作条件是否合法
    if (!operation.actionCondition.isValidate) {
        if (operation.faild) {
            operation.faild([NSError errorWithDomain:@"com.ZYDatabaseManager.error" code:-888 userInfo:@{@"errMsg":operation.actionCondition.conditionErrorMsg}]);
        }
        return;
    }
    
    [findQueue inDatabase:^(FMDatabase *db) {
        
        //数据库是否打开
        if (![db open]) {
            if (operation.faild) {
                operation.faild([NSError errorWithDomain:@"com.ZYDatabaseManager.error" code:-888 userInfo:@{@"errMsg":@"数据库未打开"}]);
            }
            return ;
        }
        
        switch (operation.actionCondition.action) {
            case ZYDatabaseActionCreateTable:
            case ZYDatabaseActionDelete:
            {
                BOOL result = [db executeUpdate:operation.actionCondition.sqlString];
                
                if (result) {
                    
                    if (operation.updateSuccess) {
                        
                        operation.updateSuccess();
                    }
                    
                }else{
                    
                    if (operation.faild) {
                        
                        operation.faild([NSError errorWithDomain:@"ZYDatabaseManager" code:999 userInfo:@{@"msg":@"数据库执行失败"}]);
                    }
                }
                
            }
                break;
            case ZYDatabaseActionSelect:
            {
                FMResultSet *resultSet = [db executeQuery:operation.actionCondition.sqlString];
                
                if (resultSet) {
                    
                    if (operation.QuerySuccess) {
                        
                        operation.QuerySuccess(resultSet);
                    }
                    
                }else{
                    
                    if (operation.faild) {
                        
                        operation.faild([NSError errorWithDomain:@"ZYDatabaseManager" code:999 userInfo:@{@"msg":@"数据库执行失败"}]);
                    }
                }

            }
                break;
            case ZYDatabaseActionInsert:
            {
                [db beginTransaction];
                
                BOOL isRollBack = NO;
                
                @try {
                    
                    for (NSArray *valueItem in operation.actionCondition.updateFormateValues) {
                        
                        [db executeUpdate:operation.actionCondition.updateFormatSql withArgumentsInArray:valueItem];
                        
                    }
                }
                @catch (NSException *exception) {
                    
                    isRollBack = YES;
                    
                    [db rollback];
                    
                }
                @finally {
                    
                    if (!isRollBack) {
                        
                        [db commit];
                        
                        if (operation.updateSuccess) {
                            
                            operation.updateSuccess();
                        }
                        
                    }else{
                        
                        if (operation.faild) {
                            
                            operation.faild([NSError errorWithDomain:@"ZYDatabaseManager" code:999 userInfo:@{@"msg":@"数据库执行失败"}]);
                        }
                    }
                }
            }
                break;
            case ZYDatabaseActionUpdate:
            {
                [db beginTransaction];
                
                BOOL isRollBack = NO;
                
                @try {
                    
                    for (NSDictionary *valueItem in operation.actionCondition.updateValues) {
                        
                        [db executeUpdate:operation.actionCondition.updateFormatSql withArgumentsInArray:valueItem.allValues];
                        
                    }
                }
                @catch (NSException *exception) {
                    
                    isRollBack = YES;
                    
                    [db rollback];
                    
                }
                @finally {
                    
                    if (!isRollBack) {
                        
                        [db commit];
                        
                        if (operation.updateSuccess) {
                            
                            operation.updateSuccess();
                        }
                        
                    }else{
                        
                        if (operation.faild) {
                            
                            operation.faild([NSError errorWithDomain:@"ZYDatabaseManager" code:999 userInfo:@{@"msg":@"数据库执行失败"}]);
                        }
                    }
                    
                    
                }
            }
                break;
            default:
                break;
        }
        
    }];
}

@end
