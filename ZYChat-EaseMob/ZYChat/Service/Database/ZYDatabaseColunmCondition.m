//
//  ZYDatabaseColunmCondition.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYDatabaseColunmCondition.h"

@implementation ZYDatabaseColunmCondition

- (instancetype)init
{
    if (self = [super init]) {
        
        self.isPrimary = NO;
        self.isAutoIncrease = NO;
    }
    return self;
}

- (NSString *)sqlString
{
    NSMutableString *sql = [NSMutableString string];
    
    //属性
    [sql appendFormat:@"%@ ",self.colunmName];
    
    //类型
    switch (self.valueType) {
        case ZYDatabaseValueTypeText:
        {
            [sql appendString:@"text "];
        }
            break;
        case ZYDatabaseValueTypeVarchar:
        {
            [sql appendFormat:@"varchar(%ld) ",self.limitLength];
        }
            break;
        case ZYDatabaseValueTypeBigInt:
        {
            [sql appendString:@"bigint "];
        }
            break;
        case ZYDatabaseValueTypeInt:
        {
            [sql appendString:@"INTEGER "];
        }
            break;
        default:
            break;
    }
    
    //是否主键
    if (self.isPrimary) {
        [sql appendFormat:@"primary key "];
    }
    
    //是否自增
    if (self.isAutoIncrease) {
        [sql appendFormat:@"autoincrement "];
    }
    
    //是否不可以为空
    if (self.isNotNull) {
        
        [sql appendString:@"not null "];
    }

    //默认值
    if (!GJCFStringIsNull(self.defaultValue)) {
        
        [sql appendFormat:@"default %@",self.defaultValue];
    }

    return sql;
}

@end
