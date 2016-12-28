//
//  GJGCMessageExtendMusicShareModel.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/26.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "JSONModel.h"

@interface GJGCMessageExtendMusicShareModel : JSONModel

@property (nonatomic,strong)NSString *displayText;

@property (nonatomic,strong)NSString *protocolVersion;

@property (nonatomic,strong)NSString *notSupportDisplayText;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSString *author;

@property (nonatomic,strong)NSString *songId;

@property (nonatomic,strong)NSString *songUrl;

@property (nonatomic,strong)NSString *songImgUrl;

@end
