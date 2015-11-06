//
//  GJCFQuickCacheUitil.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-16.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import "GJCFQuickCacheUitil.h"
#import "GJCFQuickCacheMacrocDefine.h"
#import "GJCFDispatchMacrocDefine.h"
#import "GJCFStringMacrocDefine.h"

@implementation GJCFQuickCacheUitil

+ (BOOL)isNullObject:(id)anObject
{
    if (!anObject || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)checkValue:(id)value key:(id)key
{
    if(GJCFCheckObjectNull(value)||GJCFCheckObjectNull(key)){
        return YES;
    }else{
        return NO;
    }
}

+ (NSUserDefaults *)standDefault
{
    return [NSUserDefaults standardUserDefaults];
}

+ (void)userDefaultCache:(id<NSCoding>)value key:(id)key
{
    if (GJCFCheckKeyValueHasNull(key, value)) {
        return;
    }
    [[GJCFQuickCacheUitil standDefault]setObject:value forKey:key];
}

+ (void)userDefaultRemove:(id)key
{
    if (GJCFCheckObjectNull(key)) {
        return;
    }
    [[GJCFQuickCacheUitil standDefault]removeObjectForKey:key];
}

+ (id)userDefaultGetValue:(id)key
{
    if (GJCFCheckObjectNull(key)) {
        return nil;
    }
    return [[GJCFQuickCacheUitil standDefault]objectForKey:key];
}

+ (BOOL)userDefaultEmptyValue:(id)key
{
    return [GJCFQuickCacheUitil userDefaultGetValue:key] == nil;
}

+ (NSCache *)shareCache
{
    static NSCache *_gjcfNSCacheInstance = nil;
    static dispatch_once_t onceToken;
    
    GJCFDispatchOnce(onceToken, ^{
        
        if (!_gjcfNSCacheInstance) {
            _gjcfNSCacheInstance = [[NSCache alloc]init];
        }
        
    });
    
    return _gjcfNSCacheInstance;
}

+ (void)systemMemoryCacheSet:(id<NSCoding>)value key:(id)key
{
    if (GJCFCheckKeyValueHasNull(value, key)) {
        return;
    }
    [[GJCFQuickCacheUitil shareCache]setObject:value forKey:key];
}

+ (void)systemMemoryCacheRemove:(id)key
{
    if (GJCFCheckObjectNull(key)) {
        return;
    }
    [[GJCFQuickCacheUitil shareCache]removeObjectForKey:key];
}

+ (id)systemMemoryCacheGetValue:(id)key
{
    if (GJCFCheckObjectNull(key)) {
        return nil;
    }
    return [[GJCFQuickCacheUitil shareCache]objectForKey:key];
}

+ (BOOL)systemMemoryCacheEmptyValue:(id)key
{
    if (GJCFCheckObjectNull(key)) {
        return NO;
    }
    return [GJCFQuickCacheUitil systemMemoryCacheGetValue:key] == nil;
}

+ (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}

+ (BOOL)fileExist:(NSString*)path
{
    if (GJCFStringIsNull(path)) {
        return NO;
    }
    return [[GJCFQuickCacheUitil fileManager] fileExistsAtPath:path];
}

+ (BOOL)directoryExist:(NSString*)dirPath
{
    if (GJCFStringIsNull(dirPath)) {
        return NO;
    }
    BOOL isDir = YES;
    
    return [[GJCFQuickCacheUitil fileManager]fileExistsAtPath:dirPath isDirectory:&isDir];
}

+ (BOOL)createDirectory:(NSString*)dirPath
{
    if (GJCFCheckObjectNull(dirPath)) {
        return NO;
    }
    if (GJCFFileDirectoryIsExist(dirPath)) {
        return YES;
    }
    return [[GJCFQuickCacheUitil fileManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)writeFileData:(NSData*)data toPath:(NSString *)path
{
    if (GJCFCheckKeyValueHasNull(data, path)) {
        return NO;
    }
    
    return [data writeToFile:path atomically:YES];
}

+ (NSData *)readFromFile:(NSString *)path
{
    if (GJCFCheckObjectNull(path)) {
        return nil;
    }
    
    return [NSData dataWithContentsOfFile:path];
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath
{
    if (GJCFStringIsNull(filePath)) {
        return NO;
    }
    return [GJCFFileManager removeItemAtPath:filePath error:nil];
}

+ (BOOL)deleteDirectoryAtPath:(NSString *)dirPath
{
    if (GJCFStringIsNull(dirPath)) {
        return NO;
    }
    return [GJCFFileManager removeItemAtPath:dirPath error:nil];
}

+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath isRemoveOld:(BOOL)isRemove
{
    if (GJCFStringIsNull(fromPath) || GJCFStringIsNull(toPath) ) {
        return NO;
    }
    if (!GJCFFileIsExist(fromPath)) {
        return NO;
    }
    
    BOOL copyResult = [GJCFFileManager copyItemAtPath:fromPath toPath:toPath error:nil];
    if (copyResult) {
        
        if (isRemove) {
            return [GJCFFileManager removeItemAtPath:fromPath error:nil];
        }
        return YES;
        
    }else{
        return NO;
    }
}

+ (BOOL)archieveObject:(id<NSCoding>)anObject toFilePath:(NSString *)toPath
{
    if (GJCFCheckObjectNull(anObject) || GJCFStringIsNull(toPath)) {
        return NO;
    }
    NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:anObject];
    if (archieveData) {
        
        return GJCFFileWrite(archieveData, toPath);
        
    }else{
        return NO;
    }
}

+ (id)unarchieveFromPath:(NSString *)filePath
{
    if (GJCFStringIsNull(filePath)) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)documentDirectoryPath:(NSString *)file
{
    if (GJCFStringIsNull(file)) {
        return nil;
    }
    return [[GJCFQuickCacheUitil documentDirectory]stringByAppendingPathComponent:file];
}

+ (NSString *)cacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)cacheDirectoryPath:(NSString *)file
{
    if (GJCFStringIsNull(file)) {
        return nil;
    }
    return [[GJCFQuickCacheUitil cacheDirectory]stringByAppendingPathComponent:file];
}

+ (BOOL)cacheDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file
{
    if (GJCFCheckObjectNull(anObject) || GJCFStringIsNull(file)) {
        return NO;
    }
    
    return GJCFArchieveObject(anObject, [GJCFQuickCacheUitil cacheDirectoryPath:file]);
}

+ (BOOL)cacheDirectoryDelete:(NSString *)file
{
    if (GJCFStringIsNull(file)) {
        return NO;
    }
    return GJCFFileDeleteFile([GJCFQuickCacheUitil cacheDirectoryPath:file]);
}


+ (BOOL)documentDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file
{
    if (GJCFCheckObjectNull(anObject) || GJCFStringIsNull(file)) {
        return NO;
    }
    
    return GJCFArchieveObject(anObject, [GJCFQuickCacheUitil documentDirectoryPath:file]);
}

+ (BOOL)documentDirectoryDelete:(NSString *)file
{
    if (GJCFStringIsNull(file)) {
        return NO;
    }
    return GJCFFileDeleteFile([GJCFQuickCacheUitil documentDirectoryPath:file]);
}

@end
