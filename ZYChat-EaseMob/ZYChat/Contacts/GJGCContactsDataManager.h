//
//  GJGCContactsDataManager.h
//  ZYChat
//
//  Created by ZYVincent on 16/8/8.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCContactsContentModel.h"
#import "GJGCContactsConst.h"
#import "GJGCContactsSectionModel.h"

@protocol GJGCContactsDataManagerDelegate <NSObject>

- (void)dataManagerRequireRefreshSection:(NSInteger)section;

- (void)dataManagerrequireRefreshNow;

@end

@interface GJGCContactsDataManager : NSObject

@property (nonatomic,weak)id<GJGCContactsDataManagerDelegate> delegate;

@property (nonatomic,readonly)NSInteger totalSection;

- (void)updateSectionIsChangeExpandStateAtSection:(NSInteger)section;

- (GJGCContactsSectionModel *)sectionModelAtSectionIndex:(NSInteger)section;

- (NSInteger)rowCountsInSection:(NSInteger)section;

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath;

- (Class)cellClassAtIndexPath:(NSIndexPath*)indexPath;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (GJGCContactsContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath;

- (void)requireContactsList;

@end
