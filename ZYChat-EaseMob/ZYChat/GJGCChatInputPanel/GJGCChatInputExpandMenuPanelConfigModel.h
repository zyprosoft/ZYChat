//
//  GJGCChatInputExpandMenuPanelConfigModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/4/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatFriendTalkModel.h"

@interface GJGCChatInputExpandMenuPanelConfigModel : NSObject

@property (nonatomic,assign)GJGCChatFriendTalkType talkType;

@property (nonatomic,strong)NSArray *disableItems;

@end
