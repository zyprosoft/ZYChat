//
//  GJGCChatInputExpandEmojiPanelPageItem.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-26.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCChatInputExpandEmojiPanelPageItem : UIView

@property (nonatomic,strong)NSString *panelIdentifier;

- (instancetype)initWithFrame:(CGRect)frame withEmojiNameArray:(NSArray *)emojiArray;


@end
