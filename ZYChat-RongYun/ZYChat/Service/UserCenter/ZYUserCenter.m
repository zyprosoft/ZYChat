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
        
        if (resultBlock) {
            resultBlock(YES);
        }
        
    } withFaild:^(NSError *error) {
        
        if (resultBlock) {
            resultBlock(NO);
        }
        
    }];
}

- (void)loginUser:(ZYUserModel *)aUser withResult:(void(^)(BOOL state))resultBlock
{
    [[ZYUserCenter shareCenter] registUser:aUser withResult:^(BOOL state) {
                
        GJCFNotificationPost(ZYUserCenterLoginSuccessNoti);
        
        if (state) {
            
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:aUser.mobile password:@"123" completion:^(NSDictionary *loginInfo, EMError *error) {
                
                if (!error) {
                    
                    NSLog(@"loginUser:%@",loginInfo);
                    
                    if (resultBlock) {
                        resultBlock(YES);
                    }
                    
                }else{
                    
                    if (resultBlock) {
                        resultBlock(NO);
                    }
                }
                
            } onQueue:nil];
            
        }
        
    }];
}

- (void)currentUserLoginEaseMob
{
    
}

- (ZYUserModel *)currentLoginUser
{
    return self.innerLoginUser;
}

- (void)updateUsers
{
    ZYDatabaseCRUDCondition *curdCondition = [[ZYDatabaseCRUDCondition alloc]init];
    curdCondition.action = ZYDatabaseActionUpdate;
    curdCondition.tableName = @"user";
    curdCondition.updateValues = @[
                                   @{
                                       @"name":@"iverson-hutao",
                                       },
                                   ];
    
    //更新条件
    ZYDatabaseWhereCondition *whereCondition = [[ZYDatabaseWhereCondition alloc]init];
    whereCondition.operation = ZYDatabaseWhereOperationEqual;
    whereCondition.columName = @"age";
    whereCondition.value = @"33";
    curdCondition.andConditions = @[whereCondition];
    
    ZYDatabaseOperation *dbOperation = [[ZYDatabaseOperation alloc]init];
    dbOperation.actionCondition = curdCondition;
    
    [[ZYDatabaseManager shareManager] addOperation:dbOperation];
}

- (void)deleteUser
{
    ZYDatabaseCRUDCondition *curdCondition = [[ZYDatabaseCRUDCondition alloc]init];
    curdCondition.action = ZYDatabaseActionDelete;
    curdCondition.tableName = @"user";
    
    //更新条件
    ZYDatabaseWhereCondition *whereCondition = [[ZYDatabaseWhereCondition alloc]init];
    whereCondition.operation = ZYDatabaseWhereOperationEqual;
    whereCondition.columName = @"age";
    whereCondition.value = @"33";
    curdCondition.andConditions = @[whereCondition];
    
    ZYDatabaseOperation *dbOperation = [[ZYDatabaseOperation alloc]init];
    dbOperation.actionCondition = curdCondition;
    
    [[ZYDatabaseManager shareManager] addOperation:dbOperation];
}

- (void)queryUser
{
    ZYDatabaseCRUDCondition *curdCondition = [[ZYDatabaseCRUDCondition alloc]init];
    curdCondition.action = ZYDatabaseActionSelect;
    curdCondition.tableName = @"user";
    
    //更新条件
    ZYDatabaseWhereCondition *whereCondition = [[ZYDatabaseWhereCondition alloc]init];
    whereCondition.operation = ZYDatabaseWhereOperationBigger;
    whereCondition.columName = @"age";
    whereCondition.value = @"20";
    curdCondition.andConditions = @[whereCondition];
    
    ZYDatabaseOperation *dbOperation = [[ZYDatabaseOperation alloc]init];
    dbOperation.actionCondition = curdCondition;
    dbOperation.QuerySuccess = ^(FMResultSet *result){
      
        NSLog(@"result :%@",result);
        
        NSInteger count = 0;
        while ([result next]) {
            
            count ++;
            
            NSLog(@"result index count %ld",(long)count);
        }
    };
    
    [[ZYDatabaseManager shareManager] addOperation:dbOperation];
}

@end
