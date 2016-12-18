//
//  GJGCMusicPlayViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/25.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMusicPlayViewController.h"
#import "GJGCMusicSearchResultListViewController.h"
#import "ZYDataCenter.h"
#import "UIImage+BlurredFrame.h"
#import "UIImage+ImageEffects.h"
#import "GJGCRecentContactListViewController.h"
#import "GJGCMusicSharePlayer.h"

@interface GJGCMusicPlayViewController ()<UISearchBarDelegate>

@property (nonatomic,strong)UISearchBar *searchBar;

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

@property (nonatomic,strong)UIActivityIndicatorView *downloadIndicator;

@property (nonatomic,strong)UIButton *forwardButton;

@end

@implementation GJGCMusicPlayViewController

- (instancetype)initWithSongId:(NSString *)songId
{
    if (self = [super init]) {
        
        self.songList = [[NSMutableArray alloc]initWithObjects:songId, nil];
        self.currentIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.view.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    
    if (!self.songList) {
        self.songList = [[NSMutableArray alloc]init];
    }
    
    [self setupSearchTitleView];
    
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
    [self.preButton addTarget:self action:@selector(preSongAction) forControlEvents:UIControlEventTouchUpInside];
    self.preButton.gjcf_centerY = self.playButton.gjcf_centerY;
    self.preButton.gjcf_right = self.playButton.gjcf_left - 30.f;
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.gjcf_size = (CGSize){45,45};
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateSelected];
    [self.view addSubview:self.nextButton];
    [self.nextButton addTarget:self action:@selector(nextSongAction) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.gjcf_centerY = self.playButton.gjcf_centerY;
    self.nextButton.gjcf_left= self.playButton.gjcf_right + 30.f;
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardButton.gjcf_width = 40.f;
    self.forwardButton.gjcf_height = 20.f;
    [self.forwardButton setTitleColor:GJCFQuickHexColor(@"31c27c") forState:UIControlStateNormal];
    [self.forwardButton setTitle:@"转发" forState:UIControlStateNormal];
    self.forwardButton.gjcf_right = GJCFSystemScreenWidth - 40.f;
    self.forwardButton.gjcf_top = 30.f;
    [self.forwardButton addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forwardButton];
    
    [self audioSetupObserver];
    
    if (self.songList.count > 0) {
        [self getSongDetailInfoWithSongId:self.songList[0]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[GJCFAudioManager shareManager]stopPlayCurrentAudio];
    [[GJCFAudioManager shareManager]clearAllCurrentObserverBlocks];
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
    forwardContentModel.songId = self.songList[self.currentIndex];
    forwardContentModel.imageUrl = self.currentSongImgUrl;
    forwardContentModel.contentType = GJGCChatFriendContentTypeMusicShare;
    
    GJGCRecentContactListViewController *recentList = [[GJGCRecentContactListViewController alloc]initWithForwardContent:forwardContentModel];
    
    UINavigationController *recentNav = [[UINavigationController alloc]initWithRootViewController:recentList];
    
    UIImage *navigationBarBack = GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], CGSizeMake(GJCFSystemScreenWidth * GJCFScreenScale, 64.f * GJCFScreenScale));
    [recentNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController presentViewController:recentNav animated:YES completion:nil];
}

- (void)playAction
{
    if (self.songList.count == 0) {
        return;
    }
    
    if (GJCFStringIsNull(self.currentSongMp3Url)) {
        BTToast(@"没有音乐播放地址");
        return;
    }
    
    self.playButton.selected = !self.playButton.isSelected;
    
    if (self.playButton.isSelected) {
        [[GJCFAudioManager shareManager] startPlayFromLastStopTimestamp];
    }else{
        [[GJCFAudioManager shareManager] stopPlayCurrentAudio];
    }
}

- (void)preSongAction
{
    if (self.songList.count == 0) {
        return;
    }
    
    if (self.currentIndex == 0) {
        [self showErrorMessage:@"已经是第一首了"];
        return;
    }
    
    [[GJCFAudioManager shareManager]stopPlayCurrentAudio];
    
    if (self.currentIndex > 0) {
        self.currentIndex--;
    }
    [self getSongDetailInfoWithSongId:self.songList[self.currentIndex]];
}

- (void)nextSongAction
{
    if (self.songList.count == 0) {
        return;
    }
    
    if (self.currentIndex == self.songList.count-1) {
        [self showErrorMessage:@"已经是最后一首了"];
        return;
    }
    
    [[GJCFAudioManager shareManager]stopPlayCurrentAudio];

    if (self.currentIndex < self.songList.count-1) {
        self.currentIndex++;
    }
    [self getSongDetailInfoWithSongId:self.songList[self.currentIndex]];
}

- (void)dealloc
{
    [[GJCFAudioManager shareManager] stopPlayCurrentAudio];
     [self removeAudioObserver];
}

- (void)slideValueChanged:(UISlider *)theSlider
{
    
}

- (void)setupSearchTitleView
{
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.gjcf_width = GJCFSystemScreenWidth - 2*40.f;
    self.searchBar.gjcf_height = 36.f;
    self.searchBar.placeholder = @"搜索歌曲";
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor whiteColor];
    
    self.searchBar.searchBarStyle = UISearchBarIconResultsList;
    self.navigationItem.titleView = self.searchBar;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    GJGCMusicSearchResultListViewController *resultVC = [[GJGCMusicSearchResultListViewController alloc]init];
    resultVC.title = @"搜索结果";
    resultVC.keyword = searchBar.text;
    
    GJCFWeakSelf weakSelf = self;
    resultVC.resultBlock = ^(BTActionSheetBaseContentModel *resultModel){
        
        [weakSelf detailWithSongInfo:resultModel.userInfo];
    };
    
    [resultVC showFromViewController:self];
}

- (void)detailWithSongInfo:(NSDictionary *)songInfo
{
    [self.songList removeAllObjects];
    [self.songList addObjectsFromArray:songInfo[@"list"]];
    self.currentIndex = [songInfo[@"index"]integerValue];
    
    self.nameLabel.text = songInfo[@"name"];
    [self.nameLabel sizeToFit];
    self.nameLabel.gjcf_centerX = self.albumImageView.gjcf_centerX;
    self.nameLabel.gjcf_bottom = self.albumImageView.gjcf_top - 6.f;
    
    [self getSongDetailInfoWithSongId:songInfo[@"data"]];
}

- (void)getSongDetailInfoWithSongId:(NSString *)songId
{
    ZYDataCenterRequestCondition *condition = [[ZYDataCenterRequestCondition alloc]init];
    condition.requestMethod = ZYNetworkRequestMethodGET;
    condition.thirdServerHost = @"http://music.163.com";
    condition.thirdServerInterface = @"/api/song/detail";
    condition.isThirdPartRequest = YES;
    condition.getParams = @{
                             @"id":songId,
                             @"ids":[NSString stringWithFormat:@"[%@]",songId],
                             };
    condition.headerValues = @{
                               @"Referer":@"http://music.163.com",
                               };
    
    [self.downloadIndicator startAnimating];
    self.downloadIndicator.hidden = NO;
    
    GJCFWeakSelf weakSelf = self;
    [[ZYDataCenter shareCenter]thirdServerRequestWithCondition:condition withSuccessBlock:^(ZYNetWorkTask *task, NSDictionary *response) {
        
        [weakSelf setupPlayInfo:response];
        
    } withFaildBlock:^(ZYNetWorkTask *task, NSError *error) {
       
        BTToast(@"歌曲信息获取失败");
        
        [weakSelf.downloadIndicator stopAnimating];
        weakSelf.downloadIndicator.hidden = YES;
        
    }];
    
}

- (void)audioSetupObserver
{
    GJCFWeakSelf weakSelf = self;
    [[GJCFAudioManager shareManager] setCurrentAudioPlayProgressBlock:^(NSString *audioLocalPath, CGFloat progress, CGFloat duration) {
        
        
        [weakSelf.slider setValue:progress animated:YES];
        
    }];
    
    [[GJCFAudioManager shareManager] setStartRemoteUrlPlayBlock:^(NSString *remoteUrl, NSString *localWavPath) {
      
        [weakSelf.downloadIndicator stopAnimating];
        weakSelf.downloadIndicator.hidden = YES;
        weakSelf.playButton.selected = YES;
        
    }];
    
    [[GJCFAudioManager shareManager] setFaildPlayRemoteUrlBlock:^(NSString *remoteUrl) {
        
        BTToast(@"歌曲下载播放失败");
        
        [weakSelf.downloadIndicator stopAnimating];
        weakSelf.downloadIndicator.hidden = YES;
        
    }];
    
    [[GJCFAudioManager shareManager] setCurrentAudioPlayFinishedBlock:^(NSString *audioLocalPath) {
       
        [weakSelf nextSongAction];
        
    }];
}

- (void)removeAudioObserver
{
    [[GJCFAudioManager shareManager] clearAllCurrentObserverBlocks];
}

- (void)setupPlayInfo:(NSDictionary *)songInfo
{
    [[GJCFAudioManager shareManager] stopPlayCurrentAudio];
    
    NSDictionary *songDict = [songInfo[@"songs"] firstObject][@"album"];
    self.currentSongMp3Url = [songInfo[@"songs"] firstObject][@"mp3Url"];
    self.currentSongAuthor = [songDict[@"artists"]firstObject][@"name"];
    self.currentSongImgUrl = songDict[@"blurPicUrl"];
    if (GJCFStringIsNull(self.currentSongMp3Url)) {
        BTToast(@"没有音乐播放地址");
        [self.downloadIndicator stopAnimating];
        self.downloadIndicator.hidden = YES;
        return;
    }
    
    NSString *songName = [songInfo[@"songs"] firstObject][@"name"];
    NSString *songId = [songInfo[@"songs"] firstObject][@"id"];
    self.nameLabel.text = songName;
    [self.nameLabel sizeToFit];
    self.nameLabel.gjcf_centerX = self.albumImageView.gjcf_centerX;
    self.nameLabel.gjcf_bottom = self.albumImageView.gjcf_top - 6.f;
    
    if ([GJGCMusicSharePlayer sharePlayer].audioPlayer.isPlaying) {
        [[GJGCMusicSharePlayer sharePlayer].audioPlayer stop];
    }
    //播放音乐
    [[GJCFAudioManager shareManager] playRemoteMusicByUrl:self.currentSongMp3Url withCacheFileName:songId];
    
    [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:songDict[@"blurPicUrl"]]];
    
    UIImage *bgImage = [UIImage imageNamed:@"poster_bg.jpg"];
    UIImage *placeHolderImage = [bgImage applyTintEffectWithColor:[UIColor colorWithWhite:0.1 alpha:0.5] atFrame:CGRectMake(0, 0,bgImage.size.width,bgImage.size.height)];
    
    GJCFWeakSelf weakSelf = self;
    [self.backImageview sd_setImageWithURL:[NSURL URLWithString:songDict[@"blurPicUrl"]] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [weakSelf setupBlurryImage:image];
        
    }];
}

- (void)setupBlurryImage:(UIImage *)theImage
{
    CGRect frame = CGRectMake(0, 0, theImage.size.width, theImage.size.height);
    UIImage *blurryImage = [theImage applyTintEffectWithColor:[UIColor colorWithWhite:0.1 alpha:0.5] atFrame:frame];
    
    self.backImageview.image = blurryImage;
}

@end
