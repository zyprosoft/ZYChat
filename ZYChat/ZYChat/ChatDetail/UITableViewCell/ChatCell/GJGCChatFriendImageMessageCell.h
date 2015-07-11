//
//  GJGCChatFriendImageMessageCell.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"

@interface GJGCChatFriendImageMessageCell : GJGCChatFriendBaseCell

@property (nonatomic,copy)NSString *imgUrl;

@property (nonatomic,strong)UIImageView *contentImageView;

@property (nonatomic,strong)UIImageView *blankImageView;

@property (nonatomic,strong)GJCUProgressView *progressView;

@property (nonatomic,assign)CGFloat downloadProgress;

- (void)resetState;

- (void)resetStateWithPrepareSize:(CGSize)pSize;

- (void)removePrepareState;

- (void)faildState;

- (void)successDownloadWithImageData:(NSData *)imageData;

@end
