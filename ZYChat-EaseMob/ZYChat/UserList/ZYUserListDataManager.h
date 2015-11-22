//
//  ZYUserListDataManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserListContentModel.h"

@class ZYUserListDataManager;
@protocol ZYUserListDataManagerDelegate <NSObject>

- (void)dataManagerRequireRefresh:(ZYUserListDataManager *)dataManager;

@end

@interface ZYUserListDataManager : NSObject

@property (nonatomic,weak)id<ZYUserListDataManagerDelegate> delegate;

@property (nonatomic,readonly)NSInteger totalCount;

- (ZYUserListContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath;

- (void)requestUserList;

@end
