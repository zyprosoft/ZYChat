//
//  RCRealTimeLocationManager.h
//  RongIMLib
//
//  Created by litao on 15/7/14.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCIMClient.h"

#import <CoreLocation/CoreLocation.h>

/**
 *  @enum 实时位置共享状态
 */
typedef NS_ENUM(NSInteger, RCRealTimeLocationStatus) {
    /**
     *  实时位置共享，初始状态
     */
    RC_REAL_TIME_LOCATION_STATUS_IDLE,
    /**
     *  实时位置共享，接收状态
     */
    RC_REAL_TIME_LOCATION_STATUS_INCOMING,
    /**
     *  实时位置共享，发起状态
     */
    RC_REAL_TIME_LOCATION_STATUS_OUTGOING,
    /**
     *  实时位置共享，共享状态
     */
    RC_REAL_TIME_LOCATION_STATUS_CONNECTED
};

/**
 *  @enum 实时位置共享错误码
 */
typedef NS_ENUM(NSInteger, RCRealTimeLocationErrorCode) {
    /**
     *  当前设备不支持实时位置共享
     */
    RC_REAL_TIME_LOCATION_NOT_SUPPORT,
    /**
     *  当前会话不支持实时位置共享
     */
    RC_REAL_TIME_LOCATION_CONVERSATION_NOT_SUPPORT,
    /**
     *  当前会话超出了参与者人数限制
     */
    RC_REAL_TIME_LOCATION_EXCEED_MAX_PARTICIPANT,
    /**
     *  获取当前会话信息失败
     */
    RC_REAL_TIME_LOCATION_GET_CONVERSATION_FAILURE,
};

/**
 *  @protocol  实时位置共享监听器
 */
@protocol RCRealTimeLocationObserver <NSObject>
@optional
/**
 *  实时位置共享状态改变的处理
 *
 *  @param status   当前实时位置共享状态
 */
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status;
/**
 *  参与者位置发生变化后执行
 *
 *  @param location 参与者的当前位置
 *  @param userId   位置发生变化的参与者的用户ID
 */
- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId;
/**
 *  有参与者加入实时位置共享后执行
 *
 *  @param userId   加入实时位置共享的参与者的用户ID
 */
- (void)onParticipantsJoin:(NSString *)userId;
/**
 *  有参与者退出实时位置共享后执行
 *
 *  @param userId   退出实时位置共享的参与者的用户ID
 */
- (void)onParticipantsQuit:(NSString *)userId;
/**
 *  更新位置信息失败后执行
 *
 *  @param description  失败信息
 */
- (void)onUpdateLocationFailed:(NSString *)description;
/**
 *  发起实时位置共享失败后执行
 *
 *  @param messageId  发起失败的消息 Id
 */
- (void)onStartRealTimeLocationFailed:(long)messageId;
@end

/**
 *  实时位置共享代理
 */
@protocol RCRealTimeLocationProxy <NSObject>
/**
 *  发起实时位置共享
 */
- (void)startRealTimeLocation;
/**
 *  加入实时位置共享
 */
- (void)joinRealTimeLocation;
/**
 *  退出实时位置共享
 */
- (void)quitRealTimeLocation;
/**
 *  注册实时位置共享监听
 *
 *  @param delegate 实时位置共享监听
 */
- (void)addRealTimeLocationObserver:(id<RCRealTimeLocationObserver>)delegate;
/**
 *  移除实时位置共享监听
 *
 *  @param delegate 实时位置共享监听
 */
- (void)removeRealTimeLocationObserver:(id<RCRealTimeLocationObserver>)delegate;
/**
 *  获取当前实时位置共享的参与者列表
 *
 *  @return 当前参与者列表
 */
- (NSArray *)getParticipants;
/**
 *  获取当前实时位置共享状态
 *
 *  @return 当前实时位置共享状态
 */
- (RCRealTimeLocationStatus)getStatus;
/**
 *  获取参与者的当前位置
 *
 *  @param userId   需要获取参与者的用户ID
 *
 *  @return 该参与者的位置信息
 */
- (CLLocation *)getLocation:(NSString *)userId;
@end


/**
 * 地理位置共享管理类
 */
@interface RCRealTimeLocationManager : NSObject
/**
 *  获取实时位置共享的核心类单例
 *
 *  @return 实时位置共享的核心类单例
 */
+ (instancetype)sharedManager;

/**
 *  获取实时位置共享的代理
 *
 *  @param conversationType 会话类型
 *  @param targetId         目标会话ID
 *  @param successBlock     获取代理成功的处理
 *  @param errorBlock       获取代理失败的处理
 */
- (void)getRealTimeLocationProxy:(RCConversationType)conversationType
                                         targetId:(NSString *)targetId
                                          success:(void (^)(id<RCRealTimeLocationProxy> locationShare))successBlock
                                            error:(void (^)(RCRealTimeLocationErrorCode status))errorBlock;

@end
