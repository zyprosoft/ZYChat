//
//  GJGCRecentChatModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCGroupInfoExtendModel.h"

@interface GJGCRecentChatModel : NSObject

@property (nonatomic,strong)NSString *headUrl;

@property (nonatomic,strong)NSAttributedString *name;

@property (nonatomic,strong)NSAttributedString *time;

@property (nonatomic,strong)NSString *content;

@property (nonatomic,assign)CGFloat contentHeight;

@property (nonatomic,strong)NSString *toId;

@property (nonatomic,assign)BOOL isGroupChat;

@property (nonatomic,assign)CGSize contentSize;

@property (nonatomic,assign)NSInteger unReadCount;

@property (nonatomic,strong)EMConversation *conversation;

@property (nonatomic,strong)GJGCMessageExtendGroupModel *groupInfo;


@end
