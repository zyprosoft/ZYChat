//
//  ZYDatabaseCRUDCondition.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
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

//需要创建或者更新的字段,@[@{},@{}]
@property (nonatomic,strong)NSArray *updateValues;

//更新的formate语句
@property (nonatomic,readonly)NSString *updateFormatSql;

//更新的值数组
@property (nonatomic,readonly)NSArray *updateFormateValues;

//ZYDatabaseWhereCondition对象数组
@property (nonatomic,strong)NSArray *andConditions;

//条件查询时候的值，用来跟formate形式匹配
@property (nonatomic,readonly)NSArray *andConditionValues;

//更新的时候用的条件参数
@property (nonatomic,readonly)NSArray *updateWhereValues;

//ZYDatabaseSortCondition对象数组
@property (nonatomic,strong)NSArray *sortConditions;

//翻页限制条件 @[@(startIndex),@(pageCount)];
@property (nonatomic,strong)NSArray *limitCondition;

@property (nonatomic,readonly)NSString *sqlString;

@property (nonatomic,readonly)BOOL isValidate;

@property (nonatomic,readonly)NSString *conditionErrorMsg;


@end
