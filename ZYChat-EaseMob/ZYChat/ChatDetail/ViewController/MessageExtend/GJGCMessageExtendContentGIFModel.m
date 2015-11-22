//
//  GJGCMessageExtendContentGIFModel.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCMessageExtendContentGIFModel.h"

@implementation GJGCMessageExtendContentGIFModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                                                                            
                                                      kGJGCMessageExtendDisplayText : @"displayText",
                                                      
                                                      kGJGCMessageExtendNotSupportDisplayText : @"notSupportDisplayText",

                                                      kGJGCMessageExtendGifEmojiCode : @"emojiCode",
                                                      
                                                      kGJGCMessageExtendGifVersion : @"emojiVersion",
                                                      
                                                      kGJGCMessageExtendContentProtocol : @"protocolVersion",

                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end
