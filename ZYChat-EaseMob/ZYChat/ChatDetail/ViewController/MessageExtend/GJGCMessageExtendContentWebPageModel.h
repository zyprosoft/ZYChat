//
//  GJGCMessageExtendContentWebPageModel.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "JSONModel.h"
#import "GJGCMessageExtendConst.h"

@interface GJGCMessageExtendContentWebPageModel : JSONModel

@property (nonatomic,strong)NSString *displayText;

@property (nonatomic,strong)NSString *protocolVersion;

@property (nonatomic,strong)NSString *notSupportDisplayText;

@property (nonatomic,strong)NSString *url;

@property (nonatomic,strong)NSString *sumary;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSString *time;

@property (nonatomic,strong)NSString *source;

@property (nonatomic,strong)NSString *thumbImageBase64;

@property (nonatomic,strong)NSString *thumbImageUrl;

@end
