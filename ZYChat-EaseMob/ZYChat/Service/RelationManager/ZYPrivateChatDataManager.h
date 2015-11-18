//
//  ZYPrivateChatDataManager.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/17.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYChatConversation.h"

@interface ZYPrivateChatDataManager : NSObject

- (void)createConversation:(ZYChatConversation *)conversation;

@end
