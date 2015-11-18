//
//  ZYNetWorkManager.h
//  ZYNetwork
//
//  Created by ZYVincent on 15/7/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYNetWorkTask.h"

@interface ZYNetWorkManager : NSObject

+ (ZYNetWorkManager *)shareManager;

/**
 *  普通类型的任务
 *
 *  @param task
 *  @param successBlock
 *  @param faildBlock
 */
- (void)addTask:(ZYNetWorkTask *)task;

/**
 *  退出任务
 *
 *  @param taskIdentifier
 */
- (void)cancelTaskByIdentifier:(NSString *)taskIdentifier;

/**
 *  退出任务
 *
 *  @param task
 */
- (void)cancelTask:(ZYNetWorkTask *)task;

/**
 *  按照用户给的用户信息退出请求
 *
 *  @param userInfo
 */
- (void)cancelTaskByUserInfoValues:(NSDictionary *)userInfo;

/**
 *  取消一组相同标示的下载任务
 *
 *  @param groupTaskIdentifier
 */
- (void)cancelGroupTask:(NSString *)groupTaskIdentifier;

@end
