//
//  GJGCMessageExtendMiniMessageModel.m
//  ZYChat
//
//  Created by ZYVincent on 16/6/29.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCMessageExtendMiniMessageModel.h"

@implementation GJGCMessageExtendMiniMessageModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      
                                                      kGJGCMessageExtendDisplayText : @"displayText",
                                                      
                                                      kGJGCMessageExtendNotSupportDisplayText : @"notSupportDisplayText",
                                                                                                                                                                  
                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
