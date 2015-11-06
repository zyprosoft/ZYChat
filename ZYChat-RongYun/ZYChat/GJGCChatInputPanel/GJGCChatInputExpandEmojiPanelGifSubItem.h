//
//  GJGCChatInputExpandEmojiPanelGifSubItem.h
//  ZYChat
//
//  Created by ZYVincent on 15/6/3.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCChatInputExpandEmojiPanelGifSubItem : UIView

@property (nonatomic,strong)UILabel *iconNameLabel;

@property (nonatomic,readonly)CGRect iconFrame;

- (instancetype)initWithIconImageName:(NSString *)iconName withTitle:(NSString *)title;

- (void)showHighlighted:(BOOL)state;

@end
