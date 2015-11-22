//
//  ZYDatabaseSortCondition.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDatabaseConst.h"

@interface ZYDatabaseSortCondition : NSObject

@property (nonatomic,strong)NSString *colunmName;

@property (nonatomic,assign)ZYDatabaseSortOperation operation;

@property (nonatomic,readonly)NSString *sqlString;

@end
