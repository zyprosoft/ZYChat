//
//  GJGCChatFriendMusicShareCell.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/25.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"

@interface GJGCChatFriendMusicShareCell : GJGCChatFriendBaseCell

- (void)startDownloadAction;

- (void)playAudioAction;

- (void)updateMeter:(CGFloat)meter;

@end
