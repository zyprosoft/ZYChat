//
//  GJCFAudioFileUitil.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFAudioModel.h"

@interface GJCFAudioFileUitil : NSObject

/* 设置本地缓存路径 */
+ (void)setupAudioFileLocalStorePath:(GJCFAudioModel*)audioFile;

/* 设置一个临时转编码文件的缓存地址 */
+ (void)setupAudioFileTempEncodeFilePath:(GJCFAudioModel*)audioFile;

/* 直接将一个文件的临时编码文件复制到本地缓存文件路径 */
+ (BOOL)saveAudioTempEncodeFileToLocalCacheDir:(GJCFAudioModel*)audioFile;

/* 远程地址和本地wav文件建立关系 */
+ (BOOL)createRemoteUrl:(NSString*)remoteUrl relationWithLocalWavPath:(NSString*)localWavPath;

/* 删掉一个对应关系 */
+ (BOOL)deleteShipForRemoteUrl:(NSString *)remoteUrl;

/* 检测本地有没有对应的wav文件，避免重复下载 */
+ (NSString *)localWavPathForRemoteUrl:(NSString *)remoteUrl;

/* 删除临时转码文件 */
+ (BOOL)deleteTempEncodeFileWithPath:(NSString *)tempEncodeFilePath;

/* 删除对应地址的Wav文件 */
+ (BOOL)deleteWavFileByUrl:(NSString *)remoteUrl;

@end
