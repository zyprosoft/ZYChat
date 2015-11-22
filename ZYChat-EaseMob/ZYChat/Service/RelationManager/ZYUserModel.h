//
//  ZYUserModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYUserModel : JSONModel

@property (nonatomic,strong)NSString *mobile;

@property (nonatomic,strong)NSString *address;

@property (nonatomic,strong)NSString *headThumb;

@property (nonatomic,strong)NSString *lastTime;

@property (nonatomic,strong)NSString *latitude;

@property (nonatomic,strong)NSString *longtitude;

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *nickname;

@property (nonatomic,strong)NSString *sex;

@property (nonatomic,strong)NSString *userId;

@property (nonatomic,strong)NSString *addTime;


@end
