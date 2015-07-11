//
//  GJCFCachePathManager.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-11-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJCFCachePathManager : NSObject

+ (GJCFCachePathManager *)shareManager;

/* 主缓存目录 */
- (NSString *)mainCacheDirectory;

/* 图片主缓存目录 */
- (NSString *)mainImageCacheDirectory;

/* 音频主缓存目录 */
- (NSString *)mainAudioCacheDirectory;

/* 主图片缓存下文件路径 */
- (NSString *)mainImageCacheFilePath:(NSString *)fileName;

/* 主音频缓存下文件路径 */
- (NSString *)mainAudioCacheFilePath:(NSString *)fileName;

/* 在主缓存目录下面创建或者返回指定名字的目录路径 */
- (NSString *)createOrGetSubCacheDirectoryWithName:(NSString *)dirName;

/* 在主图片缓存目录下返回或者创建指定目录名字的目录路径 */
- (NSString *)createOrGetSubImageCacheDirectoryWithName:(NSString *)dirName;

/* 在主音频缓存目录下返回或者创建指定目录名字的目录路径 */
- (NSString *)createOrGetSubAudioCacheDirectoryWithName:(NSString *)dirName;

/* 主图片缓存目录下是否存在名为fileName的文件 */
- (BOOL)mainImageCacheFileExist:(NSString *)fileName;

/* 主音频缓存目录下是否存在名为fileName的文件 */
- (BOOL)mainAudioCacheFileExist:(NSString *)fileName;

/* 为一个图片链接地址返回缓存路径 */
- (NSString *)mainImageCacheFilePathForUrl:(NSString *)url;

/* 为一个语音地址返回缓存路径 */
- (NSString *)mainAudioCacheFilePathForUrl:(NSString *)url;

/* 确定主图片缓存下是否有链接为url的文件缓存  */
- (BOOL)mainImageCacheFileIsExistForUrl:(NSString *)url;

/* 确定主语音缓存下是否有链接为url的文件缓存 */
- (BOOL)mainAudioCacheFileIsExistForUrl:(NSString *)url;

/* 获取主语音缓存下的临时编码文件路径 */
- (NSString *)mainAudioTempEncodeFile:(NSString *)fileName;

@end
