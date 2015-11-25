//
//  ZYDataCenter.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDataCenterInterface.h"
#import "ZYDataCenterRequestCondition.h"
#import "ZYNetWorkManager.h"

typedef void (^ZYServiceManagerRequestFaildBlock) (NSError *error);

typedef void (^ZYServiceManagerListModelResultSuccessBlock) (NSArray *modelArray);

typedef void (^ZYServiceManagerActionSuccessBlock) (NSString *result);

@interface ZYDataCenter : NSObject

+ (ZYDataCenter *)shareCenter;

- (NSString *)requestWithCondition:(ZYDataCenterRequestCondition*)condition
                    withSuccessBlock:(ZYNetWorkManagerTaskDidSuccessBlock)success
                      withFaildBlock:(ZYNetWorkManagerTaskDidFaildBlock)faild;

- (NSString *)thirdServerRequestWithCondition:(ZYDataCenterRequestCondition*)condition
                  withSuccessBlock:(ZYNetWorkManagerTaskDidSuccessBlock)success
                    withFaildBlock:(ZYNetWorkManagerTaskDidFaildBlock)faild;

- (void)cancelRequest:(NSString *)requestIdentifier;

@end
