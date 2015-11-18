//
//  GJCFQuickCacheMacrocDefine.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

/**
 *  文件描述
 *
 *  这个工具类宏定义封装了对
 *  NSUserDefault,NSCache,NSFileManager
 *  NSKeyedArchieve,NSDocumentDirectory,NSCacheDirectory的便捷操作
 */

#import "GJCFQuickCacheUitil.h"

/* 写宏定义的时候，前面变量参数的名字，多参数的时候不能方法名和后面调用方法的参数名字一样 */

/**
 *  检查一个valueObj,keyObj对象是否有一个是空的
 */
#define GJCFCheckKeyValueHasNull(keyObj,valueObj) [GJCFQuickCacheUitil checkValue:valueObj key:keyObj]

/**
 *  检查一个对象是否为空
 */
#define GJCFCheckObjectNull(object) [GJCFQuickCacheUitil isNullObject:object]

/**
 *  NSUserDefault 保存键值对 keyObj,valueObj
 */
#define GJCFUDFCache(keyObj,valueObj) [GJCFQuickCacheUitil userDefaultCache:valueObj key:keyObj]

/**
 *  NSUserDefault 删除键keyObj对应的值
 */
#define GJCFUDFRemove(keyObj) [GJCFQuickCacheUitil userDefaultRemove:keyObj]

/**
 *  NSUserDefault 获取键keyObj对应的值
 */
#define GJCFUDFGetValue(keyObj) [GJCFQuickCacheUitil userDefaultGetValue:keyObj]

/**
 *  NSUserDefault 判断键keyObject对应的值是否为空
 */
#define GJCFUDFEmptyValue(keyObj) [GJCFQuickCacheUitil userDefaultEmptyValue:keyObj]

/**
 *  NSCache 存储键值对 keyObj,valueObj
 */
#define GJCFNSCacheSet(keyObj,valueObj) [GJCFQuickCacheUitil systemMemoryCacheSet:valueObj key:keyObj]

/**
 *  NSCache 删除键keyObj对应的值
 */
#define GJCFNSCacheRemove(keyObj) [GJCFQuickCacheUitil systemMemoryCacheRemove:keyObj]

/**
 *  NSCache 获取键keyObj对应的值
 */
#define GJCFNSCacheGetValue(keyObj) [GJCFQuickCacheUitil systemMemoryCacheGetValue:keyObj]

/**
 *  NSCache 判断键keyObject对应的值是否为空
 */
#define GJCFNSCacheEmptyValue(keyObj) [GJCFQuickCacheUitil systemMemoryCacheEmptyValue:keyObj]

/**
 *  获取系统默认文件管理
 */
#define GJCFFileManager [GJCFQuickCacheUitil fileManager]

/**
 *  指定路径pathObj是否存在文件
 */
#define GJCFFileIsExist(pathObj) [GJCFQuickCacheUitil fileExist:pathObj]

/**
 *  指定路径pathObj是否存在目录
 */
#define GJCFFileDirectoryIsExist(pathObj) [GJCFQuickCacheUitil directoryExist:pathObj]

/**
 *  读取某个路径的二进制数据，返回 NSData
 */
#define GJCFFileRead(pathObj) [GJCFQuickCacheUitil readFromFile:pathObj]

/**
 *  将二进制数据写入文件 dataObj:NSData pathObj:NSString
 */
#define GJCFFileWrite(dataObj,pathObj) [GJCFQuickCacheUitil writeFileData:dataObj toPath:pathObj]

/**
 *  在指定路径创建目录，返回BOOL结果
 */
#define GJCFFileDirectoryCreate(pathObj) [GJCFQuickCacheUitil createDirectory:pathObj]

/**
 *  删除指定路径文件
 */
#define GJCFFileDeleteFile(path) [GJCFQuickCacheUitil deleteFileAtPath:path]

/**
 *  删除指定目录
 */
#define GJCFFileDeleteDirectory(path) [GJCFQuickCacheUitil deleteDirectoryAtPath:path]

/**
 *  从fromFilePath复制文件到toFilePath,shouldRemove标示是否删除复制源文件
 */
#define GJCFFileCopyFileIsRemove(fromFilePath,toFilePath,shouldRemove) [GJCFQuickCacheUitil copyFileFromPath:fromFilePath toPath:toFilePath isRemoveOld:shouldRemove]

/**
 *  将某个对象归档到指定路径
 */
#define GJCFArchieveObject(object,filePath) [GJCFQuickCacheUitil archieveObject:object toFilePath:filePath]

/**
 *  从指定路径读取被归档过的对象
 */
#define GJCFUnArchieveObject(fromFilePath) [GJCFQuickCacheUitil unarchieveFromPath:fromFilePath]

/**
 *  获取NSDocumentDirectory目录
 */
#define GJCFAppDocumentDirectory [GJCFQuickCacheUitil documentDirectory]

/**
 *  获取NSCacheDirectory目录
 */
#define GJCFAppCacheDirectory [GJCFQuickCacheUitil cacheDirectory]

/**
 *  返回文件名为fileName在NSDocumentDirectory中的路径
 */
#define GJCFAppDoucmentPath(fileName) [GJCFQuickCacheUitil documentDirectoryPath:fileName]

/**
 *  返回文件名为fileName在NSCacheDirectory中的路径
 */
#define GJCFAppCachePath(fileName) [GJCFQuickCacheUitil cacheDirectoryPath:fileName]

/**
 *  将object对象用fileName名字保存到NSDocumentDirectory目录下
 */
#define GJCFAppDocumentSave(object,fileName) [GJCFQuickCacheUitil documentDirectorySave:object withFileName:fileName]

/**
 *  将object对象用fileName名字保存到NSCacheDirectory目录下
 */
#define GJCFAppCacheSave(object,fileName) [GJCFQuickCacheUitil cacheDirectorySave:object withFileName:fileName]

/**
 *  删除NSDocumentDirectory目录下名为fileName的文件
 */
#define GJCFAppDocumentDelete(fileName)  [GJCFQuickCacheUitil documentDirectoryDelete:fileName]

/**
 *  删除NSCacheDirectory目录下名为fileName的文件
 */
#define GJCFAppCacheDelete(fileName) [GJCFQuickCacheUitil cacheDirectoryDelete:fileName]

