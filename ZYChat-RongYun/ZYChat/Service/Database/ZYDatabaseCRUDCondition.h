//
//  ZYDatabaseCRUDCondition.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDatabaseConst.h"
#import "ZYDatabaseColunmCondition.h"
#import "ZYDatabaseSortCondition.h"
#import "ZYDatabaseWhereCondition.h"

@interface ZYDatabaseCRUDCondition : NSObject

@property (nonatomic,assign)ZYDatabaseAction action;

@property (nonatomic,strong)NSString *tableName;

//左联接，右链接，内链接，暂时不实现
@property (nonatomic,strong)NSDictionary *joinMaps;

//建表的属性字段
@property (nonatomic,strong)NSArray *createColunmConditions;

//属性字符串数组
@property (nonatomic,strong)NSArray *queryColoums;

//需要创建或者更新的字段
@property (nonatomic,strong)NSArray *updateValues;

@property (nonatomic,readonly)NSArray *updateMutilRowSqls;

//ZYDatabaseWhereCondition对象数组
@property (nonatomic,strong)NSArray *andConditions;

//ZYDatabaseSortCondition对象数组
@property (nonatomic,strong)NSArray *sortConditions;

//翻页限制条件 @[@(startIndex),@(pageCount)];
@property (nonatomic,strong)NSArray *limitCondition;

@property (nonatomic,readonly)NSString *sqlString;


@end
