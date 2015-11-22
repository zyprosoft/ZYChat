//
//  GJGCGroupInfoExtendModel.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "JSONModel.h"
#import "GJGCGroupInfoExtendConst.h"

@interface GJGCGroupInfoExtendModel : JSONModel

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *simpleDescription;

@property (nonatomic,strong)NSString *headUrl;

@property (nonatomic,strong)NSString *address;

@property (nonatomic,strong)NSString *labels;

@property (nonatomic,strong)NSString *level;

@property (nonatomic,strong)NSString *company;

@property (nonatomic,strong)NSString *addTime;

@end
