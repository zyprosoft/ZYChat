//
//  GJGCGIFLoadManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/6/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCGIFLoadManager.h"

#define GJGCGIFEmojiDownloadCacheDirectory @"GJGCGIFEmojiDownloadCacheDirectory"

@implementation GJGCGIFLoadManager

+ (NSString *)createGifCacheDirectory
{
    NSString *gifEmojiCacheDirectory = [[GJCFCachePathManager shareManager]createOrGetSubCacheDirectoryWithName:GJGCGIFEmojiDownloadCacheDirectory];
    
    if (!GJCFFileDirectoryIsExist(gifEmojiCacheDirectory)) {
        
        GJCFFileDirectoryCreate(gifEmojiCacheDirectory);
    }
    
    return gifEmojiCacheDirectory;
}

+ (BOOL)isGifIdLocalCached:(NSString *)gifEmojiId
{
    if (GJCFStringIsNull(gifEmojiId)) {
        return NO;
    }
    
    //先扫描本地的gif关系文件
    NSDictionary *relationDict = [NSDictionary dictionaryWithContentsOfFile:GJCFMainBundlePath(@"gifLocal.plist")];
    
    NSString *gifName = [relationDict objectForKey:gifEmojiId];

    if (GJCFStringIsNull(gifName)) {
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)gifEmojiIsExistById:(NSString *)gifEmojiId
{
    if ([self isGifIdLocalCached:gifEmojiId]) {
        return YES;
    }
    
    return GJCFFileIsExist([self gifCachePathById:gifEmojiId]);
}

+ (NSData *)getCachedGifDataById:(NSString *)gifEmojiId
{
    if ([self isGifIdLocalCached:gifEmojiId]) {
        
        NSDictionary *relationDict = [NSDictionary dictionaryWithContentsOfFile:GJCFMainBundlePath(@"gifLocal.plist")];
        
        NSString *gifName = [NSString stringWithFormat:@"%@.gif",[relationDict objectForKey:gifEmojiId]];
        
        NSData *gifData = [NSData dataWithContentsOfFile:GJCFMainBundlePath(gifName)];
        
        return gifData;
    }
    
    return [NSData dataWithContentsOfFile:[self gifCachePathById:gifEmojiId]];
}

+ (NSString *)gifCachePathById:(NSString *)gifEmojiId
{
    if (GJCFStringIsNull(gifEmojiId)) {
        return nil;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.gif",gifEmojiId];
    
    return [[self createGifCacheDirectory]stringByAppendingPathComponent:fileName];
}

@end
