//
//  GJGCCreateGroupDataManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCCreateGroupContentModel.h"

@class GJGCCreateGroupDataManager;
@protocol GJGCCreateGroupDataManagerDelegate <NSObject>

- (void)dataManagerRequireRefresh:(GJGCCreateGroupDataManager *)dataManager;

- (void)dataManagerRequireRefresh:(GJGCCreateGroupDataManager *)dataManager reloadAtIndexPaths:(NSArray *)indexPaths;

- (void)dataManager:(GJGCCreateGroupDataManager *)dataManager showErrorMessage:(NSString *)message;

- (void)dataManagerDidCreateGroupSuccess:(GJGCCreateGroupDataManager *)dataManager;

@end

@interface GJGCCreateGroupDataManager : NSObject

@property (nonatomic,weak)id<GJGCCreateGroupDataManagerDelegate> delegate;

@property (nonatomic,readonly)NSInteger totalCount;

- (GJGCCreateGroupContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath;

- (void)updateTextContentWith:(NSString *)contentValue forIndexPath:(NSIndexPath *)indexPath;

- (void)updateSimpleDescription:(NSString *)description;

- (void)updateMemberCount:(NSString *)memberCount;

- (void)updateLabels:(NSString *)labels;

- (void)updateAddress:(NSString *)address;

- (void)updateHeadUrl:(NSString *)headUrl;

- (void)updateGroupType:(NSNumber *)type display:(NSString *)display;

- (void)uploadGroupInfoAction;

- (void)createMemberList;

@end
