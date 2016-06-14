//
//  GJGCPulicGroupListDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCPulicGroupListDataManager.h"
#import "EMCursorResult.h"
#import "GJGCGroupInfoExtendModel.h"
#import "Base64.h"
#import "EMGroup.h"

@interface GJGCPulicGroupListDataManager ()

@property (nonatomic,strong)NSString *loadMoreCursor;

@end

@implementation GJGCPulicGroupListDataManager

- (void)refresh
{
    self.loadMoreCursor = nil;
    
    [super refresh];
}

- (void)requestListData
{
    GJCFWeakSelf weakSelf = self;
    [[EMClient sharedClient].groupManager asyncGetPublicGroupsFromServerWithCursor:self.loadMoreCursor pageSize:20 success:^(EMCursorResult *aCursor) {
        
        [weakSelf addGroupList:aCursor];

    } failure:^(EMError *aError) {
        
        
    }];
}

- (void)addGroupList:(EMCursorResult *)result
{
    if (result.list.count < 20) {
        self.isReachFinish = YES;
    }
    
    if (self.isRefresh) {
        [self clearData];
    }
    
    self.loadMoreCursor = result.cursor;
    
    for (EMGroup *group in result.list) {
        
        GJGCInfoBaseListContentModel *contentModel = [[GJGCInfoBaseListContentModel alloc]init];
        
        contentModel.groupId = group.groupId;
        
        NSData *extendData = [group.subject base64DecodedData];
        NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
        
        GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
        if(groupInfoExtend){
            contentModel.title = groupInfoExtend.name;
            contentModel.summary = groupInfoExtend.simpleDescription;
            contentModel.groupLabels = groupInfoExtend.labels;
            contentModel.headUrl = groupInfoExtend.headUrl;
            NSDate *date = GJCFDateFromStringByFormat(groupInfoExtend.addTime,kNSDateHelperFormatSQLDateWithTime);
            contentModel.time = [NSString stringWithFormat:@"始于:%@",GJCFDateToStringByFormat(date, kNSDateHelperFormatSQLDate)];
        }
        
        [self addContentModel:contentModel];
    }
    
    self.isRefresh = NO;
    self.isLoadMore = NO;
    [self.delegate dataManagerRequireRefresh:self];
}

@end
