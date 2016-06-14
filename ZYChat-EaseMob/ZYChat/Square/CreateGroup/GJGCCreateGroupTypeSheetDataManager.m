//
//  GJGCCreateGroupTypeSheetDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCCreateGroupTypeSheetDataManager.h"

@implementation GJGCCreateGroupTypeSheetDataManager

- (void)requestContentList
{
    for (NSNumber *type in [self labelsArray]) {
        
        BTActionSheetBaseContentModel *contentModel = [[BTActionSheetBaseContentModel alloc]init];
        contentModel.simpleText = [self relationDict][type];
        contentModel.userInfo = @{
                                  @"type":type,
                                  @"display":contentModel.simpleText,
                                  };
        [self addContentModel:contentModel];
    }
    [self.delegate dataManagerRequireRefresh:self];
}

- (NSArray *)labelsArray
{
    return @[
             @(EMGroupStylePublicOpenJoin),
             @(EMGroupStylePublicJoinNeedApproval),
             @(EMGroupStylePrivateMemberCanInvite),
             @(EMGroupStylePrivateOnlyOwnerInvite),
             ];
}

- (NSDictionary *)relationDict
{
    return @{
             @(EMGroupStylePublicOpenJoin) : @"公共群组，任何人可加入",
             @(EMGroupStylePublicJoinNeedApproval) : @"公共群组，需管理员同意可加入",
             @(EMGroupStylePrivateMemberCanInvite) : @"私有群组，成员可邀请新成员",
             @(EMGroupStylePrivateOnlyOwnerInvite) : @"私有群组，只有群主可以邀请新成员",
             };
}

@end
