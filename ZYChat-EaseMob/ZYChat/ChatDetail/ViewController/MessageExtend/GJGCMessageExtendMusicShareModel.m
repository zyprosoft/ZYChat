//
//  GJGCMessageExtendMusicShareModel.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/26.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMessageExtendMusicShareModel.h"

@implementation GJGCMessageExtendMusicShareModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      
                                                      kGJGCMessageExtendDisplayText : @"displayText",
                                                      
                                                      kGJGCMessageExtendNotSupportDisplayText : @"notSupportDisplayText",
                                                      
                                                      kGJGCMessageExtendTitle : @"title",

                                                      kGJGCMessageExtendMusicUrl : @"songUrl",
                                                      
                                                      kGJGCMessageExtendMusicSongAuthor : @"songAuthor",
                                                      
                                                      kGJGCMessageExtendMusicSongId : @"songId",
                                                      
                                                     kGJGCMessageExtendMusicSongImageUrl :@"songImgUrl",
                                                      
                                                      }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
