//
//  ZYDataCenter.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
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
    
    NSLog(@"request url:%@",aTask.requestUrl);
    
    [[ZYNetWorkManager shareManager]addTask:aTask];
    
    return aTask.taskIdentifier;
}

- (void)cancelRequest:(NSString *)requestIdentifier
{
    [[ZYNetWorkManager shareManager]cancelTaskByIdentifier:requestIdentifier];
}

@end
