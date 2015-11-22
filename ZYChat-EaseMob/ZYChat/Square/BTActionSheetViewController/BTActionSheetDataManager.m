//
//  BTActionSheetDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetDataManager.h"

@interface BTActionSheetDataManager ()

@property (nonatomic,strong)NSMutableArray *sourceArray;

@end

@implementation BTActionSheetDataManager

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
    BTActionSheetBaseContentModel *contentModel = [self contentModelAtIndexPath:indexPath];
    
    return [BTActionSheetConst cellClassForContentType:contentModel.contentType];
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
    BTActionSheetBaseContentModel *contentModel = [self contentModelAtIndexPath:indexPath];
    
    return [BTActionSheetConst cellIdentifierForContentType:contentModel.contentType];
}

- (BTActionSheetBaseContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.sourceArray objectAtIndex:indexPath.row];
}

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath
{
    BTActionSheetBaseContentModel *contentModel = [self contentModelAtIndexPath:indexPath];
    
    return contentModel.contentHeight;
}

- (void)addContentModel:(BTActionSheetBaseContentModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    contentModel.isMutilSelect = self.isMutilSelect;
    
    //自动选中
    if (self.isMutilSelect && self.selectedItems.count > 0) {
        
        for (BTActionSheetBaseContentModel *item in self.selectedItems) {
            
            if ([item isEqual:contentModel]) {
                
                contentModel.selected = item.selected;
                contentModel.disableMutilSelectUserInteract = item.disableMutilSelectUserInteract;
                
                break;
            }
        }
    }
    
    //自动计算高度
    if (contentModel.contentHeight == 0) {
        
        Class cellClass = [BTActionSheetConst cellClassForContentType:contentModel.contentType];
        
        BTActionSheetBaseCell *cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setContentModel:contentModel];
        
        contentModel.contentHeight = [cell cellHeight];
    }
    
    [self.sourceArray addObject:contentModel];
}

- (NSArray *)selectedModels
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (BTActionSheetBaseContentModel *itemModel in self.sourceArray) {
        
        if (itemModel.selected) {
    
            [resultArray addObject:itemModel];
        }
    }
    
    return resultArray;
}

- (void)changeSelectedStateAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isMutilSelect) {
        return;
    }
    
    BTActionSheetBaseContentModel *contentModel = [self contentModelAtIndexPath:indexPath];
    contentModel.selected = !contentModel.selected;
    
    [self.sourceArray replaceObjectAtIndex:indexPath.row withObject:contentModel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataManagerRequireRefresh:reloadAtIndexPaths:)]) {
        
        [self.delegate dataManagerRequireRefresh:self reloadAtIndexPaths:@[indexPath]];
    }
}

- (void)requestContentList
{
    
}


@end
