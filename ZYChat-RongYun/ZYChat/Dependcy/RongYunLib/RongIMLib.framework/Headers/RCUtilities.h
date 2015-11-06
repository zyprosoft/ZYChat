/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCUtilities.h
//  Created by Heq.Shinoda on 14-5-15.

#ifndef __RCUtilities
#define __RCUtilities

#import <UIKit/UIKit.h>
#import "RCMessageContent.h"

#define __BASE64(text) [CommonFunc base64StringFromText:text]
#define __TEXT(base64) [CommonFunc textFromBase64String:base64]

@class RCMessageContent;

typedef uint32_t CCAlgorithm;
/**
 *  工具类
 */
@interface RCUtilities : NSObject
/**
 *  methodsInClass
 *
 *  @param aClass 类名
 *
 *  @return  methodArray
 */
+ (NSArray *)methodsInClass:(Class)aClass;
/**
 *  iVarsInClass
 *
 *  @param aClass 类名
 *
 *  @return  ivarsArray
 */
+ (NSArray *)iVarsInClass:(Class)aClass;
/**
 *  get currentSystemTime
 *
 *  @return currentSystemTime
 */
+ (NSString *)currentSystemTime;

// Base64 Encode & Decode

/**
 *  base64格式字符串转换为文本数据
 *
 *  @param  string 要转换的字符串
 *
 *  @return base64数据
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

/**
 *  文本数据转换为base64格式字符串
 *
 *  @param data 要转换的文本数据
 *
 *  @return 转换后的字符串
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

/**
 *  文本数据进行DES加密。备注：此函数不可用于过长文本。
 *
 *  @param data data
 *  @param key  key
 *
 *  @return (NSData *)
 */
+ (NSData *)desEncrypt:(NSData *)data WithKey:(NSString *)key;

/**
 *  文本数据进行DES解密。备注：此函数不可用于过长文本。
 *
 *  @param data data
 *  @param key  key
 *
 *  @return (NSData *)
 */
+ (NSData *)desDecrypt:(NSData *)data WithKey:(NSString *)key;

/**
 *  string to base64String
 *
 *  @param text 要转换的文本字符串
 *
 *  @return base64string
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 *  base64stirng to string
 *
 *  @param base64 string
 *
 *  @return string
 */
+ (NSString *)textFromBase64String:(NSString *)base64;

//+ (NSString *)obtainLegalUTF8String:(char *)rawstr length:(int)length;

/**
 *  scaleImage
 *
 *  @param image     image
 *  @param scaleSize scaleSize
 *
 *  @return scaled image
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/**
 *  imageByScalingAndCropSize
 *
 *  @param image      image
 *  @param targetSize targetSize
 *
 *  @return image
 */
+ (UIImage *)imageByScalingAndCropSize:(UIImage *)image targetSize:(CGSize)targetSize;

/**
 *  compressedImageWithMaxDataLength
 *
 *  @param image         image
 *  @param maxDataLength maxDataLength
 *
 *  @return nsdate
 */
+ (NSData *)compressedImageWithMaxDataLength:(UIImage *)image maxDataLength:(CGFloat)maxDataLength;

/**
 *  compressedImageAndScalingSize
 *
 *  @param image      image
 *  @param targetSize targetSize
 *  @param maxDataLen maxDataLen
 *
 *  @return image nsdata
 */
+ (NSData *)compressedImageAndScalingSize:(UIImage *)image targetSize:(CGSize)targetSize maxDataLen:(CGFloat)maxDataLen;
/**
 *  compressedImageAndScalingSize
 *
 *  @param image      image
 *  @param targetSize targetSize
 *  @param percent    percent
 *
 *  @return image nsdata
 */
+ (NSData *)compressedImageAndScalingSize:(UIImage *)image targetSize:(CGSize)targetSize percent:(CGFloat)percent;
/**
 *  excludeBackupKeyForURL
 *
 *  @param storageURL storageURL
 *
 *  @return BOOL
 */
+ (BOOL)excludeBackupKeyForURL:(NSURL *)storageURL;
/**
 *  applicationDocumentsDirectory
 *
 *  @return applicationDocumentsDirectory
 */
+ (NSString *)applicationDocumentsDirectory;
/**
 *  rongDocumentsDirectory
 *
 *  @return rongDocumentsDirectory
 */
+ (NSString *)rongDocumentsDirectory;
/**
 *  rongImageCacheDirectory
 *
 *  @return rongImageCacheDirectory
 */
+ (NSString *)rongImageCacheDirectory;

/**
 *  获取当前运营商名称
 *
 *  @return 当前运营商名称
 */
+ (NSString *)currentCarrier;

/**
 *  获取当前网络类型
 *
 *  @return 当前网络类型
 */
+ (NSString *)currentNetWork;

/**
 *  获取系统版本
 *
 *  @return 系统版本
 */
+ (NSString *)currentSystemVersion;

/**
 *  获取设备型号
 *
 *  @return 设备型号
 */
+ (NSString *)currentDeviceModel;

@end
#endif