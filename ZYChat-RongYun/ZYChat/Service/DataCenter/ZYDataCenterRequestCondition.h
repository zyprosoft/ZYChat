//
//  ZYDataCenterRequestCondition.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDataCenterInterface.h"
#import "ZYNetWorkConst.h"

@interface ZYDataCenterRequestCondition : NSObject

@property (nonatomic,assign)ZYDataCenterRequestType requestType;

@property (nonatomic,assign)ZYNetworkRequestMethod requestMethod;

@property (nonatomic,strong)NSDictionary *getParams;

@property (nonatomic,strong)NSDictionary *postParams;

- (void)addGetParams:(NSDictionary *)params;

- (void)addPostParams:(NSDictionary *)params;

@end
