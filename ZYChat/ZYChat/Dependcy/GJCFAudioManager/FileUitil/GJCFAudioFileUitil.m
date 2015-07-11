//
//  GJCFAudioFileUitil.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAudioFileUitil.h"
#import "GJCFEncodeAndDecode.h"
#import "GJCFUitils.h"
#import "GJCFCachePathManager.h"

/* 主缓存目录 */
static NSString *  GJCFAudioFileCacheDirectory = @"GJCFAudioFileCacheDirectory";

/* 保存转换编码后的音频文件 */
static NSString *  GJCFAudioFileCacheSubTempEncodeFileDirectory = @"GJCFAudioFileCacheSubTempEncodeFileDirectory";

/* 本地音频Wav文件和远程地址关系表 */
static NSString *  GJCFAudioFileRemoteLocalWavFileShipList = @"GJCFAudioFileRemoteLocalWavFileShipList.plist";

@implementation GJCFAudioFileUitil

#pragma mark - 创建缓存主目录
+ (NSString *)cacheDirectory
{
    /* 创建一个默认路径 */
    NSString *cacheDirectory = [[GJCFCachePathManager shareManager] mainAudioCacheDirectory];
    
    /* 创建一个存储临时转编码文件的子文件夹 */
    NSString *subTempFileDir = [cacheDirectory stringByAppendingPathComponent:GJCFAudioFileCacheSubTempEncodeFileDirectory];

    if (!GJCFFileDirectoryIsExist(subTempFileDir)) {
        GJCFFileDirectoryCreate(subTempFileDir);
    }
    
    return cacheDirectory;
}

#pragma mark - 公开方法


/* 创建一条新的录音文件存储路径 */
+ (NSString*)createAudioNewRecordLocalStorePath
{
    NSString *fileName = [NSString stringWithFormat:@"%@.wav",GJCFStringCurrentTimeStamp];
    
    return [[self cacheDirectory]stringByAppendingPathComponent:fileName];
}

+ (void)setupAudioFileLocalStorePath:(GJCFAudioModel*)audioFile
{
    if (!audioFile) {
        return;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",GJCFStringCurrentTimeStamp,audioFile.extensionName];

    audioFile.fileName = fileName;
    
    NSString *randomPath = [[self cacheDirectory]stringByAppendingPathComponent:fileName];
    
    audioFile.localStorePath = randomPath;
}

/* 设置一个临时转编码文件的缓存地址 */
+ (void)setupAudioFileTempEncodeFilePath:(GJCFAudioModel*)audioFile
{
    if (!audioFile) {
        return;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",GJCFStringCurrentTimeStamp,audioFile.tempEncodeFileExtensionName];

    audioFile.tempEncodeFileName = fileName;
    
    NSString *tempFilePath = [[[self cacheDirectory]stringByAppendingPathComponent:GJCFAudioFileCacheSubTempEncodeFileDirectory]stringByAppendingPathComponent:fileName];
    
    audioFile.tempEncodeFilePath = tempFilePath;
    
}

/* 直接将一个文件的临时编码文件复制到本地缓存文件路径 */
+ (BOOL)saveAudioTempEncodeFileToLocalCacheDir:(GJCFAudioModel*)audioFile
{
    if (!audioFile) {
        return NO;
    }
    
    if (!audioFile.tempEncodeFilePath) {
        return NO;
    }
    
    /* 如果没有本地缓存路径，那么创建一个 */
    if (!audioFile.localStorePath) {
        [GJCFAudioFileUitil setupAudioFileLocalStorePath:audioFile];
    }
    
    return GJCFFileCopyFileIsRemove(audioFile.tempEncodeFilePath, audioFile.localStorePath, audioFile.isDeleteWhileFinishConvertToLocalFormate);
}

/* 远程地址和本地wav文件建立关系 */
+ (BOOL)createRemoteUrl:(NSString*)remoteUrl relationWithLocalWavPath:(NSString*)localWavPath
{
    NSString *shipListFilePath = [[self cacheDirectory]stringByAppendingPathComponent:GJCFAudioFileRemoteLocalWavFileShipList];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:shipListFilePath]) {
        
        NSMutableDictionary *shipList = [NSMutableDictionary dictionary];
        [shipList setObject:localWavPath forKey:remoteUrl];
        
        NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:shipList];
        
       return [archieveData writeToFile:shipListFilePath atomically:YES];
    }
    
    NSData *listData = [NSData dataWithContentsOfFile:shipListFilePath];
    NSMutableDictionary *shipListDict = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    
    [shipListDict setObject:localWavPath forKey:remoteUrl];
    
    NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:shipListDict];

    return [archieveData writeToFile:shipListFilePath atomically:YES];
}

/* 删掉一个对应关系 */
+ (BOOL)deleteShipForRemoteUrl:(NSString *)remoteUrl
{
    NSString *shipListFilePath = [[self cacheDirectory]stringByAppendingPathComponent:GJCFAudioFileRemoteLocalWavFileShipList];

    /* 如果关系plist都不存在，那么肯定没有关系了 */
    if (![[NSFileManager defaultManager]fileExistsAtPath:shipListFilePath]) {
        
        return YES;
    }
    
    NSData *listData = [NSData dataWithContentsOfFile:shipListFilePath];
    NSMutableDictionary *shipListDict = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    
    [shipListDict removeObjectForKey:remoteUrl];
    
    NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:shipListDict];
    
    return [archieveData writeToFile:shipListFilePath atomically:YES];
}

/* 检测本地有没有对应的wav文件，避免重复下载 */
+ (NSString *)localWavPathForRemoteUrl:(NSString *)remoteUrl
{
    NSString *shipListFilePath = [[self cacheDirectory]stringByAppendingPathComponent:GJCFAudioFileRemoteLocalWavFileShipList];
    if (!shipListFilePath) {
        
        return nil;
    }
    
    NSData *listData = [NSData dataWithContentsOfFile:shipListFilePath];
    NSMutableDictionary *shipListDict = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    
    return [shipListDict objectForKey:remoteUrl];
}

/* 删除临时转码文件 */
+ (BOOL)deleteTempEncodeFileWithPath:(NSString *)tempEncodeFilePath
{
    if (!tempEncodeFilePath || [tempEncodeFilePath isEqualToString:@""]) {
        return YES;
    }
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:tempEncodeFilePath]) {
        return YES;
    }
    
    NSError *deleteError = nil;
    [[NSFileManager defaultManager] removeItemAtPath:tempEncodeFilePath error:&deleteError];
    
    if (deleteError) {
        
        NSLog(@"GJCFFileUitil 删除文件失败:%@",deleteError);
        
        return NO;
        
    }else{
        
        NSLog(@"GJCFFileUitil 删除文件成功:%@",tempEncodeFilePath);
        return YES;
    }
}

/* 删除对应地址的Wav文件 */
+ (BOOL)deleteWavFileByUrl:(NSString *)remoteUrl
{
    if (!remoteUrl) {
        return YES;
    }
    
    /* 获取对应的wav地址 */
    NSString *wavPath = [GJCFAudioFileUitil localWavPathForRemoteUrl:remoteUrl];
    
    if (!wavPath) {
        return YES;
    }
    
    /* 删除文件 */
    BOOL deleteFileResult = [self deleteTempEncodeFileWithPath:wavPath];
    
    if (deleteFileResult) {
        
        /* 删掉本地对应关系 */
       [self deleteShipForRemoteUrl:remoteUrl];
        
        return YES;
        
    }else{
        
        return YES;
    }
    
}

@end
