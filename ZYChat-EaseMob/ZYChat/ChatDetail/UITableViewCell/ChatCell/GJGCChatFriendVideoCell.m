//
//  GJGCChatFriendVideoCell.m
//  ZYChat
//
//  Created by ZYVincent on 16/2/21.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendVideoCell.h"

@interface GJGCChatFriendVideoCell ()

@property (nonatomic,strong)UIImageView *playIconView;

@end

@implementation GJGCChatFriendVideoCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentImageView = [[UIImageView alloc]init];
        self.contentImageView.image = GJCFImageStrecth([UIImage imageNamed:@"IM聊天页-占位图-BG.png"], 2, 2);
        self.contentImageView.gjcf_size = (CGSize){160,160};
        self.contentImageView.userInteractionEnabled = YES;
        
        [self.bubbleBackImageView addSubview:self.contentImageView];
        
        self.blankImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IM聊天页-占位图"]];
        [self.contentImageView addSubview:self.blankImageView];
        self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
        self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
        
        self.progressView = [[GJCUProgressView alloc]init];
        self.progressView.frame = self.contentImageView.bounds;
        self.progressView.hidden = YES;
        [self.contentImageView addSubview:self.progressView];
        
        self.player = [[VKVideoPlayer alloc] init];
        self.player.view.frame = self.contentImageView.frame;
        self.player.playerControlsEnabled = NO;
        self.player.view.playerControlsAutoHideTime = @(0.01);
        [self.bubbleBackImageView addSubview:self.player.view];
        self.player.view.hidden =YES;
        
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnContentImageView)];
        tapR.numberOfTapsRequired = 1;
        [self.bubbleBackImageView addGestureRecognizer:tapR];
    }
    return self;
}

#pragma mark - 点击图片

- (void)tapOnContentImageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoMessageCellDidTap:)]) {
        [self.delegate videoMessageCellDidTap:self];
    }
}

- (void)resetState
{
    
}

- (void)resetStateWithPrepareSize:(CGSize)pSize
{
    self.contentImageView.gjcf_size = pSize;
    self.contentImageView.image = GJCFImageStrecth([UIImage imageNamed:@"IM聊天页-占位图-BG.png"], 2, 2);
    [self resetMaxBlankImageViewSize];
    self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
    self.progressView.frame = self.contentImageView.bounds;
    self.blankImageView.hidden = NO;
    self.progressView.progress = 0.f;
    self.progressView.hidden = YES;
}

- (void)resetMaxBlankImageViewSize
{
    CGFloat blankToBord = 8.f;
    
    CGFloat minSide = MIN(self.contentImageView.gjcf_width, self.contentImageView.gjcf_height);
    
    CGFloat blankWidth = minSide - 2*blankToBord;
    
    self.blankImageView.gjcf_size = CGSizeMake(blankWidth, blankWidth);
}

- (void)removePrepareState
{
    self.blankImageView.hidden = YES;
    self.progressView.hidden = YES;
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    [super setContentModel:contentModel];
    
    GJGCChatFriendContentModel *chatContentModel = (GJGCChatFriendContentModel *)contentModel;
    self.isFromSelf = chatContentModel.isFromSelf;
    self.videoUrl = chatContentModel.videoUrl;

    EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody *)chatContentModel.message.body;
    
    [self resetStateWithPrepareSize:videoMessageBody.thumbnailSize];
    
    if (chatContentModel.isFromSelf || videoMessageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
        
        self.contentSize = videoMessageBody.thumbnailSize;
        self.contentImageView.gjcf_size = self.contentSize;
        self.contentImageView.image = GJCFQuickImageByFilePath(videoMessageBody.thumbnailLocalPath);
        
    }
    
    /* 重设气泡 */
    self.bubbleBackImageView.gjcf_height = self.contentImageView.gjcf_height + 12;
    self.bubbleBackImageView.gjcf_width = self.contentImageView.gjcf_width + 12 + 5;
    
    [self adjustContent];
    
    self.contentImageView.gjcf_top = 6.f;
    if (self.isFromSelf) {
        
        self.contentImageView.gjcf_left = 6.f;
        
    }else{
        
        self.contentImageView.gjcf_right = self.bubbleBackImageView.gjcf_width - 6;
    }
    self.player.view.frame = self.contentImageView.frame;
}

- (void)goToShowLongPressMenu:(UILongPressGestureRecognizer *)sender
{
    [super goToShowLongPressMenu:sender];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //
        [self becomeFirstResponder];
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
        NSArray *menuItems = @[item2];
        [popMenu setMenuItems:menuItems];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        
        [popMenu setTargetRect:self.bubbleBackImageView.frame inView:self];
        [popMenu setMenuVisible:YES animated:YES];
        
    }

}

- (void)setDownloadProgress:(CGFloat)downloadProgress
{
    if (_downloadProgress == downloadProgress) {
        return;
    }
    self.progressView.hidden = NO;
    _downloadProgress = downloadProgress;
    self.progressView.progress = downloadProgress;
}

- (void)faildDownloadAction
{
    CGSize thumbNoScaleSize;
    if (self.imgUrl) {
        
        CGSize imageSize = CGSizeMake(80, 140);
        thumbNoScaleSize = [GJGCImageResizeHelper getCutImageSize:imageSize maxSize:CGSizeMake(160, 160)];
        
    }else{
        
        thumbNoScaleSize = (CGSize){160,160};
    }
    
    self.contentImageView.gjcf_size = thumbNoScaleSize;
    self.contentImageView.image = GJCFImageStrecth([UIImage imageNamed:@"IM聊天页-占位图-BG.png"], 2, 2);
    self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
    self.blankImageView.hidden = NO;
    self.progressView.progress = 0.f;
    self.progressView.hidden = YES;
}

- (void)successDownloadWithImageData:(NSData *)imageData
{
    if (imageData) {
        [self  removePrepareState];
        self.contentImageView.image = [UIImage imageWithData:imageData];
    }
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(deleteMessage:) || action == @selector(reSendMessage)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

- (void)stopAction
{
//    [self pause];
}

- (void)playAction
{
    [self resume];
}

- (void)pause
{
//    [self.player pauseContent];
}

- (void)resume
{
    self.contentImageView.hidden = YES;
    self.player.view.hidden = NO;
    if (!self.player.isPlayingVideo && self.videoUrl) {
        [self.player  loadVideoWithStreamURL:self.videoUrl];
    }else{
//        [self.player playContent];
    }
}

@end
