//
//  GJGCGroupInfoExtendModel.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCGroupInfoExtendModel.h"

@implementation GJGCGroupInfoExtendModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      
                                                      
                                                      kGJGCGroupInfoExtendName : @"name",

                                                      kGJGCGroupInfoExtendDescription : @"simpleDescription",
                                                      
                                                      kGJGCGroupInfoExtendHeadUrl : @"headUrl",
                                                      
                                                      kGJGCGroupInfoExtendLabels : @"labels",
                                                                                                        
                                                      kGJGCGroupInfoExtendAddress : @"address",

                                                      kGJGCGroupInfoExtendLevel : @"level",
                                                      kGJGCGroupInfoExtendCompany : @"company",
                                                      
                                                      kGJGCGroupInfoExtendCreateTime : @"addTime",

                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
