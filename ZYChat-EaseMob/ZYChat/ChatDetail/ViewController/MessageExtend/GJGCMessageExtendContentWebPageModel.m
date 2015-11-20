//
//  GJGCMessageExtendContentWebPageModel.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMessageExtendContentWebPageModel.h"

@implementation GJGCMessageExtendContentWebPageModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                                                                            
                                                      kGJGCMessageExtendDisplayText : @"displayText",
                                                      
                                                      kGJGCMessageExtendContentProtocol : @"protocolVersion",

                                                      kGJGCMessageExtendNotSupportDisplayText : @"notSupportDisplayText",

                                                      kGJGCMessageExtendTitle : @"title",
                                                      
                                                      kGJGCMessageExtendUrl : @"url",
                                                      
                                                      kGJGCMessageExtendSource : @"source",
                                                      
                                                      kGJGCMessageExtendSumary : @"sumary",
                                                      
                                                      kGJGCMessageExtendTime : @"time",
                                                      
                                                      kGJGCMessageExtendThumbImageBase64Data : @"thumbImageBase64",

                                                      kGJGCMessageExtendThumbImageUrl : @"thumbImageUrl",
                                                      
                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
