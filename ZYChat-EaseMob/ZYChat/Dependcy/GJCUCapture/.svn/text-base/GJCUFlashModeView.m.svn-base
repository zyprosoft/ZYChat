//
//  GJCUFlashModeView.m
//  GJCoreUserInterface
//
//  Created by ZYVincent on 15-1-23.
//  Copyright (c) 2015年 ganji. All rights reserved.
//

#import "GJCUFlashModeView.h"

#define GJCUModeButtonBaseTag 2323340

@interface GJCUFlashModeView ()

@property (nonatomic,strong)UIButton *autoModeButton;

@property (nonatomic,strong)UIButton *closeModeButton;

@property (nonatomic,strong)UIButton *openModeButton;

@property (nonatomic,strong)UIButton *flashIconImgView;

@property (nonatomic,assign)CGFloat buttonMargin;

@property (nonatomic,assign)CGFloat startMargin;

@property (nonatomic,assign)CGFloat buttonWidth;

@property (nonatomic,assign)CGFloat buttonHeight;

@property (nonatomic,assign)BOOL isExpand;

@property (nonatomic,strong)NSTimer *expandTimer;

@property (nonatomic,assign)NSInteger currentModeButtonIndex;

@end

@implementation GJCUFlashModeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        NSString *bunldePath = GJCFMainBundlePath(@"GJCUCaptureResourceBundle.bundle");
        NSString *FlashOpenIconNormalPath = GJCFBundlePath(bunldePath, @"闪关灯-icon-点击@2x.png");
        NSString *FlashCloseIconHighlightPath = GJCFBundlePath(bunldePath, @"闪关灯-icon-@2x.png");
        
        self.startMargin = 0.f;
        
        self.buttonMargin = 0.f;
        
        self.buttonWidth = 60.f;
        self.buttonHeight = 40.f;
        
        self.gjcf_width = GJCFSystemScreenWidth - 80;
        self.gjcf_height = self.buttonHeight;
        
        /* 默认 */
        self.currentMode = AVCaptureFlashModeAuto;
        
        CGSize buttonSize = CGSizeMake(self.buttonWidth, self.buttonHeight);
        
        
        self.autoModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.autoModeButton.backgroundColor = [UIColor clearColor];
        self.autoModeButton.gjcf_size = buttonSize;
        self.autoModeButton.gjcf_left = self.startMargin;
        [self.autoModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.autoModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.autoModeButton setTitle:@"自动" forState:UIControlStateNormal];
        self.autoModeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.autoModeButton addTarget:self action:@selector(tapOnModeButton:) forControlEvents:UIControlEventTouchUpInside];
        self.autoModeButton.selected = YES;
        self.autoModeButton.tag = GJCUModeButtonBaseTag;
        [self addSubview:self.autoModeButton];
        
        self.openModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.openModeButton.backgroundColor = [UIColor clearColor];
        self.openModeButton.gjcf_size = buttonSize;
        self.openModeButton.gjcf_left = self.autoModeButton.gjcf_left;
        [self.openModeButton setTitleColor:GJCFQuickHexColor(@"f6ce33") forState:UIControlStateSelected];
        [self.openModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.openModeButton setTitle:@"打开" forState:UIControlStateNormal];
        self.openModeButton.selected = YES;
        self.openModeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.openModeButton.tag = GJCUModeButtonBaseTag + 1;
        [self.openModeButton addTarget:self action:@selector(tapOnModeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.openModeButton];
        
        self.closeModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeModeButton.backgroundColor = [UIColor clearColor];
        self.closeModeButton.gjcf_size = buttonSize;
        self.closeModeButton.gjcf_left = self.autoModeButton.gjcf_left;
        self.closeModeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.closeModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.closeModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.closeModeButton addTarget:self action:@selector(tapOnModeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeModeButton setTitle:@"关闭" forState:UIControlStateNormal];
        self.closeModeButton.tag = GJCUModeButtonBaseTag + 2;
        [self addSubview:self.closeModeButton];
        
        self.flashIconImgView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.flashIconImgView.backgroundColor = [UIColor clearColor];
        self.flashIconImgView.userInteractionEnabled = NO;
        self.flashIconImgView.gjcf_width = 12.5;
        self.flashIconImgView.gjcf_height = 20;
        self.flashIconImgView.gjcf_left = self.autoModeButton.gjcf_left;
        self.flashIconImgView.gjcf_centerY = self.gjcf_height/2;
        [self.flashIconImgView setBackgroundImage:GJCFQuickImageByFilePath(FlashCloseIconHighlightPath) forState:UIControlStateNormal];
        [self.flashIconImgView setBackgroundImage:GJCFQuickImageByFilePath(FlashOpenIconNormalPath) forState:UIControlStateSelected];
        [self addSubview:self.flashIconImgView];
        
        [self bringSubviewToFront:self.autoModeButton];
        [self bringSubviewToFront:self.flashIconImgView];
        self.currentModeButtonIndex = self.autoModeButton.tag;
        
        [self sendSubviewToBack:self.openModeButton];
        [self sendSubviewToBack:self.closeModeButton];
        self.openModeButton.hidden = YES;
        self.closeModeButton.hidden = YES;
    }
    
    return self;
}

- (BOOL)isTapOnCurrentModeButton:(UIButton *)sender
{
    if (sender == self.autoModeButton) {
        
        return self.currentMode == AVCaptureFlashModeAuto;
    }
    
    if (sender == self.closeModeButton) {
        
        return self.currentMode == AVCaptureFlashModeOff;
    }
    
    if (sender == self.openModeButton) {
        
        return self.currentMode == AVCaptureFlashModeOn;
    }
    
    return NO;
}

- (void)tapOnModeButton:(UIButton *)sender
{
    BOOL isTapOnCurrentMode = [self isTapOnCurrentModeButton:sender];
    
    if (isTapOnCurrentMode) {
        
        if (self.isExpand) {
            
            [self closeAction];
            
        }else{
            
            [self expandAction];
        }
        
    }else{
    
        /* 改变模式 */
        if (sender == self.autoModeButton) {
            
            self.currentMode = AVCaptureFlashModeAuto;
        }
        
        if (sender == self.openModeButton) {
            
            self.currentMode = AVCaptureFlashModeOn;
            
        }
        
        if (sender == self.closeModeButton) {
            
            self.currentMode = AVCaptureFlashModeOff;
            
        }
        
        self.currentModeButtonIndex = sender.tag;
        [self bringSubviewToFront:sender];
        [self bringSubviewToFront:self.flashIconImgView];

        if (self.isExpand) {
            
            [self closeAction];
        }
        
        
    }
}

- (void)expandAction
{
    if (self.currentMode == AVCaptureFlashModeAuto) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.closeModeButton.gjcf_left = self.startMargin + self.buttonWidth;
                self.openModeButton.gjcf_left = self.startMargin + self.buttonWidth;
                
            }];
            
        } completion:^(BOOL finished) {
           
            self.closeModeButton.hidden = NO;
            self.openModeButton.hidden = NO;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.closeModeButton.gjcf_left = self.startMargin + 2*self.buttonWidth + 2*self.buttonMargin;
                self.openModeButton.gjcf_left = self.startMargin + self.buttonWidth + self.buttonMargin;
                
            }];
            
        }];
    }
    
    if (self.currentMode == AVCaptureFlashModeOn) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.closeModeButton.gjcf_left = self.startMargin + self.buttonWidth;
                self.autoModeButton.gjcf_left = self.startMargin + self.buttonWidth;
                
            }];
            
        } completion:^(BOOL finished) {
            
            self.closeModeButton.hidden = NO;
            self.autoModeButton.hidden = NO;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.closeModeButton.gjcf_left = self.startMargin + 2*self.buttonWidth + 2*self.buttonMargin;
                self.autoModeButton.gjcf_left = self.startMargin + self.buttonWidth + self.buttonMargin;
                
            }];
            
        }];
    
    }
    
    if (self.currentMode == AVCaptureFlashModeOff) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.openModeButton.gjcf_left = self.startMargin + self.buttonWidth;
                self.autoModeButton.gjcf_left = self.startMargin + self.buttonWidth;
                
            }];
            
        } completion:^(BOOL finished) {
            
            self.openModeButton.hidden = NO;
            self.autoModeButton.hidden = NO;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.openModeButton.gjcf_left = self.startMargin + 2*self.buttonWidth + 2*self.buttonMargin;
                self.autoModeButton.gjcf_left = self.startMargin + self.buttonWidth + self.buttonMargin;
                
            }];
            
        }];
    }
    
    self.isExpand = YES;
    
    /* 自动回收，如果长时间不选择 */
    if (self.expandTimer) {
        [self.expandTimer invalidate];
        self.expandTimer = nil;
    }
    
    self.expandTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(autoCloseAction:) userInfo:nil repeats:NO];
}

- (void)closeAction
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.autoModeButton.gjcf_left = self.startMargin;
        self.openModeButton.gjcf_left = self.startMargin;
        self.closeModeButton.gjcf_left = self.startMargin;

    } completion:^(BOOL finished) {
        
        if (self.currentMode == AVCaptureFlashModeAuto) {
            
            self.autoModeButton.hidden = NO;
            self.flashIconImgView.selected = NO;
            
            self.openModeButton.hidden = YES;
            self.closeModeButton.hidden = YES;
        }
        
        if (self.currentMode == AVCaptureFlashModeOn) {
            
            self.autoModeButton.hidden = YES;
            self.closeModeButton.hidden = YES;
            
            self.openModeButton.hidden = NO;
            self.flashIconImgView.selected = YES;
            
        }
        
        if (self.currentMode == AVCaptureFlashModeOff) {
            
            self.autoModeButton.hidden = YES;
            self.openModeButton.hidden = YES;
            
            self.closeModeButton.hidden = NO;
            self.flashIconImgView.selected = NO;

        }
        
    }];

    self.isExpand = NO;
}

- (void)autoCloseAction:(NSTimer *)timer
{
    if (self.expandTimer) {
        [self.expandTimer invalidate];
        self.expandTimer = nil;
    }
    
    [self closeAction];
}

@end
