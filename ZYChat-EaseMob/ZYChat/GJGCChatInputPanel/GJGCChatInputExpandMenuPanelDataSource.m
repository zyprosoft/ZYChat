//
//  GJGCChatInputExpandMenuPanelDataSource.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-10-28.
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
    
    return dataSource;
}

+ (NSArray *)menuPanelDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource cameraMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource photoLibraryMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource webViewMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource musicShareMenuPanelItem]];

    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource flowerMenuPanelItem]];

    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource videoRecordMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource voiceMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource videoMenuPanelItem]];

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

+ (NSDictionary *)webViewMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"网页",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"聊天键盘-icon-网页",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"聊天键盘-icon-网页",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeWebView)
             
             };
}

+ (NSDictionary *)musicShareMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"音乐",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"聊天键盘-icon-音乐",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"聊天键盘-icon-音乐",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeMusicShare)
             
             };
}

+ (NSDictionary *)appStoreMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"排行榜",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"聊天键盘-icon-商店",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"聊天键盘-icon-商店",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeAppStore)
             
             };
}

+ (NSDictionary *)videoRecordMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"短视频",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"聊天键盘-icon-短视频",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"聊天键盘-icon-短视频",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeLimitVideo)
             
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

+ (NSDictionary *)flowerMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"送花",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"flower_item",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"flower_item",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeFlower)
             
             };
}

+ (NSDictionary *)voiceMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"语音通话",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"flower_item",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"flower_item",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeVoice)
             
             };
}


+ (NSDictionary *)videoMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"视频通话",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"flower_item",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"flower_item",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeVideo)
             
             };
}

@end
