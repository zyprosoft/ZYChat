//
//  GJCFCachePathManager.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-11-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFCachePathManager.h"
#import "GJCFUitils.h"

#define GJCFCachePathManagerMainCacheDirectory @"GJCFCachePathManagerMainCacheDirectory"

#define GJCFCachePathManagerMainImageCacheDirectory @"GJCFCachePathManagerMainImageCacheDirectory"

#define GJCFCachePathManagerMainAudioCacheDirectory @"GJCFCachePathManagerMainAudioCacheDirectory"

static NSString *  GJCFAudioFileCacheSubTempEncodeFileDirectory = @"GJCFAudioFileCacheSubTempEncodeFileDirectory";

@implementation GJCFCachePathManager

+ (GJCFCachePathManager *)shareManager
{
    static GJCFCachePathManager *_pathManager = nil;
    static dispatch_once_t onceToken;
    GJCFDispatchOnce(onceToken, ^{
        _pathManager = [[self alloc]init];
    });
    return _pathManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setupCacheDirectorys];
    }
    return self;
}

- (void)setupCacheDirectorys
{
    /* 主缓存目录 */
    if (!GJCFFileDirectoryIsExist([self mainCacheDirectory])) {
        GJCFFileDirectoryCreate([self mainCacheDirectory]);
    }
    
    /* 主图片缓存目录 */
    if (!GJCFFileDirectoryIsExist([self mainImageCacheDirectory])) {
        GJCFFileDirectoryCreate([self mainImageCacheDirectory]);
    }
    
    /* 主音频缓存目录 */
    if (!GJCFFileDirectoryIsExist([self mainAudioCacheDirectory])) {
        GJCFFileDirectoryCreate([self mainAudioCacheDirectory]);
    }
}

- (NSString *)mainCacheDirectory
{
    return GJCFAppCachePath(GJCFCachePathManagerMainCacheDirectory);
}

- (NSString *)mainImageCacheDirectory
{
    return [[self mainCacheDirectory]stringByAppendingPathComponent:GJCFCachePathManagerMainImageCacheDirectory];
}

- (NSString *)mainAudioCacheDirectory
{
    return [[self mainCacheDirectory]stringByAppendingPathComponent:GJCFCachePathManagerMainAudioCacheDirectory];
}

/* 主图片缓存下文件路径 */
- (NSString *)mainImageCacheFilePath:(NSString *)fileName
{
    if (GJCFStringIsNull(fileName)) {
        return nil;
    }
    return [[self mainImageCacheDirectory]stringByAppendingPathComponent:fileName];
}

/* 主音频缓存下文件路径 */
- (NSString *)mainAudioCacheFilePath:(NSString *)fileName
{
    if (GJCFStringIsNull(fileName)) {
        return nil;
    }
    return [[self mainAudioCacheDirectory]stringByAppendingPathComponent:fileName];
}

/* 在主缓存目录下面创建或者返回指定名字的目录路径 */
- (NSString *)createOrGetSubCacheDirectoryWithName:(NSString *)dirName
{
    if (GJCFStringIsNull(dirName)) {
        return nil;
    }
    NSString *dirPath = [[self mainCacheDirectory] stringByAppendingPathComponent:dirName];
    if (GJCFFileDirectoryIsExist(dirPath)) {
        return dirPath;
    }else{
        GJCFFileDirectoryCreate(dirPath);
        return dirPath;
    }
}

/* 在主图片缓存目录下返回或者创建指定目录名字的目录路径 */
- (NSString *)createOrGetSubImageCacheDirectoryWithName:(NSString *)dirName
{
    if (GJCFStringIsNull(dirName)) {
        return nil;
    }
    NSString *dirPath = [[self mainImageCacheDirectory] stringByAppendingPathComponent:dirName];
    if (GJCFFileDirectoryIsExist(dirPath)) {
        return dirPath;
    }else{
        GJCFFileDirectoryCreate(dirPath);
        return dirPath;
    }
}

/* 在主音频缓存目录下返回或者创建指定目录名字的目录路径 */
- (NSString *)createOrGetSubAudioCacheDirectoryWithName:(NSString *)dirName
{
    if (GJCFStringIsNull(dirName)) {
        return nil;
    }
    NSString *dirPath = [[self mainAudioCacheDirectory] stringByAppendingPathComponent:dirName];
    if (GJCFFileDirectoryIsExist(dirPath)) {
        return dirPath;
    }else{
        GJCFFileDirectoryCreate(dirPath);
        return dirPath;
    }
}

/* 主图片缓存目录下是否存在名为fileName的文件 */
- (BOOL)mainImageCacheFileExist:(NSString *)fileName
{
    return GJCFFileIsExist([self mainImageCacheFilePath:fileName]);
}

/* 主音频缓存目录下是否存在名为fileName的文件 */
- (BOOL)mainAudioCacheFileExist:(NSString *)fileName
{
    return GJCFFileIsExist([self mainAudioCacheFilePath:fileName]);
}

/* 为一个图片链接地址返回缓存路径 */
- (NSString *)mainImageCacheFilePathForUrl:(NSString *)url
{
    if (GJCFStringIsNull(url)) {
        return nil;
    }
    NSString *fileName = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [self mainImageCacheFilePath:fileName];
}

/* 为一个语音地址返回缓存路径 */
- (NSString *)mainAudioCacheFilePathForUrl:(NSString *)url
{
    if (GJCFStringIsNull(url)) {
        return nil;
    }
    NSString *fileName = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [self mainAudioCacheFilePath:fileName];
}

/* 确定主图片缓存下是否有链接为url的文件缓存  */
- (BOOL)mainImageCacheFileIsExistForUrl:(NSString *)url
{
    return GJCFFileIsExist([self mainImageCacheFilePathForUrl:url]);
}

/* 确定主语音缓存下是否有链接为url的文件缓存 */
- (BOOL)mainAudioCacheFileIsExistForUrl:(NSString *)url
{
    return GJCFFileIsExist([self mainAudioCacheFilePathForUrl:url]);
}

- (NSString *)mainAudioTempEncodeFile:(NSString *)fileName
{
    return [[self createOrGetSubAudioCacheDirectoryWithName:GJCFAudioFileCacheSubTempEncodeFileDirectory]stringByAppendingPathComponent:fileName];
}

@end
