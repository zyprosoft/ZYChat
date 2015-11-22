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

@implementation GJGCPulicGroupListDataManager

- (void)requestListData
{
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",(long)self.currentPageIndex];
    
    GJCFWeakSelf weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchPublicGroupsFromServerWithCursor:pageIndex pageSize:20 andCompletion:^(EMCursorResult *result, EMError *error) {
        
        if (!error) {
            
            [weakSelf addGroupList:result];
        }
        
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
    
    for (EMGroup *group in result.list) {
        
        GJGCInfoBaseListContentModel *contentModel = [[GJGCInfoBaseListContentModel alloc]init];
        
        contentModel.groupId = group.groupId;
        
        NSData *extendData = [group.groupSubject base64DecodedData];
        NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
        
        GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
        if(groupInfoExtend){
            contentModel.title = groupInfoExtend.name;
            contentModel.summary = groupInfoExtend.simpleDescription;
            contentModel.groupLabels = groupInfoExtend.labels;
            contentModel.headUrl = groupInfoExtend.headUrl;
        }
        
        [self addContentModel:contentModel];
    }
    
    [self.delegate dataManagerRequireRefresh:self];
}

@end
