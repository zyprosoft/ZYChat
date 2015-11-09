//
//  ZYDatabaseManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
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
    
    [findQueue inDatabase:^(FMDatabase *db) {
        
        switch (operation.actionCondition.action) {
            case ZYDatabaseActionCreateTable:
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
            case ZYDatabaseActionInsert:
            {
                [db beginTransaction];
                
                @try {
                    
                    for (NSString *sql in operation.actionCondition.updateMutilRowSqls) {
                        
                        [db executeUpdate:sql];
                        
                    }
                }
                @catch (NSException *exception) {
                    
                    [db rollback];
                    
                }
                @finally {
                    
                    [db commit];
                }
                
            }
                break;
            case ZYDatabaseActionUpdate:
            {
                
            }
                break;
            default:
                break;
        }
        
    }];
}

@end
