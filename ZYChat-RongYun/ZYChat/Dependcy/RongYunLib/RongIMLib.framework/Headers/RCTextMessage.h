/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCTextMessage.h
//  Created by Heq.Shinoda on 14-6-13.

#import "RCMessageContent.h"
#define RCTextMessageTypeIdentifier @"RC:TxtMsg"
/**
 *  文本消息类定义
 */
@interface RCTextMessage : RCMessageContent <NSCoding>
/** 文本消息内容 */
@property(nonatomic, strong) NSString *content;

/**
 *  附加信息
 */
@property(nonatomic, strong) NSString *extra;

/**
 *  根据参数创建文本消息对象
 *
 *  @param content  文本消息内容
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end
