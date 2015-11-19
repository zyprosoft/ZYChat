//
//  GJGCRecentChatModel.h
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

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


@end
