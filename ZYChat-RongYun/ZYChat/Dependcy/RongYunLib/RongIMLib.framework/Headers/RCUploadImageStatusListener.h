//
//  RCUploadImageStatusListener.h
//  RongIMLib
//
//  Created by litao on 15/8/28.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCMessage.h"

/**
 * 上传图片状态监听
 */
@interface RCUploadImageStatusListener : NSObject
/**
 *  获取实时
 *
 *  @param message        图片消息
 *  @param uploadProgress 上传进度block
 *  @param uploadSuccess  上传成功block
 *  @param uploadError    上传失败block
 *
 *  @return 上传图片监听对象
 */
- (instancetype)initWithMessage:(RCMessage *)message
                 uploadProgress:(void (^)(int progress))progressBlock
                  uploadSuccess:(void (^)(NSString *imageUrl))successBlock
                    uploadError:(void (^)(RCErrorCode errorCode))errorBlock;
/**
 *  待上传的图片消息
 */
@property (nonatomic, strong)RCMessage *currentMessage;

/**
 *  上传进度block，progress取值范围是0-100
 */
@property (nonatomic, strong)void (^updateBlock)(int progress);

/**
 *  上传成功block，imageUrl是上传图像的Url
 */
@property (nonatomic, strong)void (^successBlock)(NSString *imageUrl);

/**
 *  上传失败block，errorCode为非0整数 
 */
@property (nonatomic, strong)void (^errorBlock)(RCErrorCode errorCode);
@end
