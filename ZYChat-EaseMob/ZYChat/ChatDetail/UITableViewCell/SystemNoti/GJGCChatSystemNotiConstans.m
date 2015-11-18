//
//  GJGCChatSystemNotiConstans.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatSystemNotiConstans.h"

@implementation GJGCChatSystemNotiConstans

+ (NSDictionary *)chatCellIdentifierDict
{
    return @{
             
             @"GJGCChatAuthorizAskCell" : @"GJGCChatAuthorizAskCellIdentifier",
             
             @"GJGCChatGroupOperationNotiCell" : @"GJGCChatGroupOperationNotiCellIdentifier",

             @"GJGCChatOtherApplyMyAuthorizWithStateCell" : @"GJGCChatOtherApplyMyAuthorizWithStateCellIdentifier",

             @"GJGCChatSystemNotiBaseCell" : @"GJGCChatSystemNotiBaseCellIdentifier",

             @"GJGCChatSystemActiveGuideCell" : @"GJGCChatSystemActiveGuideCellIdentifier",

             @"GJGCChatSystemInviteFriendJoinGroupCell" : @"GJGCChatSystemInviteFriendJoinGroupCellIdentifier",

             @"GJGCChatSystemPostNotiCell" : @"GJGCChatSystemPostNotiCellIdentifier",

             };
    
}

+ (NSDictionary *)chatCellNotiTypeDict
{
    return @{
             
             @(GJGCChatSystemNotiTypeGroupOperationState) : @"GJGCChatGroupOperationNotiCell",

             @(GJGCChatSystemNotiTypeOtherPersonApplyMyAuthoriz) : @"GJGCChatAuthorizAskCell",

             @(GJGCChatSystemNotiTypeOhtherGroupApplyMyAuthoriz) : @"GJGCChatAuthorizAskCell",
             
             @(GJGCChatSystemNotiTypeOtherGroupApply) : @"GJGCChatAuthorizAskCell",

             @(GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState) : @"GJGCChatOtherApplyMyAuthorizWithStateCell",

             @(GJGCChatSystemNotiTypeSystemOperationState) : @"GJGCChatSystemNotiBaseCell",
             
             @(GJGCChatSystemNotiTypeSystemActiveGuide) : @"GJGCChatSystemActiveGuideCell",
             
             @(GJGCChatSystemNotiTypeInviteFriendJoinGroup) : @"GJGCChatSystemInviteFriendJoinGroupCell",

             @(GJGCChatSystemNotiTypePostSystemNoti) : @"GJGCChatSystemPostNotiCell",

             };
}

+ (NSString *)identifierForCellClass:(NSString *)className
{
    return  [[GJGCChatSystemNotiConstans chatCellIdentifierDict]objectForKey:className];
}

+ (Class)classForNotiType:(GJGCChatSystemNotiType)notiType
{
    NSDictionary *notiNotiTypeDict = [GJGCChatSystemNotiConstans chatCellNotiTypeDict];
    NSString *className = [notiNotiTypeDict objectForKey:@(notiType)];
    
    return NSClassFromString(className);
}

+ (NSString *)identifierForNotiType:(GJGCChatSystemNotiType)notiType
{
    NSDictionary *notiNotiTypeDict = [GJGCChatSystemNotiConstans chatCellNotiTypeDict];
    NSString *className = [notiNotiTypeDict objectForKey:@(notiType)];

    return [GJGCChatSystemNotiConstans identifierForCellClass:className];
}


@end
