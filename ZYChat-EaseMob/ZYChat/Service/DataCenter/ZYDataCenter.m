//
//  ZYDataCenter.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYDataCenter.h"

@implementation ZYDataCenter

+ (ZYDataCenter *)shareCenter
{
    static ZYDataCenter *_dataCenter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _dataCenter = [[self alloc]init];
    });
    
    return _dataCenter;
}

- (NSString *)requestWithCondition:(ZYDataCenterRequestCondition*)condition
                    withSuccessBlock:(ZYNetWorkManagerTaskDidSuccessBlock)success
                      withFaildBlock:(ZYNetWorkManagerTaskDidFaildBlock)faild
{
    ZYNetWorkTask *aTask = [[ZYNetWorkTask alloc]init];
    aTask.interface = [ZYDataCenterInterface urlWithRequestType:condition.requestType];
    aTask.host = ZYDataCenterServerHost;
    aTask.postParams = condition.postParams;
    aTask.successBlock = success;
    aTask.faildBlock = faild;
    aTask.taskType = ZYNetworkTaskTypeJsonRequest;
    aTask.requestMethod = condition.requestMethod;
    aTask.getParams = condition.getParams;
    
    NSLog(@"request url:%@",aTask.requestUrl);
    
    [[ZYNetWorkManager shareManager]addTask:aTask];
    
    return aTask.taskIdentifier;
}

- (NSString *)thirdServerRequestWithCondition:(ZYDataCenterRequestCondition*)condition
                             withSuccessBlock:(ZYNetWorkManagerTaskDidSuccessBlock)success
                               withFaildBlock:(ZYNetWorkManagerTaskDidFaildBlock)faild
{
    ZYNetWorkTask *aTask = [[ZYNetWorkTask alloc]init];
    aTask.interface = [ZYDataCenterInterface urlWithRequestType:condition.requestType];
    aTask.host = condition.thirdServerHost;
    aTask.interface = condition.thirdServerInterface;
    aTask.postParams = condition.postParams;
    aTask.getParams = condition.getParams;
    aTask.successBlock = success;
    aTask.faildBlock = faild;
    aTask.taskType = ZYNetworkTaskTypeJsonRequest;
    aTask.requestMethod = condition.requestMethod;
    aTask.headValues = condition.headerValues;
    aTask.isThirdPartyRequest = condition.isThirdPartRequest;
    
    NSLog(@"third server request url:%@",aTask.requestUrl);
    
    [[ZYNetWorkManager shareManager]addTask:aTask];
    
    return aTask.taskIdentifier;
}

- (void)cancelRequest:(NSString *)requestIdentifier
{
    [[ZYNetWorkManager shareManager]cancelTaskByIdentifier:requestIdentifier];
}

@end
