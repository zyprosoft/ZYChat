//
//  GJGCVideoRecordViewController.m
//  ZYChat
//
//  Created by ZYVincent on 16/2/21.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCVideoRecordViewController.h"
#import "ZFProgressView.h"
#import "TTMAVCaptureManager.h"

@interface GJGCVideoRecordViewController ()<TTMAVCaptureManagerDelegate>

@property (nonatomic,strong)UIView *preView;

@property (nonatomic,strong)ZFProgressView *progressView;

@property (nonatomic,strong)UIButton *recordButton;

@property (nonatomic,strong)UIButton *closeButton;

@property (nonatomic, strong) TTMAVCaptureManager *captureManager;

@property (nonatomic, assign) NSTimer *timer;

@property (nonatomic, assign) NSTimeInterval startTime;

@end

@implementation GJGCVideoRecordViewController

- (instancetype)initWithDelegate:(id<GJGCVideoRecordViewControllerDelegate>)aDelegate
{
    if (self = [super init]) {
        
        self.delegate = aDelegate;
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.preView = [[UIView alloc]init];
    self.preView.gjcf_width = GJCFSystemScreenWidth;
    self.preView.gjcf_height = GJCFSystemScreenHeight -  120.f;
    [self.view addSubview:self.preView];
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *start = [UIImage imageNamed:@"ShutterButton1"];
    UIImage *stop = [UIImage imageNamed:@"ShutterButtonStop"];
    self.recordButton.gjcf_size = start.size;
    self.recordButton.layer.masksToBounds =  YES;
    [self.recordButton setBackgroundImage:start forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:stop forState:UIControlStateSelected];
    self.recordButton.tintColor = [UIColor redColor];
    [self.view addSubview:self.recordButton];
    self.recordButton.gjcf_centerY = GJCFSystemScreenHeight - 60.f - 20.f;
    self.recordButton.gjcf_centerX = GJCFSystemScreenWidth/2;
    [self.recordButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.progressView = [[ZFProgressView alloc]initWithFrame:CGRectMake(0, 0, start.size.width + 35.f, start.size.height + 35.f)];
//    self.progressView.progressStrokeColor = [UIColor orangeColor];
//    self.progressView.backgroundStrokeColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.progressView];
//    self.progressView.center = self.recordButton.center;
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.gjcf_size = (CGSize){65,35};
    self.closeButton.layer.cornerRadius = 13.f;
    self.closeButton.layer.masksToBounds = YES;
    [self.closeButton setBackgroundImage:GJCFQuickImageByColorWithSize([UIColor colorWithWhite:0.3 alpha:0.6], self.closeButton.gjcf_size) forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    self.closeButton.gjcf_left = 20.f;
    self.closeButton.gjcf_top = 40.f;
    [self.view addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.captureManager = [[TTMAVCaptureManager alloc] initWithPreviewView:self.preView mode:TTMOutputModeVideoData];
    self.captureManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeAction
{
    [self touchUp:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)timerHandler:(NSTimer *)timer
{
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval recorded = current - self.startTime;
    
    CGFloat progress = recorded/self.maxDuration;
//    [self.progressView setProgress:progress Animated:YES];
    
    if (recorded >= self.maxDuration) {
        
        [self touchUp:nil];
    }
}

- (void)touchDown:(UIButton *)sender
{
    // timer start
    self.startTime = [[NSDate date] timeIntervalSince1970];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(timerHandler:)
                                                userInfo:nil
                                                 repeats:YES];
    
    [self.captureManager startRecording];
}

- (void)touchUp:(UIButton *)sender
{
    [self.captureManager stopRecording];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL error:(NSError *)error {
    
    if (error) {
        NSLog(@"error:%@", error);
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoRecordViewController:didFinishRecordWithResult:)]) {
        
        [self.delegate videoRecordViewController:self didFinishRecordWithResult:outputFileURL];
    }
}

@end
