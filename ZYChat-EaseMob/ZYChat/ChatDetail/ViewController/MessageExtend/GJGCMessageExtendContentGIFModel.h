//
//  GJGCMessageExtendContentGIFModel.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCMessageExtendConst.h"

@interface GJGCMessageExtendContentGIFModel : JSONModel

@property (nonatomic,strong)NSString *displayText;

@property (nonatomic,strong)NSString *notSupportDisplayText;

@property (nonatomic,strong)NSString *protocolVersion;

@property (nonatomic,strong)NSString *emojiCode;

@property (nonatomic,strong)NSString *emojiVersion;

@end
