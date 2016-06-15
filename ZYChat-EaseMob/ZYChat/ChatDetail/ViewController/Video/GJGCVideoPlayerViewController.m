//
//  GJGCVideoRecordViewController.m
//  ZYChat
//
//  Created by ZYVincent on 16/2/21.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCVideoPlayerViewController.h"
#import "VKVideoPlayer.h"

@interface GJGCVideoPlayerViewController ()

@property (nonatomic,strong)VKVideoPlayer *player;

@property (nonatomic,strong)NSURL *theVideoUrl;

@end

@implementation GJGCVideoPlayerViewController

- (instancetype)initWithDelegate:(id<GJGCVideoPlayerViewControllerDelegate>)aDelegate withVideoUrl:(NSURL *)videoUrl
{
    if (self = [super init]) {
        
        self.delegate = aDelegate;
        self.theVideoUrl = videoUrl;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.player = [[VKVideoPlayer alloc] init];
    self.player.view.gjcf_size = CGSizeMake(GJCFSystemScreenWidth, GJCFSystemScreenHeight-64);
    self.player.playerControlsEnabled = NO;
    self.player.view.playerControlsAutoHideTime = @(0.01);
    [self.view addSubview:self.player.view];
    
    [self.player loadVideoWithStreamURL:self.theVideoUrl];
    
    UIButton *rightCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
    [rightCloseButton addTarget:self action:@selector(tappOnClose) forControlEvents:UIControlEventTouchUpInside];
    rightCloseButton.gjcf_size = CGSizeMake(60, 36);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightCloseButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)tappOnClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
