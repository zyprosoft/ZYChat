//
//  ZYUserListDataManager.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
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
