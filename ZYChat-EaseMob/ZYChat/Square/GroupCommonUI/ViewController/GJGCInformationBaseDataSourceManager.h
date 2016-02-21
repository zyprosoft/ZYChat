//
//  GJGCInformationBaseDataSourceManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCInformationBaseModel.h"
#import "GJGCInformationCellConstans.h"
#import "gjgcinformationCellContentModel.h"

@interface GJGCInformationBaseDataSourceManager : NSObject

- (NSInteger)totalCount;

- (Class)contentCellAtIndex:(NSInteger)index;

- (NSString *)contentCellIdentifierAtIndex:(NSInteger)index;

- (GJGCInformationBaseModel *)contentModelAtIndex:(NSInteger)index;

- (CGFloat)rowHeightAtIndex:(NSInteger)index;

- (void)addInformationItem:(GJGCInformationCellContentModel *)item;

- (void)insertInformationItem:(GJGCInformationCellContentModel *)item AtIndex:(NSInteger)index;

- (void)removeAtIndex:(NSInteger)index;

/**
 *  删除所以数据项
 */
- (void)removeAllData;

@end
