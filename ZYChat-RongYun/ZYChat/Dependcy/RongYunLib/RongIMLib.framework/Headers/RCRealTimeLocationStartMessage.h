//
//  RCRealTimeLocationStartMessage.h
//  RongIMLib
//
//  Created by litao on 15/7/14.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#define RCRealTimeLocationStartMessageTypeIdentifier @"RC:RLStart"

/**
 * 地理位置开始消息
 */
@interface RCRealTimeLocationStartMessage : RCMessageContent
/**
 *  附加信息
 */
@property(nonatomic, strong) NSString *extra;
/**
 *  根据参数创建消息对象
 *
 *  @param content  消息内容
 */
+ (instancetype)messageWithExtra:(NSString *)content;
@end
