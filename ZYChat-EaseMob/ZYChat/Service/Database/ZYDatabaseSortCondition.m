//
//  ZYDatabaseSortCondition.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
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
