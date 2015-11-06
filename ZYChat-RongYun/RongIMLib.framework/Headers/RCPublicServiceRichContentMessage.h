/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCPublicServiceMultiRichContentMessage.h
//  Created by litao on 15/4/15.

#import "RCMessageContent.h"
#import "RCRichContentItem.h"
#define RCSingleNewsMessageTypeIdentifier @"RC:PSImgTxtMsg"

/**
 * 公众服务账号单图文消息
 */
@interface RCPublicServiceRichContentMessage : RCMessageContent

/**
 *  消息内容
 *  类型是RCRichContentItem
 */
@property(nonatomic, strong) RCRichContentItem *richConent;
/**
 *  附加信息
 */
@property(nonatomic, strong) NSString *extra;
@end
