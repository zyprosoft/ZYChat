//
//  ZYDataCenterRequestCondition.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDataCenterInterface.h"
#import "ZYNetWorkConst.h"

@interface ZYDataCenterRequestCondition : NSObject

@property (nonatomic,assign)ZYDataCenterRequestType requestType;

@property (nonatomic,assign)ZYNetworkRequestMethod requestMethod;

@property (nonatomic,strong)NSDictionary *getParams;

@property (nonatomic,strong)NSDictionary *postParams;

@property (nonatomic,strong)NSString *thirdServerHost;

@property (nonatomic,strong)NSString *thirdServerInterface;

@property (nonatomic,strong)NSDictionary *headerValues;

@property (nonatomic,assign)BOOL isThirdPartRequest;

- (void)addGetParams:(NSDictionary *)params;

- (void)addPostParams:(NSDictionary *)params;

@end
