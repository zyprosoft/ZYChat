//
//  GJGCCreateGroupDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCCreateGroupDataManager.h"
#import "GJGCCreateGroupBaseCell.h"
#import "GJGCGroupInfoExtendModel.h"

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
    nameItem.tagName = @"名     称";
    nameItem.contentType = GJGCCreateGroupContentTypeSubject;
    nameItem.placeHolder = @"请填写群组名称";
    nameItem.maxInputLength = 15;
    
    [self addContentModel:nameItem];
    
    //简介
    GJGCCreateGroupContentModel *descriptionItem = [[GJGCCreateGroupContentModel alloc]init];
    descriptionItem.tagName = @"简     介";
    descriptionItem.contentType = GJGCCreateGroupContentTypeDescription;
    descriptionItem.content = @"请填写群组简介";
    descriptionItem.isShowDetailIndicator = YES;

    [self addContentModel:descriptionItem];
    
    //人数
    GJGCCreateGroupContentModel *memeberCountItem = [[GJGCCreateGroupContentModel alloc]init];
    memeberCountItem.tagName = @"人     数";
    memeberCountItem.contentType = GJGCCreateGroupContentTypeMemberCount;
    memeberCountItem.placeHolder = @"请选择群组人数";
    memeberCountItem.isShowDetailIndicator = YES;
    
    [self addContentModel:memeberCountItem];
    
    //人数
    GJGCCreateGroupContentModel *groupTypeItem = [[GJGCCreateGroupContentModel alloc]init];
    groupTypeItem.tagName = @"类     型";
    groupTypeItem.contentType = GJGCCreateGroupContentTypeGroupType;
    groupTypeItem.placeHolder = @"请选择群组类型";
    groupTypeItem.isShowDetailIndicator = YES;
    
    [self addContentModel:groupTypeItem];
    
    //头像
    GJGCCreateGroupContentModel *headItem = [[GJGCCreateGroupContentModel alloc]init];
    headItem.tagName = @"头     像";
    headItem.contentType = GJGCCreateGroupContentTypeHeadThumb;
    headItem.placeHolder = @"请选择群组头像";
    headItem.content = @"http://pic.3gbizhi.com/2015/0805/20150805013152212.jpg.255.344.jpg";
    headItem.isShowDetailIndicator = YES;
    
    [self addContentModel:headItem];
    
    //位置
    GJGCCreateGroupContentModel *locationItem = [[GJGCCreateGroupContentModel alloc]init];
    locationItem.tagName = @"位     置";
    locationItem.contentType = GJGCCreateGroupContentTypeLocation;
    locationItem.placeHolder = @"请选择群组位置";
    locationItem.isShowDetailIndicator = YES;

//    [self addContentModel:locationItem];
    
    //地址
    GJGCCreateGroupContentModel *addressItem = [[GJGCCreateGroupContentModel alloc]init];
    addressItem.tagName = @"地     址";
    addressItem.contentType = GJGCCreateGroupContentTypeAddress;
    addressItem.placeHolder = @"请选择地址";
    addressItem.isShowDetailIndicator = YES;

    [self addContentModel:addressItem];
    
    //组织
    GJGCCreateGroupContentModel *companyItem = [[GJGCCreateGroupContentModel alloc]init];
    companyItem.tagName = @"组     织";
    companyItem.contentType = GJGCCreateGroupContentTypeCompany;
    companyItem.placeHolder = @"请输入公司组织信息";
    companyItem.maxInputLength = 30;
    
    [self addContentModel:companyItem];
    
    //标签
    GJGCCreateGroupContentModel *labelsItem = [[GJGCCreateGroupContentModel alloc]init];
    labelsItem.tagName = @"标     签";
    labelsItem.contentType = GJGCCreateGroupContentTypeLabels;
    labelsItem.placeHolder = @"请选择标签";
    labelsItem.isShowDetailIndicator = YES;
    
    [self addContentModel:labelsItem];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataManagerRequireRefresh:)]) {
        
        [self.delegate dataManagerRequireRefresh:self];
    }
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

- (void)updateAddress:(NSString *)address
{
    [self updateDisplayWithContentType:GJGCCreateGroupContentTypeAddress withDisplayContent:address];
    [self.delegate dataManagerRequireRefresh:self];
}

- (void)updateHeadUrl:(NSString *)headUrl
{
    [self updateDisplayWithContentType:GJGCCreateGroupContentTypeHeadThumb withDisplayContent:headUrl];
    [self.delegate dataManagerRequireRefresh:self];
}

- (void)updateGroupType:(NSNumber *)type display:(NSString *)display
{
    NSInteger findIndex = NSNotFound;
    GJGCCreateGroupContentModel *findContent = nil;
    
    for (NSInteger index =0 ; index < self.sourceArray.count; index++) {
        
        GJGCCreateGroupContentModel *item = self.sourceArray[index];
        
        if (item.contentType == GJGCCreateGroupContentTypeGroupType) {
            
            findIndex = index;
            findContent = item;
            break;
        }
    }
    
    if (findContent && findIndex != NSNotFound) {
        
        findContent.content = display;
        findContent.groupStyle = type;
        
        [self.sourceArray replaceObjectAtIndex:findIndex withObject:findContent];
    }
    
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


- (void)uploadGroupInfoAction
{
    //参数合法性检查
    NSString *errMsg = @"";
    BOOL isValidateParams = YES;
    
    EMGroupOptions *groupSetting = [[EMGroupOptions alloc]init];
    
    GJGCGroupInfoExtendModel *groupExtendInfo = [[GJGCGroupInfoExtendModel alloc]init];
    
    for (GJGCCreateGroupContentModel *contentModel in self.sourceArray) {
        
        //群名称
        if (contentModel.contentType == GJGCCreateGroupContentTypeSubject) {
        
            if (GJCFStringIsNull(contentModel.content)) {
                errMsg = @"群名称不可以为空";
                isValidateParams = NO;
                break;
            }else{
                groupExtendInfo.name = contentModel.content;
            }
            
        }
        
        //群类型
        if (contentModel.contentType == GJGCCreateGroupContentTypeGroupType) {
            if (!contentModel.groupStyle) {
                errMsg = @"群类型必须选择";
                isValidateParams = NO;
                break;
            }else{
                groupSetting.style = [contentModel.groupStyle intValue];
            }
        }
        
        //群人数
        if (contentModel.contentType == GJGCCreateGroupContentTypeMemberCount) {
            
            if (GJCFStringIsNull(contentModel.content)) {
                errMsg = @"群人数必须选择";
                isValidateParams = NO;
                break;
            }else{
                groupSetting.maxUsersCount = [contentModel.content integerValue];
            }
        }
        
        //群简介
        if (contentModel.contentType == GJGCCreateGroupContentTypeDescription) {
            
            if (GJCFStringIsNull(contentModel.content)) {
                errMsg = @"群简介必填";
                isValidateParams = NO;
                break;
            }else{
                groupExtendInfo.simpleDescription = contentModel.content;
            }
        }
        
        //群头像
        if (contentModel.contentType == GJGCCreateGroupContentTypeHeadThumb) {
            if (GJCFStringIsNull(contentModel.content)) {
                errMsg = @"群头像必选";
                isValidateParams = NO;
                break;
            }else{
                groupExtendInfo.headUrl = contentModel.content;
            }
        }
        
        //群标签
        if (contentModel.contentType == GJGCCreateGroupContentTypeLabels) {
            if (GJCFStringIsNull(contentModel.content)) {
                errMsg = @"群标签必选";
                isValidateParams = NO;
                break;
            }else{
                groupExtendInfo.labels = contentModel.content;
            }
        }
        
        //群地址
        if (contentModel.contentType == GJGCCreateGroupContentTypeAddress) {
            if (GJCFStringIsNull(contentModel.content)) {
                errMsg = @"群地址必选";
                isValidateParams = NO;
                break;
            }else{
                groupExtendInfo.address = contentModel.content;
            }
        }
        
        //群组织
        if (contentModel.contentType == GJGCCreateGroupContentTypeCompany) {
            groupExtendInfo.company = contentModel.content;
        }
    }
    
    if (!isValidateParams) {
        
        [self.delegate dataManager:self showErrorMessage:errMsg];
        return;
    }
    
    //等级
    groupExtendInfo.level = [GJGCCreateGroupConst levelForGroupMemberCount:groupSetting.maxUsersCount];
    
    //添加时间
    NSString *dateString = GJCFDateToString([NSDate date]);
    groupExtendInfo.addTime = dateString;
    
    //使用群简介来丰富群信息
    NSData *extendData = [NSKeyedArchiver archivedDataWithRootObject:[groupExtendInfo toDictionary]];
    NSString *extendString = [extendData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [[EMClient sharedClient].groupManager asyncCreateGroupWithSubject:extendString description:groupExtendInfo.simpleDescription invitees:nil message:nil setting:groupSetting success:^(EMGroup *aGroup) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate dataManagerDidCreateGroupSuccess:self];

        });
        
    } failure:^(EMError *aError) {
        
        BTToast(aError.description);

    }];
    
}

@end
