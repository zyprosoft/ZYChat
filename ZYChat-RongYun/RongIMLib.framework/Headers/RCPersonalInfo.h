/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCPersonalInfo.h
//  Created by xugang on 5/8/15.

#import <Foundation/Foundation.h>
/**
 *  个人信息类
 */
@interface RCPersonalInfo : NSObject
/**
 *  真实姓名
 */
@property(nonatomic, copy) NSString *realName;
/**
 *  性别
 */
@property(nonatomic, copy) NSString *sex;
/**
 *  生日
 */
@property(nonatomic, copy) NSString *birthday;
/**
 *  年龄
 */
@property(nonatomic, copy) NSString *age;
/**
 *  职业
 */
@property(nonatomic, copy) NSString *job;
/**
 *  头像URL
 */
@property(nonatomic, copy) NSString *portraitUri;
/**
 *  备注
 */
@property(nonatomic, copy) NSString *comment;

@end
