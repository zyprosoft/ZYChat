//
//  ZYNetWorkTask.m
//  ZYNetwork
//
//  Created by ZYVincent QQ:1003081775 on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYNetWorkTask.h"
#import "GJCFUitils.h"

@implementation ZYNetWorkTask

- (instancetype)init
{
    if (self = [super init]) {
     
        _priority = -999;
        
        _taskState = ZYNetworkTaskStateWait;
        
        _taskIdentifier = GJCFStringCurrentTimeStamp;
        
        self.excutingLog = [[NSMutableString alloc]init];
        
        [self.excutingLog appendFormat:@"任务生成了编号: %@ \n",_taskIdentifier];
        
    }
    return self;
}

- (NSString *)requestUrl
{
    if (self.taskType == ZYNetworkTaskTypeDownloadFile) {
        
        return self.downloadUrl;
    }
    
    if (self.requestMethod == ZYNetworkRequestMethodPOST) {
     
        if ([[self.interface substringToIndex:1] isEqualToString:@"/"]) {
            return [NSString stringWithFormat:@"%@%@",self.host,self.interface];
        }
        return [NSString stringWithFormat:@"%@/%@",self.host,self.interface];
    }

    NSString *getParamsString = nil;
    
    if (self.getParams && self.getParams.count > 0) {
        
      getParamsString  = GJCFStringEncodeDict(self.getParams);

    }
    
    if ([[self.interface substringToIndex:1] isEqualToString:@"/"]) {
        
        
        if (getParamsString) {
            
            return [NSString stringWithFormat:@"%@%@?%@",self.host,self.interface,getParamsString];

        }
        
        return [NSString stringWithFormat:@"%@%@?%@",self.host,self.interface,getParamsString];

    }
    
    
    if (getParamsString) {
        
        return [NSString stringWithFormat:@"%@/%@?%@",self.host,self.interface,getParamsString];
        
    }
    
    return [NSString stringWithFormat:@"%@/%@?%@",self.host,self.interface,getParamsString];
}

- (NSComparisonResult)compare:(ZYNetWorkTask *)task
{
    NSComparisonResult result = self.priority < task.priority;
    
    return result;
}

- (BOOL)isEqual:(ZYNetWorkTask *)task
{
    return [self.taskIdentifier isEqualToString:task.taskIdentifier];
}

+ (NSString *)taskTypeString:(ZYNetworkTaskType)type
{
    NSDictionary *descDict = @{
                               @(ZYNetworkTaskTypeDownloadFile):@"下载图片",
                               @(ZYNetworkTaskTypeJsonRequest):@"Json接口请求",
                               };
    
    return [descDict objectForKey:@(type)];
}

- (NSString *)descriptionString
{
    return [NSString stringWithFormat:@"编号:%@ 的 %@",self.taskIdentifier,[ZYNetWorkTask taskTypeString:self.taskType]];
}

- (BOOL)isEqualRequest:(ZYNetWorkTask *)task
{
    if (![self.downloadUrl isEqualToString:task.downloadUrl]) {
        return NO;
    }
    
    if (![self.host isEqualToString:task.host]) {
        
        return NO;
    }
    
    if (![self.interface isEqualToString:task.interface]) {
        
        return NO;
    }
    
    if (![self.getParams isEqualToDictionary:task.getParams]) {
    
        return NO;
    }
    
    if (![self.postParams isEqualToDictionary:task.postParams]) {
        
        return NO;
    }
    
    if ( self.requestMethod != task.requestMethod) {
        
        return NO;
    }
    
    if (![self.headValues isEqualToDictionary:task.headValues]) {
        
        return NO;
    }
    
    return YES;
}

- (void)appendAction:(NSString *)action
{
//    [self.excutingLog appendString:action];
}

- (void)printTaskHistory
{
//    NSLog(@"%@",self.excutingLog);
}

@end
