//
//  GJGCInfoBaseListDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCInfoBaseListDataManager.h"
#import "GJGCInfoBaseListBaseCell.h"

@interface GJGCInfoBaseListDataManager ()

@property (nonatomic,strong)NSMutableArray *sourceArray;

@end

@implementation GJGCInfoBaseListDataManager

- (instancetype)init
{
    if (self = [super init]) {
        
        self.sourceArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSInteger)totalCount
{
    return self.sourceArray.count;
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCInfoBaseListContentModel *contentModel = [self contentModelAtIndexPath:indexPath];
    
    return [GJGCInfoBaseListConst cellClassForContentType:contentModel.contentType];
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCInfoBaseListContentModel *contentModel = [self contentModelAtIndexPath:indexPath];

    return [GJGCInfoBaseListConst cellIdentifierForContentType:contentModel.contentType];
}

- (GJGCInfoBaseListContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.sourceArray objectAtIndex:indexPath.row];
}

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCInfoBaseListContentModel *contentModel = [self contentModelAtIndexPath:indexPath];

    return contentModel.contentHeight;
}

- (void)addContentModel:(GJGCInfoBaseListContentModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    Class cellClass = [GJGCInfoBaseListConst cellClassForContentType:contentModel.contentType];
    
    GJGCInfoBaseListBaseCell *cell = [(GJGCInfoBaseListBaseCell *)[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [cell setContentModel:contentModel];
    contentModel.contentHeight = [cell cellHeight];
    
    [self.sourceArray addObject:contentModel];
}

- (void)clearData
{
    [self.sourceArray removeAllObjects];
}

- (void)refresh
{
    self.currentPageIndex = 0;
    self.isRefresh = YES;
    self.isReachFinish = NO;
    [self requestListData];
}

- (void)loadMore
{
    self.currentPageIndex++;
    self.isLoadMore = YES;
    [self requestListData];
}

- (void)requestListData
{
    
}

@end
