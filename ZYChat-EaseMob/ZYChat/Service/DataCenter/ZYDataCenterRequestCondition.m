//
//  ZYDataCenterRequestCondition.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "ZYDataCenterRequestCondition.h"

@implementation ZYDataCenterRequestCondition

- (instancetype)init
{
    if (self = [super init]) {
        
        self.requestMethod = ZYNetworkRequestMethodPOST;
    }
    return self;
}

- (void)addGetParams:(NSDictionary *)params
{
    NSMutableDictionary *mGetParams = [NSMutableDictionary dictionaryWithDictionary:self.getParams];
    [mGetParams addEntriesFromDictionary:params];
    self.getParams = mGetParams;
}

- (void)addPostParams:(NSDictionary *)params
{
    NSMutableDictionary *mPostParams = [NSMutableDictionary dictionaryWithDictionary:self.postParams];
    [mPostParams addEntriesFromDictionary:params];
    self.postParams = mPostParams;
}

@end
