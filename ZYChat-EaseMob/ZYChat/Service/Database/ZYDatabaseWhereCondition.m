//
//  ZYDatabaseWhereCondition.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYDatabaseWhereCondition.h"

@implementation ZYDatabaseWhereCondition

- (NSString *)sqlformat
{
    NSMutableString *sql = [NSMutableString string];
    
    NSString *operate = [[self operationDict]objectForKey:@(self.operation)];
    
    [sql appendFormat:@"%@ %@ %@",self.columName,operate,self.value];
    
    return sql;
}

- (NSDictionary *)operationDict
{
    return @{
             @(ZYDatabaseWhereOperationEqual) : @"=",
             
             @(ZYDatabaseWhereOperationBigger) : @">",
             
             @(ZYDatabaseWhereOperationSmaller) : @"<",
             
             @(ZYDatabaseWhereOperationBiggerEqual) : @">=",
             
             @(ZYDatabaseWhereOperationSmallerEqual) : @"<=",
             
             };
}



@end
