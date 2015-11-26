//
//  GJGCInfoBaseListContentModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCInfoBaseListConst.h"

@interface GJGCInfoBaseListContentModel : NSObject

@property (nonatomic,assign)GJGCInfoBaseListContentType contentType;

@property (nonatomic,assign)CGFloat contentHeight;

#pragma mark - 展示内容

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSString *headUrl;

@property (nonatomic,strong)NSString *summary;

@property (nonatomic,strong)NSString *time;

#pragma mark - 群组特有

@property (nonatomic,strong)NSString *groupLabels;

@property (nonatomic,strong)NSString *groupAddress;

@property (nonatomic,strong)NSString *groupId;

#pragma mark - 用户信息

@property (nonatomic,strong)NSString *groupName;

@property (nonatomic,strong)NSString *groupHeadThumb;

@property (nonatomic,strong)NSString *chatter;

@property (nonatomic,assign)EMConversation *conversation;

#pragma mark - App Store信息

@property (nonatomic,strong)NSString *appStoreLink;

@end
