//
//  ZYDatabaseWhereCondition.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "ZYDatabaseWhereCondition.h"

@implementation ZYDatabaseWhereCondition

- (NSString *)sqlString
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
