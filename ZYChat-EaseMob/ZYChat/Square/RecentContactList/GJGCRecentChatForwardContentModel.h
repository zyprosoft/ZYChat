//
//  GJGCRecentChatForwardContentModel.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCRecentChatForwardContentModel : NSObject

@property (nonatomic,strong)UIImage *thumbImage;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,assign)GJGCChatFriendContentType contentType;

@property (nonatomic,strong)NSString *sumary;

@property (nonatomic,strong)NSString *webUrl;

@property (nonatomic,strong)NSString *songId;

@property (nonatomic,strong)NSString *imageUrl;

@end
