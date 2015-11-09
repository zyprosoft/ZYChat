//
//  ZYDatabaseWhereCondition.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDatabaseConst.h"

@interface ZYDatabaseWhereCondition : NSObject

@property (nonatomic,strong)NSString *columName;

@property (nonatomic,assign)ZYDatabaseWhereOperation operation;

@property (nonatomic,strong)NSString *value;

@property (nonatomic,readonly)NSString *sqlString;

@end
