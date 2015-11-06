/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCRichContentItem.h
//  Created by Dulizhao on 15/4/21.

#import <Foundation/Foundation.h>

/**
 * 公众服务账号图文消息条目
 */
@interface RCRichContentItem : NSObject
/** 标题 */
@property(nonatomic, strong) NSString *title;
/** 摘要 */
@property(nonatomic, strong) NSString *digest;
/** 图片URL */
@property(nonatomic, strong) NSString *imageURL;
/** 跳转URL */
@property(nonatomic, strong) NSString *url;
/** 扩展信息 */
@property(nonatomic, strong) NSString *extra;

/**
 * 根据给定消息创建新消息
 *
 * @param  title       标题
 * @param  digest      摘要
 * @param  imageURL    图片URL
 * @param  extra       扩展信息
 */
+ (instancetype)messageWithTitle:(NSString *)title
                          digest:(NSString *)digest
                        imageURL:(NSString *)imageURL
                           extra:(NSString *)extra;
/**
 *  根据给定消息创建新消息
 *
 *  @param title    标题
 *  @param digest   摘要
 *  @param imageURL 图片URL
 *  @param url      url
 *  @param extra    扩展信息
 *
 *  @return message
 */
+ (instancetype)messageWithTitle:(NSString *)title
                          digest:(NSString *)digest
                        imageURL:(NSString *)imageURL
                             url:(NSString *)url
                           extra:(NSString *)extra;
@end
