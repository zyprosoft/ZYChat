//
//  GJGCContactsContentModel.h
//  ZYChat
//
//  Created by ZYVincent on 16/8/8.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCContactsConst.h"
#import "GJGCMessageExtendGroupModel.h"

@interface GJGCContactsContentModel : NSObject

@property (nonatomic,assign)BOOL isGroupChat;

@property (nonatomic,strong)NSString *groupId;

@property (nonatomic,strong)NSString *nickname;

@property (nonatomic,strong)NSString *userId;

@property (nonatomic,strong)NSString *headThumb;

@property (nonatomic,strong)NSString *mobile;

@property (nonatomic,assign)GJGCContactsContentType contentType;

@property (nonatomic,assign)CGFloat contentHeight;

@property (nonatomic,strong)NSString *summary;

@property (nonatomic,strong)GJGCMessageExtendGroupModel *groupInfo;

@end
