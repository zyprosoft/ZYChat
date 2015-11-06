//
//  GJCFQuickCacheUitil.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJCFQuickCacheUitil : NSObject

+ (BOOL)isNullObject:(id)anObject;

+ (BOOL)checkValue:(id)value key:(id)key;

+ (void)userDefaultCache:(id<NSCoding>)value key:(id)key;

+ (void)userDefaultRemove:(id)key;

+ (id)userDefaultGetValue:(id)key;

+ (BOOL)userDefaultEmptyValue:(id)key;

+ (void)systemMemoryCacheSet:(id<NSCoding>)value key:(id)key;

+ (void)systemMemoryCacheRemove:(id)key;

+ (id)systemMemoryCacheGetValue:(id)key;

+ (BOOL)writeFileData:(NSData*)data toPath:(NSString *)path;

+ (BOOL)systemMemoryCacheEmptyValue:(id)key;

+ (NSFileManager *)fileManager;

+ (BOOL)fileExist:(NSString*)path;

+ (BOOL)directoryExist:(NSString*)dirPath;

+ (BOOL)createDirectory:(NSString*)dirPath;

+ (NSData *)readFromFile:(NSString *)path;

+ (BOOL)deleteFileAtPath:(NSString *)filePath;

+ (BOOL)deleteDirectoryAtPath:(NSString *)dirPath;

+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath isRemoveOld:(BOOL)isRemove;

+ (BOOL)archieveObject:(id<NSCoding>)anObject toFilePath:(NSString *)toPath;

+ (id)unarchieveFromPath:(NSString *)filePath;

+ (NSString *)documentDirectory;

+ (NSString *)cacheDirectory;

+ (NSString *)documentDirectoryPath:(NSString *)file;

+ (NSString *)cacheDirectoryPath:(NSString *)file;

+ (BOOL)cacheDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file;

+ (BOOL)cacheDirectoryDelete:(NSString *)file;

+ (BOOL)documentDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file;

+ (BOOL)documentDirectoryDelete:(NSString *)file;


@end
