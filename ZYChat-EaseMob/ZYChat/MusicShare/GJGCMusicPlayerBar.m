//
//  GJGCMusicPlayerBar.m
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCMusicPlayerBar.h"

@interface GJGCMusicPlayerBar ()

@property (nonatomic,strong)UIButton *playButton;

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation GJGCMusicPlayerBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:97/255.f green:60/255.f blue:140/255.f alpha:0.8];

        self.gjcf_height = 54.f;
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.gjcf_size = (CGSize){36,36};
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateSelected];
        [self addSubview:self.playButton];
        [self.playButton addTarget:self action:@selector(stopAction) forControlEvents:
         UIControlEventTouchUpInside];
        self.playButton.selected = YES;
        self.playButton.gjcf_left = 18.f;
        self.playButton.gjcf_centerY = self.gjcf_height/2;
        
       self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.playButton.gjcf_right + 13.f, 4,GJCFSystemScreenWidth - 36- 2*13, 44)];
        NSString *songName = [GJGCMusicSharePlayer sharePlayer].musicSongName;
        self.titleLabel.textColor = GJCFQuickHexColor(@"31c27c");
        self.titleLabel.font = [UIFont systemFontOfSize:17.f];
        self.titleLabel.text = songName;
        [self.titleLabel sizeToFit];
        self.titleLabel.gjcf_centerY = self.gjcf_height/2;
        self.titleLabel.gjcf_left = self.playButton.gjcf_right + 23.f;
        [self addSubview:self.titleLabel];
        
        UIImageView *bottomLine = [[UIImageView alloc]init];
        bottomLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
        bottomLine.gjcf_height = 0.5f;
        bottomLine.gjcf_width = GJCFSystemScreenWidth;
        bottomLine.gjcf_bottom = self.gjcf_height;
        [self addSubview:bottomLine];
        
        [self startMove];
        
        [[GJGCMusicSharePlayer sharePlayer]addPlayObserver:self];
        
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf)];
        [self addGestureRecognizer:tapR];
    }
    return self;
}

- (void)startMove
{
    CAKeyframeAnimation *pAnimation = [CAKeyframeAnimation  animation];
    pAnimation.keyPath = @"transform.translation.x";
    [pAnimation setValues:@[[NSNumber numberWithFloat:0.f],[NSNumber numberWithFloat:GJCFSystemScreenWidth-self.titleLabel.gjcf_left]]];
    pAnimation.duration = 20.f;
    [pAnimation setRepeatCount:NSIntegerMax];
    [self.titleLabel.layer addAnimation:pAnimation forKey:@"moveX"];
    
}

- (void)tapOnSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTappedMusicPlayerBar)]) {
        [self.delegate didTappedMusicPlayerBar];
    }
}

- (void)dealloc
{
    [[GJGCMusicSharePlayer sharePlayer] removePlayObserver:self];
}

- (void)stopAction
{
    self.playButton.selected = !self.playButton.isSelected;
    if ([GJGCMusicSharePlayer sharePlayer].audioPlayer.isPlaying) {
        [self.titleLabel.layer removeAnimationForKey:@"moveX"];
        [[GJGCMusicSharePlayer sharePlayer].audioPlayer stop];
    }else{
        [self startMove];
        [[GJGCMusicSharePlayer sharePlayer].audioPlayer play];
    }
}

#pragma mark - GJCFAudioPlayer Delegate
- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didFinishPlayAudio:(GJCFAudioModel *)audioFile
{
    self.playButton.selected = !self.playButton.isSelected;
    [self.titleLabel.layer removeAnimationForKey:@"moveX"];
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didOccusError:(NSError *)error
{
    self.playButton.selected = !self.playButton.isSelected;
    [self.titleLabel.layer removeAnimationForKey:@"moveX"];
}
- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didUpdateSoundMouter:(CGFloat)soundMouter
{
    
}

+ (GJGCMusicPlayerBar *)currentMusicBar
{
    GJGCMusicPlayerBar *bar = [[GJGCMusicPlayerBar alloc]initWithFrame:CGRectMake(0, 0, GJCFSystemScreenWidth, 44)];
    return bar;
}


@end
