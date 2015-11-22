//
//  ZYDatabaseCRUDCondition.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYDatabaseCRUDCondition.h"

@implementation ZYDatabaseCRUDCondition

- (NSString *)sqlString
{
    switch (self.action) {
        case ZYDatabaseActionCreateTable:
        {
            return [self buildCreateTableQuery];
        }
            break;
            
        case ZYDatabaseActionDelete:
        {
            return [self buildDeleteQuery];
        }
            break;
            
        case ZYDatabaseActionSelect:
        {
            return [self buildSelectQuery];
        }
            break;
            
        case ZYDatabaseActionUpdate:
        {
            return [self buildUpdateQuery];
        }
            break;
            
        case ZYDatabaseActionInsert:
        {
            return @"";
        }
            break;
        default:
            break;
    }
}

- (NSString *)buildCreateTableQuery
{
    if (GJCFStringIsNull(self.tableName)) {
        NSLog(@"%@ 建表错误没有表名字",NSStringFromClass([ZYDatabaseCRUDCondition class]));
        return nil;
    }
    if (self.createColunmConditions.count == 0) {
        NSLog(@"%@ 建表错误没有属性字段",NSStringFromClass([ZYDatabaseCRUDCondition class]));
        return nil;
    }
    
    NSMutableString *sql = [NSMutableString string];
    
    [sql appendFormat:@"create table if not exists %@ (",self.tableName];
    
    for (NSInteger index = 0 ; index < self.createColunmConditions.count ; index ++) {
        
        ZYDatabaseColunmCondition *colunm = [self.createColunmConditions objectAtIndex:index];
        
        if (index != self.createColunmConditions.count - 1) {
            
            [sql appendFormat:@"%@,",colunm.sqlString];
            
        }else{
            
            [sql appendFormat:@"%@)",colunm.sqlString];
        }
    }
    
    NSLog(@"%@",sql);
    
    return sql;
}

- (NSString *)buildSelectQuery
{
    NSMutableString *sql = [NSMutableString string];
    
    if (self.queryColoums.count == 0) {
        
        [sql appendFormat:@"select * from %@ where %@",self.tableName,[self whereConditionSql]];

    }else{
        
        [sql appendFormat:@"select %@ from %@ where %@",[self.queryColoums componentsJoinedByString:@","],self.tableName,[self whereConditionSql]];

    }
    
    return sql;
}

- (NSString *)buildUpdateQuery
{
    NSMutableString *sql = [NSMutableString string];
    
    return sql;
}

- (NSString *)buildDeleteQuery
{
    NSMutableString *sql = [NSMutableString string];
    
    [sql appendFormat:@"delete from %@ where %@",self.tableName,[self whereConditionSql]];
    
    return sql;
}

- (NSString *)updateFormatSql
{
    if (self.updateValues.count == 0) {
        NSLog(@"试图更新表，缺没有任何更新值！");
        return @"";
    }
    
    NSDictionary *item = [self.updateValues firstObject];
    
    NSMutableString *sql = [NSMutableString string];
    
    switch (self.action) {
        case ZYDatabaseActionInsert:
        {
            [sql appendFormat:@"insert into %@ (%@) values %@",self.tableName,[self updateKeysToString:item.allKeys],[self argumentTupleOfSize:item.allKeys.count]];
        }
            break;
        case ZYDatabaseActionUpdate:
        {
            [sql appendFormat:@"update %@ set %@ where %@",self.tableName,[self argumentTupleOfSizeWithParams:item.allKeys],[self whereConditionSql]];
        }
            break;
        default:
            break;
    }
    
    NSLog(@"formate sql :%@",sql);
    
    return sql;
}

- (NSString *)whereConditionSql
{
    NSMutableString *sql = [NSMutableString string];
    
    for (NSInteger index = 0; index < self.andConditions.count; index ++) {
        
        ZYDatabaseWhereCondition *condition = self.andConditions[index];
        
        if (index != self.andConditions.count -1) {
            
            [sql appendFormat:@"%@,",condition.sqlformat];
            
        }else{
            
            [sql appendFormat:@"%@",condition.sqlformat];
        }
        
    }
    
    return sql;
}

- (NSArray *)andConditionValues
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.andConditions.count; index ++) {
        
        ZYDatabaseWhereCondition *condition = self.andConditions[index];
        
        [values addObject:condition.value];
    }
    
    return values;
}

- (NSArray *)updateWhereValues
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.andConditions.count; index ++) {
        
        ZYDatabaseWhereCondition *condition = self.andConditions[index];
        
        [values addObject:condition.value];
    }
    
    return values;
}

- (NSArray *)updateFormateValues
{
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (NSDictionary *item in self.updateValues) {
        
        [valueArray addObject:item.allValues];
    }
    
    return valueArray;
}

- (NSString *)updateValuesToString:(NSArray *)array
{
    NSMutableString *sql = [NSMutableString string];
    
    for (NSInteger index = 0;index < array.count;index ++) {
        
        if (index != array.count-1) {
            
            [sql appendFormat:@"%@,",array[index]];
            
        }else{
            
            [sql appendFormat:@"'%@'",array[index]];

        }
    }
    
    return sql;
}

- (NSString *)updateKeysToString:(NSArray *)array
{
    return [array componentsJoinedByString:@","];
}

- (NSString *)argumentTupleOfSize:(NSUInteger)tupleSize
{
    NSMutableArray * tupleString = [[NSMutableArray alloc] init];
    [tupleString addObject:@"("];
    for (NSUInteger columnIdx = 0; columnIdx < tupleSize; columnIdx++)
    {
        if (columnIdx > 0)
        {
            [tupleString addObject:@","];
        }
        [tupleString addObject:@"?"];
    }
    [tupleString addObject:@")"];
    
    return [tupleString componentsJoinedByString:@" "];
}

- (NSString *)argumentTupleOfSizeWithParams:(NSArray *)params
{
    NSMutableArray * tupleString = [[NSMutableArray alloc] init];
    for (NSUInteger columnIdx = 0; columnIdx < params.count; columnIdx++)
    {
        if (columnIdx > 0)
        {
            [tupleString addObject:@","];
        }
        [tupleString addObject:[params objectAtIndex:columnIdx]];
        [tupleString addObject:@"="];
        [tupleString addObject:@"?"];
    }
    
    return [tupleString componentsJoinedByString:@" "];
}

- (BOOL)isValidate
{
    BOOL isValidate = YES;
    
    if (GJCFStringIsNull(self.tableName)) {
        isValidate = NO;
        _conditionErrorMsg = @"没有表名";
        return isValidate;
    }
    
    switch (self.action) {
        case ZYDatabaseActionInsert:
        {
            if (self.updateValues.count == 0) {
                _conditionErrorMsg = @"插入一行记录但是没有任何值可以用";
                isValidate = NO;
            }
        }
            break;
        default:
            break;
    }
    
    return isValidate;
}
@end
