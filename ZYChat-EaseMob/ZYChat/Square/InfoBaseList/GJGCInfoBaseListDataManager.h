//
//  GJGCInfoBaseListDataManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCInfoBaseListContentModel.h"

@class GJGCInfoBaseListDataManager;
@protocol GJGCInfoBaseListDataManagerDelegate <NSObject>

- (void)dataManagerRequireRefresh:(GJGCInfoBaseListDataManager *)dataManager;

@end

@interface GJGCInfoBaseListDataManager : NSObject

@property (nonatomic,weak)id<GJGCInfoBaseListDataManagerDelegate> delegate;

@property (nonatomic,readonly)NSInteger totalCount;

@property (nonatomic,assign)BOOL isRefresh;

@property (nonatomic,assign)BOOL isLoadMore;

@property (nonatomic,assign)NSInteger currentPageIndex;

@property (nonatomic,assign)BOOL isReachFinish;

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (GJGCInfoBaseListContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath;

- (void)addContentModel:(GJGCInfoBaseListContentModel *)contentModel;

- (void)clearData;

- (void)refresh;

- (void)loadMore;

- (void)requestListData;

@end
