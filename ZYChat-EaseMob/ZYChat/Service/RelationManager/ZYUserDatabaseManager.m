//
//  ZYUserDatabaseManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/17.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYUserDatabaseManager.h"
#import "ZYUserModel.h"

@implementation ZYUserDatabaseManager

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

- (BOOL)createUserTable
{
    ZYDatabaseCRUDCondition *createTable = [[ZYDatabaseCRUDCondition alloc]init];
    createTable.action = ZYDatabaseActionCreateTable;
    createTable.tableName = @"user";
    
    //列
    ZYDatabaseColunmCondition *userId = [[ZYDatabaseColunmCondition alloc]init];
    userId.colunmName = @"user_id";
    userId.isPrimary = YES;
    userId.valueType = ZYDatabaseValueTypeVarchar;
    userId.limitLength = 200;
    
    ZYDatabaseColunmCondition *mobile = [[ZYDatabaseColunmCondition alloc]init];
    mobile.colunmName = @"mobile";
    mobile.valueType = ZYDatabaseValueTypeVarchar;
    mobile.limitLength = 200;
    
    ZYDatabaseColunmCondition *headThumb = [[ZYDatabaseColunmCondition alloc]init];
    headThumb.colunmName = @"head_thumb";
    headThumb.valueType = ZYDatabaseValueTypeVarchar;
    headThumb.limitLength = 200;
    
    ZYDatabaseColunmCondition *userName = [[ZYDatabaseColunmCondition alloc]init];
    userName.colunmName = @"user_name";
    userName.valueType = ZYDatabaseValueTypeVarchar;
    userName.limitLength = 200;
    
    ZYDatabaseColunmCondition *nickName = [[ZYDatabaseColunmCondition alloc]init];
    nickName.colunmName = @"nickname";
    nickName.valueType = ZYDatabaseValueTypeVarchar;
    nickName.limitLength = 200;
    
    ZYDatabaseColunmCondition *sex = [[ZYDatabaseColunmCondition alloc]init];
    sex.colunmName = @"sex";
    sex.valueType = ZYDatabaseValueTypeVarchar;
    sex.limitLength = 200;
    
    ZYDatabaseColunmCondition *addTime = [[ZYDatabaseColunmCondition alloc]init];
    addTime.colunmName = @"add_time";
    addTime.valueType = ZYDatabaseValueTypeVarchar;
    addTime.limitLength = 200;
    
    ZYDatabaseColunmCondition *address = [[ZYDatabaseColunmCondition alloc]init];
    address.colunmName = @"address";
    address.valueType = ZYDatabaseValueTypeVarchar;
    address.limitLength = 500;
    
    ZYDatabaseColunmCondition *latitude = [[ZYDatabaseColunmCondition alloc]init];
    latitude.colunmName = @"latitude";
    latitude.valueType = ZYDatabaseValueTypeVarchar;
    latitude.limitLength = 30;
    
    ZYDatabaseColunmCondition *longtitude = [[ZYDatabaseColunmCondition alloc]init];
    longtitude.colunmName = @"longtitude";
    longtitude.valueType = ZYDatabaseValueTypeVarchar;
    longtitude.limitLength = 30;
    
    ZYDatabaseColunmCondition *lastTime = [[ZYDatabaseColunmCondition alloc]init];
    lastTime.colunmName = @"last_time";
    lastTime.valueType = ZYDatabaseValueTypeVarchar;
    lastTime.limitLength = 200;
    
    createTable.createColunmConditions = @[
                                           userId,
                                           headThumb,
                                           userName,
                                           mobile,
                                           nickName,
                                           sex,
                                           addTime,
                                           address,
                                           latitude,
                                           longtitude,
                                           lastTime,
                                           ];
    
    ZYDatabaseOperation *dbOperation = [[ZYDatabaseOperation alloc]init];
    dbOperation.actionCondition = createTable;
    
    __block BOOL resultState = NO;
    dbOperation.updateSuccess = ^(void){
        
        resultState = YES;
    };
    dbOperation.faild = ^(NSError *error){
        
        resultState = NO;
        
        NSLog(@"建用户表错误:%@",error);
        
    };
    
    [[ZYDatabaseManager shareManager] addOperation:dbOperation];
    
    return resultState;
}

- (void)insertUsers:(NSArray *)users
{
    ZYDatabaseCRUDCondition *insertAction = [[ZYDatabaseCRUDCondition alloc]init];
    insertAction.action = ZYDatabaseActionInsert;
    insertAction.tableName = @"user";
    
    NSMutableArray *userInfos = [NSMutableArray array];
    
    for (ZYUserModel *aUser in users) {
        
        NSLog(@"aUserDict :%@",[aUser toDictionary]);

        [userInfos addObject:[aUser toDictionary]];
    }
    insertAction.updateValues = userInfos;
    
    ZYDatabaseOperation *dbOperation = [[ZYDatabaseOperation alloc]init];
    dbOperation.actionCondition = insertAction;
    dbOperation.updateSuccess = ^(void){
        
        NSLog(@"创建用户成功");
        
    };
    
    dbOperation.faild = ^(NSError *error){
        
        NSLog(@"创建用户失败:%@",error);
    };
    
    [[ZYDatabaseManager shareManager] addOperation:dbOperation];
}

@end
