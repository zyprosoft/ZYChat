//
//  GJGCMessageExtendUserModel.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCMessageExtendUserModel.h"

@implementation GJGCMessageExtendUserModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      
                                                      kGJGCMessageExtendUserName : @"userName",
                                                      
                                                      kGJGCMessageExtendUserSex : @"sex",

                                                      kGJGCMessageExtendUserHeadThumb : @"headThumb",

                                                      kGJGCMessageExtendUserAge : @"age",

                                                      kGJGCMessageExtendUserNickname : @"nickName",

                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
