//
//  GJGCInformationBaseDataSourceManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationBaseDataSourceManager.h"
#import "GJGCInformationCellContentModel.h"
#import "GJGCInformationCellStyle.h"

@interface GJGCInformationBaseDataSourceManager ()

@property (nonatomic,strong)NSMutableArray *contentListArray;

@end

@implementation GJGCInformationBaseDataSourceManager

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initState];
    }
    return self;
}

- (void)initState
{
    self.contentListArray = [[NSMutableArray alloc]init];
}

- (NSInteger)totalCount
{
    return self.contentListArray.count;
}

- (Class)contentCellAtIndex:(NSInteger)index
{
    GJGCInformationBaseModel *baseContentModel = [self contentModelAtIndex:index];
    
    if (!baseContentModel) {
        return nil;
    }
    
    return [GJGCInformationCellConstans classForContentType:baseContentModel.baseContentType];
}

- (NSString *)contentCellIdentifierAtIndex:(NSInteger)index
{
    GJGCInformationBaseModel *baseContentModel = [self contentModelAtIndex:index];
    
    if (!baseContentModel) {
        return nil;
    }
    
    return [GJGCInformationCellConstans identifierForContentType:baseContentModel.baseContentType];
}

- (GJGCInformationBaseModel *)contentModelAtIndex:(NSInteger)index
{
    if (index < 0 || index > self.contentListArray.count - 1) {
        return nil;
    }
    return [self.contentListArray objectAtIndex:index];
}

- (CGFloat)rowHeightAtIndex:(NSInteger)index
{
    GJGCInformationBaseModel *contentModel = [self contentModelAtIndex:index];
    
    return contentModel.contentHeight;
}

- (NSNumber *)heightForContentModel:(GJGCInformationCellContentModel *)contentModel
{
    if (!contentModel) {
        return nil;
    }
    
    Class cellClass = [GJGCInformationCellConstans classForContentType:contentModel.baseContentType];
    GJGCInformationBaseCell *baseCell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [baseCell setContentInformationModel:contentModel];
    
    return [NSNumber numberWithFloat:[baseCell heightForInformationModel:contentModel]];
}

- (void)addInformationItem:(GJGCInformationCellContentModel *)item
{
    if (!item) {
        return;
    }
    item.contentHeight = [[self heightForContentModel:item] floatValue];
    [self.contentListArray addObject:item];
}

- (void)insertInformationItem:(GJGCInformationCellContentModel *)item AtIndex:(NSInteger)index
{
    if (!item || index < 0 || index > self.contentListArray.count-1) {
        return;
    }
    [self.contentListArray insertObject:item atIndex:index];
}

- (void)removeAtIndex:(NSInteger)index
{
    if (index < 0 || index > self.contentListArray.count-1) {
        return;
    }
    [self.contentListArray removeObjectAtIndex:index];
}

- (void)removeAllData
{
    [self.contentListArray removeAllObjects];
}

@end
