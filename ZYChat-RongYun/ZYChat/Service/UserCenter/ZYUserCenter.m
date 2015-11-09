//
//  ZYUserCenter.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "ZYUserCenter.h"
#import "ZYFriendServiceManager.h"
#import "EaseMob.h"
#import "ZYDatabaseManager.h"

@interface ZYUserCenter ()

@property (nonatomic,strong)ZYUserModel *innerLoginUser;

@end

@implementation ZYUserCenter

+ (ZYUserCenter *)shareCenter
{
    static ZYUserCenter *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!_instance) {
            _instance = [[self alloc]init];
        }
    });
    
    return _instance;
}


- (void)registUser:(ZYUserModel *)aUser withResult:(void (^)(BOOL state))resultBlock
{
    ZYFriendServiceManager *friendManager = [[ZYFriendServiceManager alloc]init];
    
    [friendManager registUser:aUser withSuccess:^(ZYUserModel *resultUser) {
        
        self.innerLoginUser = resultUser;
        
        [self loginUser:aUser withResult:^(BOOL state) {
        
            
        }];
        
    } withFaild:^(NSError *error) {
        
        
    }];
}

- (void)loginTestUser
{
    ZYUserModel *aUser = [[ZYUserModel alloc]init];
    aUser.mobile = @"13810551569";
    aUser.password = @"123";
    
    [self loginUser:aUser withResult:^(BOOL state) {
        
    }];
}

- (void)loginUser:(ZYUserModel *)aUser withResult:(void(^)(BOOL state))resultBlock
{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:aUser.mobile password:aUser.password completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error) {
            
            NSLog(@"loginUser:%@",loginInfo);
            
        }else{
            
        }
        
    } onQueue:nil];
    
}

- (void)currentUserLoginEaseMob
{
    
}

- (ZYUserModel *)currentLoginUser
{
    return self.innerLoginUser;
}

- (void)createUserTable
{
    ZYDatabaseCRUDCondition *createTableCondition = [[ZYDatabaseCRUDCondition alloc]init];
    createTableCondition.action = ZYDatabaseActionCreateTable;
    createTableCondition.tableName = @"user";
    
    NSMutableArray *colunms = [NSMutableArray array];
    
    //用户Id
    ZYDatabaseColunmCondition *userId = [[ZYDatabaseColunmCondition alloc]init];
    userId.colunmName = @"user_id";
    userId.isAutoIncrease = YES;
    userId.isPrimary = YES;
    userId.isNotNull = YES;
    userId.valueType = ZYDatabaseValueTypeInt;
    [colunms addObject:userId];
    
    //用户名字
    ZYDatabaseColunmCondition *name = [[ZYDatabaseColunmCondition alloc]init];
    name.colunmName = @"name";
    name.valueType = ZYDatabaseValueTypeVarchar;
    name.limitLength = 30;
    [colunms addObject:name];
    
    createTableCondition.createColunmConditions = colunms;
    
    NSString *dbPath = GJCFAppCachePath(@"test.db");
    
    ZYDatabaseOperation *dbOperation = [[ZYDatabaseOperation alloc]init];
    dbOperation.dbPath = dbPath;
    dbOperation.actionCondition = createTableCondition;
    dbOperation.updateSuccess = ^(void){
      
        NSLog(@"创建表成功");
        
    };
    dbOperation.faild = ^(NSError *error){
      
        NSLog(@"%@",error.userInfo[@"msg"]);
        
    };
    
    [[ZYDatabaseManager shareManager] addOperation:dbOperation];
    
}

- (void)createUser
{
    NSString *dbPath = GJCFAppCachePath(@"test.db");

    ZYDatabaseCRUDCondition *curdCondition = [[ZYDatabaseCRUDCondition alloc]init];
    curdCondition.action = ZYDatabaseActionInsert;
    curdCondition.tableName = @"user";
    curdCondition.updateValues = @[
                                   @{
                                       @"name":@"vincent",
                                       
                                       },
                                   @{
                                       @"name":@"mike",
                                       
                                       },
                                   @{
                                       @"name":@"white",
                                       
                                       },
                                   @{
                                       @"name":@"black",
                                       
                                       },
                                   @{
                                       @"name":@"test1",
                                       
                                       },
                                   @{
                                       @"name":@"test2",
                                       
                                       },
                                   ];
    
    ZYDatabaseOperation *dbOperation = [[ZYDatabaseOperation alloc]init];
    dbOperation.dbPath = dbPath;
    dbOperation.actionCondition = curdCondition;
    
    [[ZYDatabaseManager shareManager] addOperation:dbOperation];
}

@end
