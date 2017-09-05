//
//  GJGCMusicPlayerViewController.m
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCMusicPlayingViewController.h"
#import "GJGCMusicSearchResultListViewController.h"
#import "ZYDataCenter.h"
#import "UIImage+BlurredFrame.h"
#import "UIImage+ImageEffects.h"
#import "GJGCRecentContactListViewController.h"
#import "GJGCMusicSharePlayer.h"

@interface GJGCMusicPlayingViewController ()

@property (nonatomic,strong)UIImageView *backImageview;

@property (nonatomic,strong)UIImageView *albumImageView;

@property (nonatomic,strong)UIButton *playButton;

@property (nonatomic,strong)UIButton *preButton;

@property (nonatomic,strong)UIButton *nextButton;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *durationLabel;

@property (nonatomic,strong)NSMutableArray *songList;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)UISlider *slider;

@property (nonatomic,strong)NSString *currentSongMp3Url;

@property (nonatomic,strong)NSString *currentSongAuthor;

@property (nonatomic,strong)NSString *currentSongImgUrl;

@property (nonatomic,strong)NSString *currentSongId;

@property (nonatomic,strong)UIActivityIndicatorView *downloadIndicator;

@property (nonatomic,strong)UIButton *forwardButton;

@end

@implementation GJGCMusicPlayingViewController

- (instancetype)initWithMusicContent:(GJGCChatFriendContentModel*)contentModel
{
    if (self = [super init]) {
        
        self.currentSongAuthor = contentModel.musicSongAuthor;
        self.currentSongMp3Url = contentModel.musicSongUrl;
        self.currentSongImgUrl = contentModel.musicSongImgUrl;
        self.currentSongId = contentModel.musicSongId;
        
        [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:self.currentSongImgUrl]];
        GJCFWeakSelf weakSelf = self;
        [self.backImageview sd_setImageWithURL:[NSURL URLWithString:self.currentSongImgUrl]placeholderImage:[UIImage imageNamed:@"poster_bg.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [weakSelf setupBlurryImage:image];
            
        }];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"正在播放"];
    
    self.view.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    
    self.backImageview = [[UIImageView alloc]init];
    self.backImageview.gjcf_width = GJCFSystemScreenWidth;
    self.backImageview.gjcf_height = GJCFSystemScreenHeight - self.contentOriginY;
    self.backImageview.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *bgImage = [UIImage imageNamed:@"poster_bg.jpg"];
    self.backImageview.image = [bgImage applyTintEffectWithColor:[UIColor colorWithWhite:0.1 alpha:0.5] atFrame:CGRectMake(0, 0,bgImage.size.width,bgImage.size.height)];
    [self.view addSubview:self.backImageview];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20.f];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.nameLabel];
    self.nameLabel.text = @"没有可播放歌曲";
    [self.nameLabel sizeToFit];
    
    self.albumImageView = [[UIImageView alloc]init];
    self.albumImageView.gjcf_size = CGSizeMake(GJCFSystemScreenWidth - 2*70, GJCFSystemScreenWidth - 2*70);
    [self.view addSubview:self.albumImageView];
    self.albumImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.albumImageView.gjcf_centerY = (GJCFSystemScreenHeight - self.contentOriginY)/2 - 50;
    self.albumImageView.gjcf_centerX = GJCFSystemScreenWidth/2;
    self.albumImageView.image = [UIImage imageNamed:@"poster_bg_small.jpg"];
    self.albumImageView.layer.cornerRadius = 6.f;
    self.albumImageView.layer.masksToBounds = YES;
    self.nameLabel.gjcf_centerX = self.albumImageView.gjcf_centerX;
    self.nameLabel.gjcf_bottom = self.albumImageView.gjcf_top - 20.f;
    
    self.slider = [[UISlider alloc]init];
    self.slider.gjcf_width = self.albumImageView.gjcf_width;
    self.slider.gjcf_height = 1.5f;
    [self.slider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    self.slider.tintColor = GJCFQuickHexColor(@"31c27c");
    [self.view addSubview:self.slider];
    [self.slider setMinimumValue:0.f];
    [self.slider setMaximumValue:1.f];
    [self.slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.gjcf_top = self.albumImageView.gjcf_bottom + 20.f;
    self.slider.gjcf_centerX = self.albumImageView.gjcf_centerX;
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.gjcf_size = (CGSize){45,45};
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateSelected];
    [self.view addSubview:self.playButton];
    [self.playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.gjcf_top = self.slider.gjcf_bottom + 20.f;
    self.playButton.gjcf_centerX = GJCFSystemScreenWidth/2;
    
    self.downloadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.downloadIndicator.gjcf_size = CGSizeMake(30, 30);
    [self.playButton addSubview:self.downloadIndicator];
    self.downloadIndicator.hidden = YES;
    self.downloadIndicator.gjcf_centerX = self.playButton.gjcf_width/2;
    self.downloadIndicator.gjcf_centerY = self.playButton.gjcf_height/2;
    
    self.preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preButton.gjcf_size = (CGSize){45,45};
    [self.preButton setBackgroundImage:[UIImage imageNamed:@"player_btn_pre_normal"] forState:UIControlStateNormal];
    [self.preButton setBackgroundImage:[UIImage imageNamed:@"player_btn_pre_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.preButton];
    self.preButton.gjcf_centerY = self.playButton.gjcf_centerY;
    self.preButton.gjcf_right = self.playButton.gjcf_left - 30.f;
    self.preButton.hidden = YES;
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.gjcf_size = (CGSize){45,45};
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateSelected];
    [self.view addSubview:self.nextButton];
    self.nextButton.gjcf_centerY = self.playButton.gjcf_centerY;
    self.nextButton.gjcf_left= self.playButton.gjcf_right + 30.f;
    self.nextButton.hidden = YES;
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardButton.gjcf_width = 40.f;
    self.forwardButton.gjcf_height = 20.f;
    [self.forwardButton setTitleColor:GJCFQuickHexColor(@"31c27c") forState:UIControlStateNormal];
    [self.forwardButton setTitle:@"转发" forState:UIControlStateNormal];
    self.forwardButton.gjcf_right = GJCFSystemScreenWidth - 40.f;
    self.forwardButton.gjcf_top = 30.f;
    [self.forwardButton addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forwardButton];
    
    self.nameLabel.text = [GJGCMusicSharePlayer sharePlayer].musicSongName;
    
    [[GJGCMusicSharePlayer sharePlayer] addPlayObserver:self];
}

- (void)dealloc
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[GJGCMusicSharePlayer sharePlayer] removePlayObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GJGCMusicSharePlayer sharePlayer] addPlayObserver:self];
    [self setupForPlayingMusic];
}

- (void)forwardAction
{
    GJGCRecentChatForwardContentModel *forwardContentModel = [[GJGCRecentChatForwardContentModel alloc]init];
    forwardContentModel.title = self.nameLabel.text;
    if (GJCFStringIsNull(self.currentSongAuthor)) {
        self.currentSongAuthor = @"佚名";
    }
    forwardContentModel.sumary = self.currentSongAuthor;
    forwardContentModel.webUrl = self.currentSongMp3Url;
    forwardContentModel.songId = self.currentSongId;
    forwardContentModel.contentType = GJGCChatFriendContentTypeMusicShare;
    forwardContentModel.imageUrl = self.currentSongImgUrl;
    
    GJGCRecentContactListViewController *recentList = [[GJGCRecentContactListViewController alloc]initWithForwardContent:forwardContentModel];
    
    UINavigationController *recentNav = [[UINavigationController alloc]initWithRootViewController:recentList];
    
    UIImage *navigationBarBack = GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], CGSizeMake(GJCFSystemScreenWidth * GJCFScreenScale, 64.f * GJCFScreenScale));
    [recentNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController presentViewController:recentNav animated:YES completion:nil];
}

- (void)playAction
{
    if (GJCFStringIsNull(self.currentSongMp3Url)) {
        BTToast(@"没有音乐播放地址");
        return;
    }
    
    self.playButton.selected = !self.playButton.isSelected;
    
    if (self.playButton.isSelected) {
        [[GJGCMusicSharePlayer sharePlayer].audioPlayer stop];
    }else{
        [[GJGCMusicSharePlayer sharePlayer].audioPlayer play];
    }
}

- (void)setupForPlayingMusic
{
    if ([GJGCMusicSharePlayer sharePlayer].audioPlayer.isPlaying) {
        self.slider.value = [GJGCMusicSharePlayer sharePlayer].audioPlayer.progress;
        self.currentSongAuthor = [GJGCMusicSharePlayer sharePlayer].musicSongAuthor;
        self.currentSongMp3Url = [GJGCMusicSharePlayer sharePlayer].musicSongUrl;
        self.currentSongImgUrl = [GJGCMusicSharePlayer sharePlayer].musicSongImgUrl;
        
        [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:self.currentSongImgUrl]];
        GJCFWeakSelf weakSelf = self;
        [self.backImageview sd_setImageWithURL:[NSURL URLWithString:self.currentSongImgUrl]placeholderImage:[UIImage imageNamed:@"poster_bg.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [weakSelf setupBlurryImage:image];
            
        }];
        self.playButton.selected = [GJGCMusicSharePlayer sharePlayer].audioPlayer.isPlaying;
    }
}

- (void)setupBlurryImage:(UIImage *)theImage
{
    CGRect frame = CGRectMake(0, 0, theImage.size.width, theImage.size.height);
    UIImage *blurryImage = [theImage applyTintEffectWithColor:[UIColor colorWithWhite:0.1 alpha:0.5] atFrame:frame];
    
    self.backImageview.image = blurryImage;
}
#pragma mark - GJCFAudioPlayer Delegate
- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didFinishPlayAudio:(GJCFAudioModel *)audioFile
{
    
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didOccusError:(NSError *)error
{
    
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didUpdateSoundMouter:(CGFloat)soundMouter
{
    self.slider.value = audioPlay.progress;
}


@end
