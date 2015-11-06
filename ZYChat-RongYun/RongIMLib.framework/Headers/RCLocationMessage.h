/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCLocationMessage.h
//  Created by Heq.Shinoda on 14-6-13.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RCMessageContent.h"
#define RCLocationMessageTypeIdentifier @"RC:LBSMsg"
/**
 *  地理位置消息
 */
@interface RCLocationMessage : RCMessageContent <NSCoding>
/**
 *  二维地理位置信息
 */
@property(nonatomic, assign) CLLocationCoordinate2D location;
/**
 *  地点名称
 */
@property(nonatomic, strong) NSString *locationName;
/**
 *  位置缩略图
 */
@property(nonatomic, strong) UIImage *thumbnailImage;

/**
 *  附加信息
 */
@property(nonatomic, strong) NSString *extra;

/**
 *  创建消息
 *
 * @param image 缩略图
 * @param location 二维地理位置信息
 * @param locationName 位置名称
 */
+ (instancetype)messageWithLocationImage:(UIImage *)image
                                location:(CLLocationCoordinate2D)location
                            locationName:(NSString *)locationName;

@end
