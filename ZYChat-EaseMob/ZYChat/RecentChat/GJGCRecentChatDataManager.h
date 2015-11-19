//
//  GJGCRecentChatDataManager.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCRecentChatModel.h"
#import "GJGCRecentChatTitleView.h"

@class GJGCRecentChatDataManager;
@protocol GJGCRecentChatDataManagerDelegate <NSObject>

- (void)dataManagerRequireRefresh:(GJGCRecentChatDataManager *)dataManager;

- (void)dataManager:(GJGCRecentChatDataManager *)dataManager requireUpdateTitleViewState:(GJGCRecentChatConnectState)connectState;

- (BOOL)dataManagerRequireKnownViewIsShowing:(GJGCRecentChatDataManager *)dataManager;

@end

@interface GJGCRecentChatDataManager : NSObject

@property (nonatomic,readonly)NSInteger totalCount;

@property (nonatomic,weak)id<GJGCRecentChatDataManagerDelegate> delegate;

- (GJGCRecentChatModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath;

- (void)loadRecentConversations;

@end
