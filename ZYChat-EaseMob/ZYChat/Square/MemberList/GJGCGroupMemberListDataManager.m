//
//  GJGCGroupMemberListDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCGroupMemberListDataManager.h"

@interface GJGCGroupMemberListDataManager ()

@property (nonatomic,strong)NSString *loadMoreCursor;

@end

@implementation GJGCGroupMemberListDataManager

- (void)loadMore
{
    
}

- (void)requestListData
{
    GJCFWeakSelf weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:self.groupId includeMembersList:YES error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                
                [weakSelf addMemberList:group.occupants];
                
            }else{
                
                BTToast(@"群成员列表获取失败");
            }
        });
    });
}

- (void)addMemberList:(NSArray *)list
{
    self.isReachFinish = YES;
    if (self.isRefresh) {
        [self clearData];
    }
    
    for (NSString *userId in list) {
        
        GJGCInfoBaseListContentModel *contentModel = [[GJGCInfoBaseListContentModel alloc]init];
        contentModel.headUrl = @"http://imgsrc.baidu.com/forum/pic/item/9d82d158ccbf6c81f34d2e53bc3eb13533fa4016.jpg";
        contentModel.title = userId;
        contentModel.summary = @"iOS码农专用签名";
        
        [self addContentModel:contentModel];
    }
    
    self.isRefresh = NO;
    self.isLoadMore = NO;
    [self.delegate dataManagerRequireRefresh:self];
}


@end
