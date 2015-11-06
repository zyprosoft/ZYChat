/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCPublicServiceMultiRichContentMessage.h
//  Created by litao on 15/4/13.

#import "RCMessageContent.h"
#define RCPublicServiceRichContentTypeIdentifier @"RC:PSMultiImgTxtMsg"

/**
 * 公众服务账号多图文消息
 */
@interface RCPublicServiceMultiRichContentMessage : RCMessageContent
/**
 *  消息内容
 *  类型是RCRichContentItem
 */
@property(nonatomic, strong) NSMutableArray *richConents;
/**
 *  附加信息
 */
@property(nonatomic, strong) NSString *extra;
@end
