/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCMessageContent.h
//  Created by Heq.Shinoda on 14-6-13.

#ifndef __RCMessageContent
#define __RCMessageContent

#import <Foundation/Foundation.h>
#import "RCStatusDefine.h"
#import "RCUserInfo.h"

/**
 *  @protocol RCMessageCoding
 *  用于 @class RCMessageContent 的派生类实现具体消息内容编解码
 */
@protocol RCMessageCoding <NSObject>
@required
/**
 *  编码将当前对象转成JSON数据
 *  @return 编码后的JSON数据
 */
- (NSData *)encode;

/**
 *  根据给定的JSON数据设置当前实例
 *  @param data 传入的JSON数据
 */
- (void)decodeWithData:(NSData *)data;

/**
 *  应返回消息名称，此字段需个平台保持一致
 *  @return 消息体名称
 */
+ (NSString *)getObjectName;

@end

/**
 *  @protocol RCMessagePersistentCompatible
 *  RCMessageContent 已经实现此协议方法，派生类需按照自己需求重新覆盖实现，
 */
@protocol RCMessagePersistentCompatible <NSObject>
@required
/**
 *  返回遵循此protocol的类对象持久化的标识
 *
 *  @return 返回持久化设定标识
 *   @discussion   默认实现返回 @const (MessagePersistent_ISPERSISTED |
 *  MessagePersistent_ISCOUNTED)
 */
+ (RCMessagePersistent)persistentFlag;
@end

/**
 *  消息体基类
 *
 *  @discussion 所有自定义消息需继承此类，并当实现其遵循的两个协议接口
 */
@interface RCMessageContent : NSObject <RCMessageCoding, RCMessagePersistentCompatible> {
  @private
    NSString *_targetId;
}

/**
 *  发送者信息
 */
@property(nonatomic, strong) RCUserInfo *senderUserInfo;

/**
 *  decode用户信息
 *
 *  @param dictionary  用户信息字典
 */
-(void)decodeUserInfo:(NSDictionary *)dictionary;

/** 原始JSON数据，如果encode和decode失败，此基类会将服务器返回的JSON存到此字段
 */
@property(nonatomic, strong, setter=setRawJSONData:) NSData *rawJSONData;

@end
#endif