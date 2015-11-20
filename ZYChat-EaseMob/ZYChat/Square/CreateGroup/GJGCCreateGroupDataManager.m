//
//  GJGCCreateGroupDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCCreateGroupDataManager.h"
#import "GJGCCreateGroupBaseCell.h"

@interface GJGCCreateGroupDataManager ()

@property (nonatomic,strong)NSMutableArray *sourceArray;



@end

@implementation GJGCCreateGroupDataManager

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

- (GJGCCreateGroupContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.sourceArray objectAtIndex:indexPath.row];
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCCreateGroupContentModel *contentModel = [self contentModelAtIndexPath:indexPath];
    
    return [GJGCCreateGroupConst cellIdentifierForContentType:contentModel.contentType];
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCCreateGroupContentModel *contentModel = [self contentModelAtIndexPath:indexPath];
    
    return [GJGCCreateGroupConst cellClassForContentType:contentModel.contentType];
}

- (void)addContentModel:(GJGCCreateGroupContentModel *)contentModel
{
    if (contentModel.contentHeight == 0 && contentModel.isMutilContent) {
        
        Class className = [GJGCCreateGroupConst cellClassForContentType:contentModel.contentType];
        
        GJGCCreateGroupBaseCell  *cell = [[className alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setContentModel:contentModel];
        contentModel.contentHeight = [cell cellHeight];
    }
    
    [self.sourceArray addObject:contentModel];
}

- (void)updateTextContentWith:(NSString *)contentValue forIndexPath:(NSIndexPath *)indexPath
{
    GJGCCreateGroupContentModel *contentModel = [self contentModelAtIndexPath:indexPath];
    contentModel.content = contentValue;
    
    NSLog(@"填写群组创建:%@",contentValue);
    
    [self.sourceArray replaceObjectAtIndex:indexPath.row withObject:contentModel];
}

- (void)showErrorMessage:(NSString *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataManager:showErrorMessage:)]) {
        [self.delegate dataManager:self showErrorMessage:message];
    }
}

- (void)createMemberList
{
    //名称
    GJGCCreateGroupContentModel *nameItem = [[GJGCCreateGroupContentModel alloc]init];
    nameItem.tagName = @"群组名称";
    nameItem.contentType = GJGCCreateGroupContentTypeSubject;
    nameItem.placeHolder = @"请填写群组名称";
    nameItem.maxInputLength = 15;
    
    [self addContentModel:nameItem];
    
    //简介
    GJGCCreateGroupContentModel *descriptionItem = [[GJGCCreateGroupContentModel alloc]init];
    descriptionItem.tagName = @"群组简介";
    descriptionItem.contentType = GJGCCreateGroupContentTypeDescription;
    descriptionItem.content = @"请填写群组简介";
    descriptionItem.isShowDetailIndicator = YES;

    [self addContentModel:descriptionItem];
    
    //人数
    GJGCCreateGroupContentModel *memeberCountItem = [[GJGCCreateGroupContentModel alloc]init];
    memeberCountItem.tagName = @"群组人数";
    memeberCountItem.contentType = GJGCCreateGroupContentTypeMemberCount;
    memeberCountItem.content = @"请选择群组人数";
    memeberCountItem.isShowDetailIndicator = YES;
    
    [self addContentModel:memeberCountItem];
    
    //头像
    GJGCCreateGroupContentModel *headItem = [[GJGCCreateGroupContentModel alloc]init];
    headItem.tagName = @"群组头像";
    headItem.contentType = GJGCCreateGroupContentTypeHeadThumb;
    headItem.content = @"请选择群组头像";
    headItem.isShowDetailIndicator = YES;
    
    [self addContentModel:headItem];
    
    //位置
    GJGCCreateGroupContentModel *locationItem = [[GJGCCreateGroupContentModel alloc]init];
    locationItem.tagName = @"群组位置";
    locationItem.contentType = GJGCCreateGroupContentTypeLocation;
    locationItem.content = @"请选择群组位置";
    locationItem.isShowDetailIndicator = YES;

    [self addContentModel:locationItem];
    
    //地址
    GJGCCreateGroupContentModel *addressItem = [[GJGCCreateGroupContentModel alloc]init];
    addressItem.tagName = @"群组地址";
    addressItem.contentType = GJGCCreateGroupContentTypeAddress;
    addressItem.placeHolder = @"请输入详细地址";
    addressItem.maxInputLength = 30;
    
    [self addContentModel:addressItem];
    
    //标签
    GJGCCreateGroupContentModel *labelsItem = [[GJGCCreateGroupContentModel alloc]init];
    labelsItem.tagName = @"群组标签";
    labelsItem.contentType = GJGCCreateGroupContentTypeLabels;
    labelsItem.content = @"请选择标签";
    labelsItem.isShowDetailIndicator = YES;
    
    [self addContentModel:labelsItem];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataManagerRequireRefresh:)]) {
        
        [self.delegate dataManagerRequireRefresh:self];
    }
}

- (void)uploadGroupInfoAction
{
    
}

- (void)updateSimpleDescription:(NSString *)description
{
    [self updateDisplayWithContentType:GJGCCreateGroupContentTypeDescription withDisplayContent:description];
    [self.delegate dataManagerRequireRefresh:self];
}

- (void)updateMemberCount:(NSString *)memberCount
{
    [self updateDisplayWithContentType:GJGCCreateGroupContentTypeMemberCount withDisplayContent:memberCount];
    [self.delegate dataManagerRequireRefresh:self];
}

- (void)updateLabels:(NSString *)labels
{
    [self updateDisplayWithContentType:GJGCCreateGroupContentTypeLabels withDisplayContent:labels];
    [self.delegate dataManagerRequireRefresh:self];
}

- (void)updateDisplayWithContentType:(GJGCCreateGroupContentType)contentType withDisplayContent:(NSString *)content
{
    NSInteger findIndex = NSNotFound;
    GJGCCreateGroupContentModel *findContent = nil;
    
    for (NSInteger index =0 ; index < self.sourceArray.count; index++) {
        
        GJGCCreateGroupContentModel *item = self.sourceArray[index];
        
        if (item.contentType == contentType) {
            
            findIndex = index;
            findContent = item;
            break;
        }
    }
    
    if (findContent && findIndex != NSNotFound) {
        
        findContent.content = content;
        
        [self.sourceArray replaceObjectAtIndex:findIndex withObject:findContent];
    }
}

@end
