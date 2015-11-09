//
//  ZYDatabaseCRUDCondition.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
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
    
    return sql;
}

- (NSArray *)updateMutilRowSqls
{
    NSMutableArray *sqls = [NSMutableArray array];
    
    for (NSDictionary *item in self.updateValues) {
      
        NSMutableString *sql = [NSMutableString string];
        
        [sql appendFormat:@"insert into %@ (%@) values(%@)",self.tableName,[self updateValuesToString:item.allKeys],[self updateValuesToString:item.allValues]];
        
        [sqls addObject:sql];
    }
    
    return sqls;
}

- (NSString *)updateValuesToString:(NSArray *)array
{
    NSMutableString *sql = [NSMutableString string];
    
    for (NSInteger index = 0;index < array.count;index ++) {
        
        if (index != array.count-1) {
            
            [sql appendFormat:@"'%@',",array[index]];
            
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
     
@end
