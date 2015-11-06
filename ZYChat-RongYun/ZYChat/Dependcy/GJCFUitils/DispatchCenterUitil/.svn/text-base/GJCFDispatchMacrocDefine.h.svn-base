//
//  GJCFDispatchMacrocDefine.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-16.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

/**
 *  文件描述
 *
 *  这个工具类宏可以方便在各种队列中执行block,提供便捷的使用方法
 *  是对GCD的一个简单封装
 */

#import "GJCFDispatchCenterUitil.h"

/**
 *  主线程异步执行block
 */
#define GJCFAsyncMainQueue(block) [GJCFDispatchCenterUitil asyncMainQueue:block]

/**
 *  主线程延迟second秒异步执行block
 */
#define GJCFAsyncMainQueueDelay(second,block) [GJCFDispatchCenterUitil asyncMainQueue:block delay:second]

/**
 *  全局后台线程异步执行block
 */
#define GJCFAsyncGlobalBackgroundQueue(block) [GJCFDispatchCenterUitil asyncGlobalBackgroundQueue:block]

/**
 *  全局后台线程延迟second秒异步执行block
 */
#define GJCFAsyncGlobalBackgroundQueueDelay(second,block) [GJCFDispatchCenterUitil asyncGlobalBackgroundQueue:block delay:second]

/**
 *  全局高优先级线程异步执行block
 */
#define GJCFAsyncGlobalHighQueue(block) [GJCFDispatchCenterUitil asyncGlobalHighQueue:block]

/**
 *  全局高优先级线程延迟second秒异步执行block
 */
#define GJCFAsyncGlobalHighQueueDelay(second,block) [GJCFDispatchCenterUitil asyncGlobalHighQueue:block delay:second]

/**
 *  全局低优先级线程异步执行block
 */
#define GJCFAsyncGlobalLowQueue(block) [GJCFDispatchCenterUitil asyncGlobalLowQueue:block]

/**
 *  全局低优先级线程延迟second秒异步执行block
 */
#define GJCFAsyncGlobalLowQueueDelay(second,block) [GJCFDispatchCenterUitil asyncGlobalLowQueue:block delay:second]

/**
 *  全局默认线程异步执行block
 */
#define GJCFAsyncGlobalDefaultQueue(block) [GJCFDispatchCenterUitil asyncGlobalDefaultQueue:block]

/**
 *  全局默认线程延迟second秒异步执行block
 */
#define GJCFAsyncGlobalDefaultQueueDelay(second,block) [GJCFDispatchCenterUitil asyncGlobalDefaultQueue:block delay:second]

/**
 *  在queue线程队列异步执行block
 */
#define GJCFAsync(queue,block)  [GJCFDispatchCenterUitil asyncQueue:queue action:block]

/**
 *  在queue线程序延迟second秒异步执行block
 */
#define GJCFAsyncDelay(queue,second,block)  [GJCFDispatchCenterUitil asyncQueue:queue action:block delay:second]

/**
 *  只执行一次block,创建单例使用
 */
#define GJCFDispatchOnce(onceToken,block) [GJCFDispatchCenterUitil dispatchOnce:onceToken action:block]