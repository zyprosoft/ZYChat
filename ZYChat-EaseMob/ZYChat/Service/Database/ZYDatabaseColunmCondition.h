//
//  ZYDatabaseColunmCondition.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDatabaseConst.h"

@interface ZYDatabaseColunmCondition : NSObject

@property (nonatomic,assign)BOOL isPrimary;

@property (nonatomic,assign)BOOL isAutoIncrease;

@property (nonatomic,assign)ZYDatabaseValueType valueType;

@property (nonatomic,assign)NSInteger limitLength;

@property (nonatomic,strong)NSString *colunmName;

@property (nonatomic,strong)NSString *defaultValue;

@property (nonatomic,assign)BOOL isNotNull;

@property (nonatomic,readonly)NSString *sqlString;

@end
