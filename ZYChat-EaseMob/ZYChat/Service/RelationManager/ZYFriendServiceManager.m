//
//  ZYFriendServiceManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYFriendServiceManager.h"
#import "ZYDataCenter.h"

@implementation ZYFriendServiceManager

- (void)registUser:(ZYUserModel *)aUser withSuccess:(void (^)(ZYUserModel *resultUser))success withFaild:(void (^)(NSError *error))faild
{
    ZYDataCenterRequestCondition *condition = [[ZYDataCenterRequestCondition alloc]init];
    condition.requestType = ZYDataCenterRequestTypeRegist;
    condition.postParams = @{
                             @"mobile":aUser.mobile,
                             @"password":@"123",
                             };
    
    [[ZYDataCenter shareCenter] requestWithCondition:condition withSuccessBlock:^(ZYNetWorkTask *task, NSDictionary *response) {
        
        ZYUserModel *resultUser = [[ZYUserModel alloc]initWithDictionary:response error:nil];
        
        if (success) {
            success(resultUser);
        }
        
    } withFaildBlock:^(ZYNetWorkTask *task, NSError *error) {
        
        if (faild) {
            faild(error);
        }
        
    }];
}

- (void)allUsrListWithSuccess:(ZYServiceManagerListModelResultSuccessBlock)success withFaild:(ZYServiceManagerRequestFaildBlock)faild
{
    ZYDataCenterRequestCondition *condition = [[ZYDataCenterRequestCondition alloc]init];
    condition.requestType = ZYDataCenterRequestTypeAllUserList;
    condition.postParams = @{
                             @"page":@"0",
                             @"page_count":@"10",
                             };
    
    [[ZYDataCenter shareCenter] requestWithCondition:condition withSuccessBlock:^(ZYNetWorkTask *task, NSDictionary *response) {
        
        NSArray *userList = (NSArray *)response;
        
        NSMutableArray *modelList = [NSMutableArray array];
        
        for(NSDictionary *item in userList){
            
            NSError *jsonErr = nil;
            ZYUserModel *aUsrModel = [[ZYUserModel alloc]initWithDictionary:item error:&jsonErr];
            
            if (!jsonErr) {
        
                [modelList addObject:aUsrModel];
            }
            
        }
        
        if (success) {
            success(modelList);
        }
        
    } withFaildBlock:^(ZYNetWorkTask *task, NSError *error) {
        
        if (faild) {
            faild(error);
        }
        
    }];
}

- (void)friendList
{
    
}

- (void)friendApplyList
{
    
}

- (void)approveFriendApply:(ZYUserModel *)friendUser
{
    
}

@end
