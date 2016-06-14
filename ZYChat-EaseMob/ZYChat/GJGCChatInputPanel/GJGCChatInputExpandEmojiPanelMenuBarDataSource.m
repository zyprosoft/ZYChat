//
//  GJGCChatInputExpandEmojiPanelMenuBarDataSource.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/6/4.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCChatInputExpandEmojiPanelMenuBarDataSource.h"

@implementation GJGCChatInputExpandEmojiPanelMenuBarDataSource

+ (NSArray *)menuBarItems
{
    return @[[GJGCChatInputExpandEmojiPanelMenuBarDataSource simpleEmojiItem],[GJGCChatInputExpandEmojiPanelMenuBarDataSource gifEmojiItem],
//        [GJGCChatInputExpandEmojiPanelMenuBarDataSource myFavoriteEmojiItem],
//        [GJGCChatInputExpandEmojiPanelMenuBarDataSource findFunGifEmojiItem]
             ];
}

+ (NSArray *)commentBarItems
{
    return @[[GJGCChatInputExpandEmojiPanelMenuBarDataSource simpleEmojiItem]];
}

+ (GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *)simpleEmojiItem
{
    GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *item = [[GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem alloc]init];
    
    item.emojiType = GJGCChatInputExpandEmojiTypeSimple;
    item.emojiListFilePath = GJCFMainBundlePath(@"emoji.plist");
    item.faceEmojiIconName = @"005[微笑]";
    item.isNeedShowSendButton = YES;
    item.isNeedShowRightSideLine = NO;
    
    return item;
}

+ (GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *)gifEmojiItem
{
    GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *item = [[GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem alloc]init];
    
    item.emojiType = GJGCChatInputExpandEmojiTypeGIF;
    item.emojiListFilePath = GJCFMainBundlePath(@"gifEmoji.plist");
    item.faceEmojiIconName = @"抠鼻";
    item.isNeedShowSendButton = NO;
    item.isNeedShowRightSideLine = YES;
    
    return item;
}

+ (GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *)myFavoriteEmojiItem
{
    GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *item = [[GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem alloc]init];
    
    item.emojiType = GJGCChatInputExpandEmojiTypeMyFavorit;
    item.emojiListFilePath = GJCFMainBundlePath(@"gifEmoji.plist");
    item.faceEmojiIconName = @"抠鼻";
    item.isNeedShowSendButton = NO;
    item.isNeedShowRightSideLine = YES;
    
    return item;
}

+ (GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *)findFunGifEmojiItem
{
    GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *item = [[GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem alloc]init];
    
    item.emojiType = GJGCChatInputExpandEmojiTypeFindFunGif;
    item.emojiListFilePath = GJCFMainBundlePath(@"gifEmoji.plist");
    item.faceEmojiIconName = @"抠鼻";
    item.isNeedShowSendButton = NO;
    item.isNeedShowRightSideLine = YES;
    
    return item;
}

@end
