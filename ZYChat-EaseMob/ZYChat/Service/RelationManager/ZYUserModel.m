//
//  ZYUserModel.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYUserModel.h"

@implementation ZYUserModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      
                                                      @"add_time" : @"addTime",
                                                      
                                                      @"address" : @"address",
                                                      
                                                      @"head_thumb" : @"headThumb",
                                                      
                                                      @"last_time" : @"lastTime",
                                                      
                                                      @"latitude" : @"latitude",
                                                      
                                                      @"longtitude" : @"longtitude",
                                                      
                                                      @"name" : @"name",
                                                      
                                                      @"nickname" : @"nickname",
                                                      
                                                      @"sex" : @"sex",
                                                      
                                                      @"user_id" : @"userId",
                                                      
                                                      @"mobile" : @"mobile",
                                                      
                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
