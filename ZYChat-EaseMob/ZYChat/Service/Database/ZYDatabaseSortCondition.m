//
//  ZYDatabaseSortCondition.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYDatabaseSortCondition.h"

@implementation ZYDatabaseSortCondition

- (NSString *)sqlString
{
    NSMutableString *sql = [NSMutableString string];
    
    NSString *operate;
    switch (self.operation) {
        case ZYDatabaseSortOperationASC:
            operate = @"ASC";
            break;
        case ZYDatabaseSortOperationDESC:
            operate = @"DESC";
            break;
        default:
            break;
    }
    
    [sql appendFormat:@"%@ %@",self.colunmName,operate];
    
    return sql;
}

@end
