//
//  GJGCChatInputExpandMenuPanelDataSource.m
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatInputExpandMenuPanelDataSource.h"


/**
 *  重要提示
 *
 *  新增扩展面板功能的时候在GJGCChatInputConst.h增加一个新的动作类型
 *  然后在这里创建一个Item绑定新增加的动作类型
 */

@implementation GJGCChatInputExpandMenuPanelDataSource

+ (NSArray *)menuItemDataSourceWithConfigModel:(GJGCChatInputExpandMenuPanelConfigModel *)configModel
{
    return [GJGCChatInputExpandMenuPanelDataSource menuPanelDataSource];
}

+ (NSArray *)postPanelDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource cameraMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource photoLibraryMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource myFavoritePostMenuPanelItem]];
        
    return dataSource;
}

+ (NSArray *)groupPanelDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource cameraMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource photoLibraryMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource groupCallMenuPanelItem]];
    
    return dataSource;
}

+ (NSArray *)menuPanelDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource cameraMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource photoLibraryMenuPanelItem]];
    
    return dataSource;
}

+ (NSDictionary *)cameraMenuPanelItem
{
    return @{
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"相机",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"聊天键盘-icon-拍照",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"聊天键盘-icon-拍照-点击",

             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeCamera)
             
             };
}

+ (NSDictionary *)photoLibraryMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"照片库",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"聊天键盘-icon-选择照片",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"聊天键盘-icon-选择照片-点击",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypePhotoLibrary)
             
             };
}

+ (NSDictionary *)myFavoritePostMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"收藏夹",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"聊天键盘-icon-选择帖子",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"聊天键盘-icon-选择帖子-点击",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeMyFavoritePost)
             
             };
}

+ (NSDictionary *)groupCallMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"群主召唤",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"聊天键盘-icon-群主召唤",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"聊天键盘-icon-群主召唤-点击",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeGroupCall)
             
             };
}


@end
