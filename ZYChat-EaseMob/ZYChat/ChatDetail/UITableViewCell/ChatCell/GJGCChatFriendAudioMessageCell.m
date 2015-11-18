//
//  GJGCChatFriendAudioMessageCell.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendAudioMessageCell.h"

@implementation GJGCChatFriendAudioMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentInnerMargin = 5.f;
        
        self.audioPlayIndicatorView = [[UIImageView alloc]init];
        self.audioPlayIndicatorView.gjcf_width = 14;
        self.audioPlayIndicatorView.gjcf_height = 18.5;
        [self.audioPlayIndicatorView setAnimationDuration:1.f];
        [self.bubbleBackImageView addSubview:self.audioPlayIndicatorView];
        
        self.audioTimeLabel = [[GJCFCoreTextContentView alloc]init];
        self.audioTimeLabel.gjcf_width = 100;
        self.audioTimeLabel.gjcf_height = 15;
        self.audioTimeLabel.contentBaseWidth = self.audioTimeLabel.gjcf_width;
        self.audioTimeLabel.contentBaseHeight = self.audioTimeLabel.gjcf_height;
        self.audioTimeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.audioTimeLabel];
        
        self.downloadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.downloadIndicator.gjcf_size = CGSizeMake(10, 10);
        self.downloadIndicator.gjcf_centerY = self.bubbleBackImageView.gjcf_height/2;
        [self.bubbleBackImageView addSubview:self.downloadIndicator];
        self.downloadIndicator.hidden = YES;
        
        self.isAudioPlayTagView = [[UIImageView alloc]init];
        self.isAudioPlayTagView.gjcf_width = 8.f;
        self.isAudioPlayTagView.gjcf_height = 8.f;
        self.isAudioPlayTagView.image = GJCFQuickImage(@"新消息提醒-bg-个位");
        [self.contentView addSubview:self.isAudioPlayTagView];
        self.isAudioPlayTagView.hidden = YES;
        
        //tap
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf)];
        tapR.numberOfTapsRequired = 1;
        [self.bubbleBackImageView addGestureRecognizer:tapR];
        
    }
    return self;
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    [super setContentModel:contentModel];
    
    GJGCChatFriendContentModel *chatContentModel = (GJGCChatFriendContentModel *)contentModel;
    self.isFromSelf = chatContentModel.isFromSelf;
    
    self.audioTimeLabel.contentAttributedString = chatContentModel.audioDuration;
    self.audioTimeLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:chatContentModel.audioDuration forBaseContentSize:self.audioTimeLabel.contentBaseSize];
    CGFloat audioDuration = [chatContentModel.audioDuration.string floatValue];
    self.bubbleBackImageView.gjcf_width = [self getBubbleWidthByVoiceDuration:audioDuration];
    
    if (chatContentModel.isPlayingAudio) {
        [self playAudioAction];
    }else{
        [self finishPlayAudioAction];
    }
    
    if (chatContentModel.isDownloading) {
        
        [self startDownloadAction];
        
    }else{
        
        [self faildDownloadAction];
    }
    
    [self adjustContent];
    
    if (chatContentModel.isRead || self.isFromSelf) {
        
        self.isAudioPlayTagView.hidden = YES;
        
    }else{
        
        self.isAudioPlayTagView.hidden = NO;
    }
    
    if (self.isFromSelf) {
        self.audioTimeLabel.gjcf_right = self.bubbleBackImageView.gjcf_left - 5;
        self.statusButton.gjcf_right = self.audioTimeLabel.gjcf_left - 5;
        self.audioPlayIndicatorView.image = GJCFQuickImage(@"聊天-icon-语音-绿.png");
        self.audioPlayIndicatorView.gjcf_rightToSuper = self.audioPlayIndicatorView.image.size.width - 5;
        self.audioPlayIndicatorView.gjcf_centerY = self.bubbleBackImageView.gjcf_height/2;
        
        self.downloadIndicator.gjcf_left = 5 + 5;

    }else{
        self.audioTimeLabel.gjcf_left = self.bubbleBackImageView.gjcf_right + 5;
        self.isAudioPlayTagView.gjcf_left = self.audioTimeLabel.gjcf_right + 8;
        self.statusButton.gjcf_right = self.audioTimeLabel.gjcf_right + 5;
        self.audioPlayIndicatorView.image = GJCFQuickImage(@"聊天-icon-语音及切换键盘-灰.png");
        self.audioPlayIndicatorView.gjcf_left = 10;
        self.audioPlayIndicatorView.gjcf_centerY = self.bubbleBackImageView.gjcf_height/2;
        
        self.downloadIndicator.gjcf_right = self.bubbleBackImageView.gjcf_width - 5 - 5;

    }
    self.statusButtonOffsetAudioDuration = self.audioTimeLabel.gjcf_width;
    self.audioTimeLabel.gjcf_centerY = self.bubbleBackImageView.gjcf_centerY;
    self.isAudioPlayTagView.gjcf_centerY = self.audioTimeLabel.gjcf_centerY;
    self.statusButton.gjcf_centerY = self.audioTimeLabel.gjcf_centerY;

}

- (void)tapOnSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioMessageCellDidTap:)]) {
        [self.delegate audioMessageCellDidTap:self];
    }
}

- (void)startDownloadAction
{
    self.downloadIndicator.hidden = NO;
    [self.downloadIndicator startAnimating];
}

- (void)faildDownloadAction
{
    [self.downloadIndicator stopAnimating];
    self.downloadIndicator.hidden = YES;
}

- (void)playAudioAction
{
    [self faildDownloadAction];
    
    if (self.isFromSelf) {
        
        self.audioPlayIndicatorView.animationImages = [self myAudioPlayIndicatorImages];
        if (!self.audioPlayIndicatorView.isAnimating) {
            [self.audioPlayIndicatorView startAnimating];
        }
        
    }else{
        
        self.isAudioPlayTagView.hidden = YES;
        self.audioPlayIndicatorView.animationImages = [self otherAudioPlayIndicatorImages];
        if (!self.audioPlayIndicatorView.isAnimating) {
            [self.audioPlayIndicatorView startAnimating];
        }
    }
}

- (void)finishPlayAudioAction
{
    [self faildDownloadAction];

    if (self.audioPlayIndicatorView.isAnimating) {
        [self.audioPlayIndicatorView stopAnimating];
    }
    self.audioPlayIndicatorView.animationImages = nil;
    if (self.isFromSelf) {
        self.audioPlayIndicatorView.image = GJCFQuickImage(@"聊天-icon-语音-绿.png");
    }else{
        self.audioPlayIndicatorView.image = GJCFQuickImage(@"聊天-icon-语音及切换键盘-灰.png");
    }
}

- (CGFloat)getBubbleWidthByVoiceDuration:(CGFloat)mVoiceTime
{
    if (mVoiceTime < 3) {
        return 132/2 - 6;
    }
    else if (mVoiceTime < 11)
    {
        return 132/2 - 6 + (mVoiceTime - 3) * (252/2 - 132/2 - 6)/13;
    }
    else if (mVoiceTime < 60)
    {
        return 132/2 - 6 + (8  + ((NSInteger)((mVoiceTime - 10)/10))) * (252/2 - 132/2 - 6)/(13);
    }
    return 252/2 - 6;
}

- (void)goToShowLongPressMenu:(UILongPressGestureRecognizer *)sender
{
    [super goToShowLongPressMenu:sender];
    if (sender.state == UIGestureRecognizerStateBegan) {
        //
        [self becomeFirstResponder];
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
        NSArray *menuItems = @[item1];
        [popMenu setMenuItems:menuItems];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        
        [popMenu setTargetRect:self.bubbleBackImageView.frame inView:self];
        [popMenu setMenuVisible:YES animated:YES];
        
    }
}

@end
