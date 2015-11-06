//
//  RCRealTimeLocationEndMessage.h
//  RongIMLib
//
//  Created by 杜立召 on 15/8/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCMessageContent.h"

#define RCRealTimeLocationEndMessageTypeIdentifier @"RC:RLEnd"

/**
 * 地理位置结束消息
 */
@interface RCRealTimeLocationEndMessage : RCMessageContent
/**
 *  附加信息
 */
@property(nonatomic, strong) NSString *extra;
/**
 *  根据参数创建消息对象
 *
 *  @param extra  附加信息
 */
+ (instancetype)messageWithExtra:(NSString *)extra;
@end