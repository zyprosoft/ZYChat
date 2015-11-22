//
//  GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/6/4.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatInputConst.h"

@interface GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem : NSObject

@property (nonatomic,strong)NSString *faceEmojiIconName;

@property (nonatomic,assign)GJGCChatInputExpandEmojiType emojiType;

@property (nonatomic,strong)NSString *emojiListFilePath;

@property (nonatomic,strong)NSString *packagePrefix;

@property (nonatomic,assign)BOOL isNeedShowSendButton;

@property (nonatomic,assign)BOOL isNeedShowRightSideLine;

@end
