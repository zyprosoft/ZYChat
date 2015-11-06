//
//  GJGCChatPostContentModel.h
//  ZYChat
//
//  Created by ZYVincent on 14-12-23.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendContentModel.h"

@interface GJGCChatPostContentModel : GJGCChatFriendContentModel

@property (nonatomic,strong)NSString *toId;

@property (nonatomic,strong)NSString *toUserName;

@property (nonatomic,strong)NSString *senderId;

@property (nonatomic,strong)NSString *postSrc;

@property (nonatomic,strong)NSString *postPrice;

@property (nonatomic,strong)NSString *postPuid;

@property (nonatomic,strong)NSString *postId;

@property (nonatomic,strong)NSString *postTitle;

@property (nonatomic,strong)NSString *postImg;

@property (nonatomic,strong)NSString *basePostId;

@property (nonatomic,strong)NSString *basePostTitle;

@property (nonatomic,strong)NSString *basePostImg;

@end
