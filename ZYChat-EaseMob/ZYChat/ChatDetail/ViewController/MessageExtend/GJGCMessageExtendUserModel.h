//
//  GJGCMessageExtendUserModel.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "JSONModel.h"
#import "GJGCMessageExtendConst.h"

@interface GJGCMessageExtendUserModel : JSONModel

@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSString *sex;

@property (nonatomic,strong)NSString *age;

@property (nonatomic,strong)NSString *headThumb;

@property (nonatomic,strong)NSString *nickName;

@end
