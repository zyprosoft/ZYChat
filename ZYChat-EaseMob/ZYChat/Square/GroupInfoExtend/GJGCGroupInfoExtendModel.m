//
//  GJGCGroupInfoExtendModel.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCGroupInfoExtendModel.h"

@implementation GJGCGroupInfoExtendModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      
                                                      kGJGCGroupInfoExtendDescription : @"simpleDescription",
                                                      
                                                      kGJGCGroupInfoExtendHeadUrl : @"headUrl",
                                                      
                                                      kGJGCGroupInfoExtendLabels : @"labels",
                                                      
                                                      kGJGCGroupInfoExtendSign : @"sign",
                                                      
                                                      kGJGCGroupInfoExtendLocation : @"location",
                                                      
                                                      kGJGCGroupInfoExtendAddress : @"address",

                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
