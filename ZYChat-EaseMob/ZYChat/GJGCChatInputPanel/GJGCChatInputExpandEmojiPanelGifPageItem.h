//
//  GJGCChatInputExpandEmojiPanelGifPageItem.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/6/3.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCChatInputExpandEmojiPanelGifPageItem : UIView

@property (nonatomic,strong)NSString *panelIdentifier;

@property (nonatomic,weak)UIView *panelView;

- (instancetype)initWithFrame:(CGRect)frame withEmojiNameArray:(NSArray *)emojiArray;

- (void)reserve;

@end
