/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCContactInfo.h
//  Created by xugang on 5/8/15.

#import <Foundation/Foundation.h>
/**
 *  联系信息类
 */
@interface RCContactInfo : NSObject
/**
 *  电话
 */
@property(nonatomic, copy) NSString *tel;
/**
 *  邮箱
 */
@property(nonatomic, copy) NSString *email;
/**
 *  地址
 */
@property(nonatomic, copy) NSString *address;
/**
 *  QQ
 */
@property(nonatomic, copy) NSString *qq;
/**
 *  微博ID
 */
@property(nonatomic, copy) NSString *weiBo;
/**
 *  微信号
 */
@property(nonatomic, copy) NSString *weiXin;

@end
