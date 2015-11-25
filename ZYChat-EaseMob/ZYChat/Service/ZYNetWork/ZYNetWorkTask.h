//
//  ZYNetWorkTask.h
//  ZYNetwork
//
//  Created by ZYVincent QQ:1003081775 on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYNetWorkConst.h"

@class ZYNetWorkTask;

typedef void (^ZYNetWorkManagerTaskDidSuccessBlock) (ZYNetWorkTask *task, NSDictionary *response);

typedef void (^ZYNetWorkManagerTaskDidFaildBlock) (ZYNetWorkTask *task, NSError *error);

typedef void (^ZYNetWorkManagerTaskProgressBlock) (ZYNetWorkTask *task,CGFloat progress);


@interface ZYNetWorkTask : NSObject

/**
 *  任务优先级
 */
@property (nonatomic,assign)NSInteger priority;

/**
 *  任务唯一标示
 */
@property (nonatomic,readonly)NSString *taskIdentifier;

/**
 *  任务类型
 */
@property (nonatomic,assign)ZYNetworkTaskType taskType;

/**
 *  接口
 */
@property (nonatomic,strong)NSString *interface;

/**
 *  任务的主机地址
 */
@property (nonatomic,strong)NSString *host;

/**
 *  下载地址
 */
@property (nonatomic,strong)NSString *downloadUrl;

/**
 *  POST，GET
 */
@property (nonatomic,assign)ZYNetworkRequestMethod requestMethod;

/**
 *  get参数
 */
@property (nonatomic,strong)NSDictionary *getParams;

/**
 *  get参数字符串
 */
@property (nonatomic,strong)NSString *getParamString;

/**
 *  post参数
 */
@property (nonatomic,strong)NSDictionary *postParams;

/**
 *  request Header携带数据
 */
@property (nonatomic,strong)NSDictionary *headValues;

/**
 *  连接AFNetworking的任务标示
 */
@property (nonatomic,strong)NSString *taskAFNetworkOperationIdentifier;

/**
 *  用户自定义数据
 */
@property (nonatomic,strong)NSDictionary *userInfo;

/**
 *  任务状态
 */
@property (nonatomic,assign)ZYNetworkTaskState taskState;

/**
 *  拼接的请求地址
 */
@property (nonatomic,readonly)NSString *requestUrl;

/**
 *  成功回调
 */
@property (nonatomic,copy)ZYNetWorkManagerTaskDidSuccessBlock successBlock;

/**
 *  失败回调
 */
@property (nonatomic,copy)ZYNetWorkManagerTaskDidFaildBlock faildBlock;

/**
 *  进度回调
 */
@property (nonatomic,copy)ZYNetWorkManagerTaskProgressBlock progressBlock;

/**
 *  描述文本
 */
@property (nonatomic,readonly)NSString *descriptionString;

/**
 *  执行过程中被操作的日志
 */
@property (nonatomic,strong)NSMutableString *excutingLog;

//一组任务的标示
@property (nonatomic,strong)NSString *groupTaskIdentifier;

/**
 *  是否第三方请求任务
 */
@property (nonatomic,assign)BOOL isThirdPartyRequest;

+ (NSString *)taskTypeString:(ZYNetworkTaskType)type;

- (NSComparisonResult)compare:(ZYNetWorkTask *)task;

- (BOOL)isEqual:(ZYNetWorkTask *)task;

//是否一个相同的请求任务
- (BOOL)isEqualRequest:(ZYNetWorkTask *)task;

//添加动作轨迹
- (void)appendAction:(NSString *)action;

/**
 *  打印任务轨迹
 */
- (void)printTaskHistory;

@end
