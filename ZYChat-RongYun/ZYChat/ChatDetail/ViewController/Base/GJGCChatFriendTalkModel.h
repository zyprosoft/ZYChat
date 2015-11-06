//
//  GJGCChatFriendTalkModel.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-24.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatFriendContentModel.h"

#define GJGCTalkTypeString(talkType) [GJGCChatFriendTalkModel talkTypeString:talkType]

@interface GJGCChatFriendTalkModel : NSObject

@property (nonatomic,copy)NSString *toId;

@property (nonatomic,copy)NSString *toUserName;

@property (nonatomic,assign)GJGCChatFriendTalkType talkType;

@property (nonatomic,strong)NSArray *msgArray;

@property (nonatomic,assign)NSInteger msgCount;

+ (NSString *)talkTypeString:(GJGCChatFriendTalkType)talkType;

@end
