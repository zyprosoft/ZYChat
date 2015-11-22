//
//  BTActionSheetDataManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTActionSheetBaseContentModel.h"
#import "BTActionSheetConst.h"
#import "BTActionSheetBaseCell.h"

@class BTActionSheetDataManager;
@protocol BTActionSheetDataManagerDelegate <NSObject>

- (void)dataManagerRequireRefresh:(BTActionSheetDataManager *)dataManager;

- (void)dataManagerRequireRefresh:(BTActionSheetDataManager *)dataManager reloadAtIndexPaths:(NSArray *)indexPaths;

@end

@interface BTActionSheetDataManager : NSObject

@property (nonatomic,weak)id<BTActionSheetDataManagerDelegate> delegate;

@property (nonatomic,readonly)NSInteger totalCount;

@property (nonatomic,strong)NSArray *selectedItems;

@property (nonatomic,assign)BOOL isMutilSelect;

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (BTActionSheetBaseContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath;

- (void)addContentModel:(BTActionSheetBaseContentModel *)contentModel;

- (void)changeSelectedStateAtIndexPath:(NSIndexPath *)indexPath;


- (NSArray *)selectedModels;

- (void)requestContentList;

@end
