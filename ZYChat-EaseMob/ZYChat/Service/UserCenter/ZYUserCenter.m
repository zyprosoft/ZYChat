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

#define kZYUserCenterLoginUserDir     @"LoginUserDir"
#define kZYUserCenterLastLoginUserUDF @"kZYUserCenterLastLoginUserUDF"

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

- (instancetype)init
{
    if (self = [super init]) {
        
        [self readLastLoginUser];
    }
    return self;
}

- (void)registUserWithMobile:(NSString *)mobile withPassword:(NSString *)password withSuccess:(ZYUserCenterRequestSuccessBlock)success withFaild:(ZYUserCenterRequestFaildBlock)faild
{
    ZYDataCenterRequestCondition *condition = [[ZYDataCenterRequestCondition alloc]init];
    condition.requestType = ZYDataCenterRequestTypeRegist;
    condition.postParams = @{
                             @"mobile":mobile,
                             @"password":password,
                             };
    
    [[ZYDataCenter shareCenter] requestWithCondition:condition withSuccessBlock:^(ZYNetWorkTask *task, NSDictionary *response) {
        
        self.innerLoginUser = [[ZYUserModel alloc]initWithDictionary:response error:nil];
        [self saveCurrentLoginUser];
        [self saveUserPassword:self.innerLoginUser.userId password:password];

        if (success) {
            success(@"登录成功");
        }
        
    } withFaildBlock:^(ZYNetWorkTask *task, NSError *error) {
        
        if (faild) {
            faild(error);
        }
        
    }];

}

- (void)LoginUserWithMobile:(NSString *)mobile withPassword:(NSString *)password withSuccess:(ZYUserCenterRequestSuccessBlock)success withFaild:(ZYUserCenterRequestFaildBlock)faild
{
    ZYDataCenterRequestCondition *condition = [[ZYDataCenterRequestCondition alloc]init];
    condition.requestType = ZYDataCenterRequestTypeRegist;
    condition.postParams = @{
                             @"mobile":mobile,
                             @"password":password,
                             };
    
    [[ZYDataCenter shareCenter] requestWithCondition:condition withSuccessBlock:^(ZYNetWorkTask *task, NSDictionary *response) {
        
        self.innerLoginUser = [[ZYUserModel alloc]initWithDictionary:response error:nil];
        
        //保存登录用户
        [self saveCurrentLoginUser];
        [self saveUserPassword:self.innerLoginUser.userId password:password];
        
        if (success) {
            success(@"注册成功");
        }
        
        GJCFNotificationPost(ZYUserCenterLoginSuccessNoti);
        
        

        
    } withFaildBlock:^(ZYNetWorkTask *task, NSError *error) {
        
        if (faild) {
            faild(error);
        }
        
    }];
}


- (ZYUserModel *)currentLoginUser
{
    return self.innerLoginUser;
}

- (BOOL)isLogin
{
    return self.innerLoginUser? YES:NO;
}

- (NSString *)userSavePath:(NSString *)userId
{
    NSString *cacheDir = GJCFAppCachePath(kZYUserCenterLoginUserDir);
    if (!GJCFFileDirectoryIsExist(cacheDir)) {
        GJCFFileDirectoryCreate(cacheDir);
    }
    
    return [cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.md5",userId]];
}

- (void)saveUserPassword:(NSString *)userId password:(NSString *)password
{
    NSString *passKey = [NSString stringWithFormat:@"%@_kZYUserCenterLastLoginUserPassUDF",userId];

    GJCFUDFCache(passKey, password);
}

- (NSString *)getUserPassword:(NSString *)userId
{
    NSString *passKey = [NSString stringWithFormat:@"%@_kZYUserCenterLastLoginUserPassUDF",userId];

    return GJCFUDFGetValue(passKey);
}

- (void)saveCurrentLoginUser
{
    if (!self.innerLoginUser) {
        return;
    }
    
    NSDictionary *userInfo = [self.innerLoginUser toDictionary];
    
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];

    [userData writeToFile:[self userSavePath:self.innerLoginUser.userId] atomically:YES];
    
    GJCFUDFCache(kZYUserCenterLastLoginUserUDF, self.innerLoginUser.userId);
}

- (void)readLastLoginUser
{
    NSString *userId = GJCFUDFGetValue(kZYUserCenterLastLoginUserUDF);
    
    if (GJCFStringIsNull(userId)) {
        return;
    }
    
    NSData *userData = [NSData dataWithContentsOfFile:[self userSavePath:userId]];
    
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    self.innerLoginUser = [[ZYUserModel alloc]initWithDictionary:userInfo error:nil];
}

- (void)autoLogin
{
    if (!self.innerLoginUser) {
        return;
    }
    
    NSString *password = [self getUserPassword:self.innerLoginUser.userId];
    [self loginEaseMobWithMobile:self.innerLoginUser.mobile password:password];
}

- (void)loginEaseMobWithMobile:(NSString *)mobile password:(NSString *)password
{
    GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(2)});
   
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:mobile password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error) {
            
            GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(1)});
            
            NSLog(@"loginUser:%@",loginInfo);
            
            NSLog(@"登录环信成功");
            
        }else{
            
            NSLog(@"登录环信失败");
            
            GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(0)});

        }
        
    } onQueue:nil];
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
