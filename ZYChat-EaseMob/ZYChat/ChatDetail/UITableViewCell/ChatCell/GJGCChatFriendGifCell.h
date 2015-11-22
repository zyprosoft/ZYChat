//
//  GJGCChatFriendGifCell.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/6/3.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"

@interface GJGCChatFriendGifCell : GJGCChatFriendBaseCell

@property (nonatomic,assign)CGFloat downloadProgress;

- (void)successDownloadGifFile:(NSData *)fileData;

- (void)faildDownloadGifFile;

@end
