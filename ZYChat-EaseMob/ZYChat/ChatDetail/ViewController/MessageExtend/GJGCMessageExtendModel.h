//
//  GJGCMessageExtendBaseModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCMessageExtendUserModel.h"
#import "GJGCMessageExtendContentGIFModel.h"
#import "GJGCMessageExtendContentWebPageModel.h"
#import "GJGCMessageExtendGroupModel.h"

//扩展消息类型都基于文本消息扩展

@interface GJGCMessageExtendModel : NSObject

//是否扩展消息内容,如果只是扩展用户信息，允许messageContent为空
@property (nonatomic,assign)BOOL isExtendMessageContent;

@property (nonatomic,assign)BOOL isGroupMessage;

@property (nonatomic,strong)GJGCMessageExtendUserModel *userInfo;

@property (nonatomic,strong)GJGCMessageExtendGroupModel *groupInfo;

@property (nonatomic,strong)JSONModel *messageContent;

@property (nonatomic,strong)NSString *contentType;

@property (nonatomic,readonly)NSString *displayText;

@property (nonatomic,readonly)BOOL isSupportDisplay;

@property (nonatomic,assign)GJGCChatFriendContentType chatFriendContentType;

- (instancetype)initWithDictionary:(NSDictionary *)contentDict;

- (NSDictionary *)contentDictionary;

+ (NSDictionary *)chatFriendTypeToExtendMsgTypeDict;

+ (NSDictionary *)extendMsgTypeToChatFriendTypeDict;

@end
