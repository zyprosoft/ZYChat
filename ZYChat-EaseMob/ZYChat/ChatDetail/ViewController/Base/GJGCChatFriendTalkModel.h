//
//  GJGCChatFriendTalkModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-24.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatFriendContentModel.h"
#import "GJGCGroupInfoExtendModel.h"

#define GJGCTalkTypeString(talkType) [GJGCChatFriendTalkModel talkTypeString:talkType]

@interface GJGCChatFriendTalkModel : NSObject

@property (nonatomic,copy)NSString *toId;

@property (nonatomic,copy)NSString *toUserName;

@property (nonatomic,assign)GJGCChatFriendTalkType talkType;

@property (nonatomic,strong)NSArray *msgArray;

@property (nonatomic,assign)NSInteger msgCount;

@property (nonatomic,strong)EMConversation *conversation;

@property (nonatomic,strong)GJGCMessageExtendGroupModel *groupInfo;

+ (NSString *)talkTypeString:(GJGCChatFriendTalkType)talkType;

@end
