//
//  GJGCChatFriendMusicShareCell.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/25.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendMusicShareCell.h"
#import "SCSiriWaveformView.h"

@interface GJGCChatFriendMusicShareCell ()

@property (nonatomic,strong)UIImageView *thumbImageView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *sumaryLabel;

@property (nonatomic,assign)CGFloat contentInnerMargin;

@property (nonatomic,strong)UIActivityIndicatorView *downloadIndicator;

@property (nonatomic,strong)SCSiriWaveformView *waver;

@end

@implementation GJGCChatFriendMusicShareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentInnerMargin = 11.f;
        
        self.waver = [[SCSiriWaveformView alloc] initWithFrame:CGRectZero];
        self.waver.backgroundColor = [UIColor clearColor];
        self.waver.phaseShift = 1.0;
        self.waver.density = 3;
        self.waver.hidden = YES;
        [self.bubbleBackImageView addSubview:self.waver];
        
        self.thumbImageView = [[UIImageView alloc]init];
        self.thumbImageView.gjcf_size = (CGSize){55,55};
        self.thumbImageView.userInteractionEnabled = YES;
        [self.bubbleBackImageView addSubview:self.thumbImageView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.titleLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        [self.bubbleBackImageView addSubview:self.titleLabel];
        
        self.sumaryLabel = [[UILabel alloc]init];
        self.sumaryLabel.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
        self.sumaryLabel.textColor = [UIColor whiteColor];
        self.sumaryLabel.numberOfLines = 0;
        [self.bubbleBackImageView addSubview:self.sumaryLabel];
        
        self.downloadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.downloadIndicator.gjcf_size = CGSizeMake(10, 10);
        self.downloadIndicator.gjcf_centerY = self.bubbleBackImageView.gjcf_height/2;
        [self.contentView addSubview:self.downloadIndicator];
        self.downloadIndicator.hidden = YES;
        
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf)];
        tapR.numberOfTapsRequired = 1;
        [self.bubbleBackImageView addGestureRecognizer:tapR];
        
        
        UITapGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnPlay)];
        tapPlay.numberOfTapsRequired = 1;
        [self.thumbImageView addGestureRecognizer:tapPlay];
        
    }
    return self;
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    GJGCChatFriendContentModel *chatModel = (GJGCChatFriendContentModel *)contentModel;
    
    [super setContentModel:chatModel];
    
    CGFloat bubbleToBordMargin = 56;
    
    CGFloat maxTextContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 5.5 - 13 - 2*self.contentInnerMargin+5;
    
    self.titleLabel.gjcf_width = maxTextContentWidth - 2*self.contentInnerMargin - self.thumbImageView.gjcf_width;
    self.titleLabel.text = chatModel.musicSongName;
    self.titleLabel.gjcf_height = 13.f;
    
    
    //是否正在播放音乐
    UIImage *iconImage = chatModel.isPlayingAudio? [UIImage imageNamed:@"pause"]:[UIImage imageNamed:@"play"];
    self.thumbImageView.image = iconImage;
    self.thumbImageView.gjcf_left = self.contentBordMargin;
    self.thumbImageView.gjcf_top = self.contentBordMargin;
    
    self.titleLabel.gjcf_left = self.thumbImageView.gjcf_right + self.contentBordMargin-5;
    self.titleLabel.gjcf_top = self.thumbImageView.gjcf_top + 7.f;
    
    self.sumaryLabel.gjcf_width = self.titleLabel.gjcf_width;
    self.sumaryLabel.text = chatModel.musicSongAuthor;
    self.sumaryLabel.gjcf_height = self.thumbImageView.gjcf_height - self.titleLabel.gjcf_height - 4.f;
    
    self.sumaryLabel.gjcf_left = self.titleLabel.gjcf_left;
    self.sumaryLabel.gjcf_top = self.titleLabel.gjcf_bottom + 3.f;
    
    self.bubbleBackImageView.gjcf_height = self.thumbImageView.gjcf_bottom + self.contentBordMargin;
    self.bubbleBackImageView.gjcf_width = self.titleLabel.gjcf_right + self.contentInnerMargin;
    self.waver.gjcf_width = self.bubbleBackImageView.gjcf_width-5.f;
    self.waver.gjcf_height = self.bubbleBackImageView.gjcf_height;
    
    [self adjustContent];
    
    if (self.isFromSelf) {
        self.sumaryLabel.textColor = [UIColor whiteColor];
        self.downloadIndicator.gjcf_right = self.bubbleBackImageView.gjcf_left - 15;
        self.waver.waveColor = [UIColor whiteColor];
        self.waver.gjcf_left = 0.f;
        
    }else{
        self.sumaryLabel.textColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
        self.downloadIndicator.gjcf_left = self.bubbleBackImageView.gjcf_right + 15;
        self.waver.waveColor = [GJGCCommonFontColorStyle mainThemeColor];
        self.waver.gjcf_right = self.bubbleBackImageView.gjcf_width;
    }
    self.waver.hidden = !chatModel.isPlayingAudio;
    self.titleLabel.textColor = self.sumaryLabel.textColor;
    self.downloadIndicator.gjcf_centerY = self.bubbleBackImageView.gjcf_centerY;

}

#pragma mark - 长按事件继承

- (void)goToShowLongPressMenu:(UILongPressGestureRecognizer *)sender
{
    [super goToShowLongPressMenu:sender];
    
    UIMenuController *popMenu = [UIMenuController sharedMenuController];
    if (popMenu.isMenuVisible) {
        return;
    }

    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    NSArray *menuItems = @[item2];
    [popMenu setMenuItems:menuItems];
    [popMenu setArrowDirection:UIMenuControllerArrowDown];
    
    [popMenu setTargetRect:self.bubbleBackImageView.frame inView:self];
    [popMenu setMenuVisible:YES animated:YES];
}

- (void)tapOnSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidTapOnMusicShare:)]) {
        
        [self.delegate chatCellDidTapOnMusicShare:self];
    }
}

- (void)tapOnPlay
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidTapOnMusicSharePlayButton:)]) {
        
        [self.delegate chatCellDidTapOnMusicSharePlayButton:self];
    }
}

- (void)startDownloadAction
{
    self.downloadIndicator.hidden = NO;
    [self.downloadIndicator startAnimating];
}

- (void)playAudioAction
{
    self.waver.hidden = NO;
    [self.downloadIndicator stopAnimating];
    self.downloadIndicator.hidden = YES;
    self.thumbImageView.image = [UIImage imageNamed:@"pause"];
}

- (void)faildDownloadAction
{
    self.waver.hidden = YES;
    self.thumbImageView.image = [UIImage imageNamed:@"play"];
    [self.downloadIndicator stopAnimating];
    self.downloadIndicator.hidden = YES;
}

- (void)finishPlayAudioAction
{
    [self faildDownloadAction];
    
}

- (void)updateMeter:(CGFloat)meter
{
    [self.waver updateWithLevel:meter];
}

@end
