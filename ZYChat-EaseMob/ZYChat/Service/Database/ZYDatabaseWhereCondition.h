//
//  ZYDatabaseWhereCondition.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDatabaseConst.h"

@interface ZYDatabaseWhereCondition : NSObject

@property (nonatomic,strong)NSString *columName;

@property (nonatomic,assign)ZYDatabaseWhereOperation operation;

@property (nonatomic,strong)NSString *value;

@property (nonatomic,readonly)NSString *sqlformat;

@end
