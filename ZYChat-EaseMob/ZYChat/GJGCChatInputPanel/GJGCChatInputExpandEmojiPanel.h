//
//  GJGCChatInputExpandEmojiPanel.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCChatInputExpandEmojiPanel : UIView

@property (nonatomic,strong)NSString *panelIdentifier;

- (void)reserved;

- (instancetype)initWithFrameForCommentBarStyle:(CGRect)frame;

@end
