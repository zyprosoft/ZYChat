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
             @(eGroupStyle_PublicOpenJoin),
             @(eGroupStyle_PublicJoinNeedApproval),
             @(eGroupStyle_PrivateMemberCanInvite),
             @(eGroupStyle_PrivateOnlyOwnerInvite),
             @(eGroupStyle_PublicAnonymous),
             ];
}

- (NSDictionary *)relationDict
{
    return @{
             @(eGroupStyle_PublicOpenJoin) : @"公共群组，任何人可加入",
             @(eGroupStyle_PublicJoinNeedApproval) : @"公共群组，需管理员同意可加入",
             @(eGroupStyle_PrivateMemberCanInvite) : @"私有群组，成员可邀请新成员",
             @(eGroupStyle_PrivateOnlyOwnerInvite) : @"私有群组，只有群主可以邀请新成员",
             @(eGroupStyle_PublicAnonymous) : @"公开匿名群组，任何人可加入",
             };
}

@end
