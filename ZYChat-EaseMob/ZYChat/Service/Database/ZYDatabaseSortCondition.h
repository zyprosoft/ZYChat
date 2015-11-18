//
//  ZYDatabaseSortCondition.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYDatabaseConst.h"

@interface ZYDatabaseSortCondition : NSObject

@property (nonatomic,strong)NSString *colunmName;

@property (nonatomic,assign)ZYDatabaseSortOperation operation;

@property (nonatomic,readonly)NSString *sqlString;

@end
