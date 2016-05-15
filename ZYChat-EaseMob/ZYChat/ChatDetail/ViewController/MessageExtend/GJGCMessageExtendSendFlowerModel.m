//
//  GJGCMessageExtendSendFlower.m
//  ZYChat
//
//  Created by ZYVincent on 16/5/15.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCMessageExtendSendFlowerModel.h"

@implementation GJGCMessageExtendSendFlowerModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      
                                                      kGJGCMessageExtendDisplayText : @"displayText",
                                                      
                                                      kGJGCMessageExtendNotSupportDisplayText : @"notSupportDisplayText",

                                                      kGJGCMessageExtendTitle : @"title",
                                                      
                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
