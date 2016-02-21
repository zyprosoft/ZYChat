//
//  GJGCChatFriendVideoCell.h
//  ZYChat
//
//  Created by ZYVincent on 16/2/21.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"

@interface GJGCChatFriendVideoCell : GJGCChatFriendBaseCell

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

- (void)stopAction;

- (void)playAction;

@end
