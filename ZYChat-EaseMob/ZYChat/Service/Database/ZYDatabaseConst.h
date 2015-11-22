//
//  ZYDatabaseConst.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZYDatabaseAction) {
    ZYDatabaseActionSelect,
    ZYDatabaseActionInsert,
    ZYDatabaseActionUpdate,
    ZYDatabaseActionDelete,
    ZYDatabaseActionCreateTable,
};

typedef NS_ENUM(NSUInteger, ZYDatabaseWhereOperation) {
    ZYDatabaseWhereOperationEqual,
    ZYDatabaseWhereOperationBigger,
    ZYDatabaseWhereOperationSmaller,
    ZYDatabaseWhereOperationBiggerEqual,
    ZYDatabaseWhereOperationSmallerEqual,
};

typedef NS_ENUM(NSUInteger, ZYDatabaseSortOperation) {
    ZYDatabaseSortOperationDESC,
    ZYDatabaseSortOperationASC,
};

typedef NS_ENUM(NSUInteger, ZYDatabaseValueType) {
    ZYDatabaseValueTypeText,
    ZYDatabaseValueTypeVarchar,
    ZYDatabaseValueTypeInt,
    ZYDatabaseValueTypeBigInt,
};
