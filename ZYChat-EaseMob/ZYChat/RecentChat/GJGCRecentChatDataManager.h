//
//  GJGCRecentChatDataManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/18.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCRecentChatModel.h"
#import "GJGCRecentChatTitleView.h"

@class GJGCRecentChatDataManager;
@protocol GJGCRecentChatDataManagerDelegate <NSObject>

- (void)dataManagerRequireRefresh:(GJGCRecentChatDataManager *)dataManager;

- (void)dataManagerRequireRefresh:(GJGCRecentChatDataManager *)dataManager requireDeletePaths:(NSArray *)paths;

- (void)dataManager:(GJGCRecentChatDataManager *)dataManager requireUpdateTitleViewState:(GJGCRecentChatConnectState)connectState;

- (BOOL)dataManagerRequireKnownViewIsShowing:(GJGCRecentChatDataManager *)dataManager;

@end

@interface GJGCRecentChatDataManager : NSObject

@property (nonatomic,readonly)NSInteger totalCount;

@property (nonatomic,weak)id<GJGCRecentChatDataManagerDelegate> delegate;

- (GJGCRecentChatModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath;

- (void)deleteConversationAtIndexPath:(NSIndexPath *)indexPath;

- (void)loadRecentConversations;

- (NSArray *)allConversationModels;

+ (BOOL)isConversationHasBeenExist:(NSString *)chatter;

@end
