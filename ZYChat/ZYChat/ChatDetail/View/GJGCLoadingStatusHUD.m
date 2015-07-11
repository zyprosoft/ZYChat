//
//  GJGCLoadingStatusHUD.m
//  ZYChat
//
//  Created by ZYVincent on 15-1-9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCLoadingStatusHUD.h"

@interface GJGCLoadingStatusHUD ()

@property (nonatomic,strong)UIImageView *backgroundImgView;

@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong)GJCFCoreTextContentView *statusLabel;

@property (nonatomic,copy)NSString *statusText;

@property (nonatomic,weak)UIView *layOnView;

@property (nonatomic,assign)CGFloat contentInnerMargin;

@property (nonatomic,strong)UIView *whiteBoardView;

@end

@implementation GJGCLoadingStatusHUD

- (instancetype)initWithView:(UIView *)aView
{
    if (self = [super init]) {
        
        self.layOnView = aView;
        
        self.backgroundColor = [UIColor clearColor];
        self.gjcf_size = aView.gjcf_size;
        
        [self initSubViews];
        
        self.contentInnerMargin = 13.f;
        
        self.indicatorView.gjcf_left = self.contentInnerMargin;
        self.indicatorView.gjcf_top = self.contentInnerMargin;
        self.indicatorView.gjcf_size = CGSizeMake(30, 30);
        
        self.statusLabel.gjcf_left = self.indicatorView.gjcf_right + self.contentInnerMargin;
        
        self.alpha = 0.f;
    }
    return self;
}

- (void)initSubViews
{
    self.whiteBoardView = [[UIView alloc]initWithFrame:self.layOnView.frame];
    self.whiteBoardView.alpha = 0.05;
    self.whiteBoardView.backgroundColor = [UIColor whiteColor];
    self.whiteBoardView.userInteractionEnabled = NO;
    [self addSubview:self.whiteBoardView];
    
    self.backgroundImgView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backgroundImgView.backgroundColor = [UIColor blackColor];
    self.backgroundImgView.alpha = 0.8;
    self.backgroundImgView.layer.cornerRadius = 8.f;
    self.backgroundImgView.layer.masksToBounds = YES;
    [self addSubview:self.backgroundImgView];
    
    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.backgroundImgView addSubview:self.indicatorView];
    
    self.statusLabel = [[GJCFCoreTextContentView alloc]init];
    [self.backgroundImgView addSubview:self.statusLabel];
}

- (NSAttributedString *)statusText:(NSString *)text
{
    if (GJCFStringIsNull(text)) {
        return nil;
    }
    
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [UIFont boldSystemFontOfSize:16];
    stringStyle.foregroundColor = [UIColor whiteColor];
    
    return [[NSAttributedString alloc]initWithString:text attributes:[stringStyle attributedDictionary]];
}

- (void)showWithStatusText:(NSString *)status
{
    if (![self.layOnView.subviews containsObject:self]) {
        [self.layOnView addSubview:self];
    }
    
    if ([self.statusText isEqualToString:status]) {
        
        [self showAction];
        
        return;
    }
    
    if (self.statusText) {
        self.statusText = nil;
    }
    self.statusText = [status copy];
    
    /* 重新设置 */
    NSAttributedString *contentAttributedString = [self statusText:status];
    CGFloat baseWidth = GJCFSystemScreenWidth * 3/5 - 3*self.contentInnerMargin - 30;
    CGSize textSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:contentAttributedString forBaseContentSize:CGSizeMake(baseWidth, 40)];
    self.statusLabel.gjcf_size = textSize;
    self.statusLabel.contentAttributedString = contentAttributedString;
    
    self.backgroundImgView.gjcf_width = 3*self.contentInnerMargin + 30 + textSize.width;
    self.backgroundImgView.gjcf_height = textSize.height + 2*15;
    self.statusLabel.gjcf_left = self.indicatorView.gjcf_right + self.contentInnerMargin;
    self.statusLabel.gjcf_centerY = self.backgroundImgView.gjcf_height/2;
    self.indicatorView.gjcf_centerY = self.backgroundImgView.gjcf_height/2;
    self.backgroundImgView.gjcf_centerX = self.gjcf_width / 2;
    self.backgroundImgView.gjcf_centerY = (self.gjcf_height - GJCFSystemNavigationBarHeight) / 2;
    
    [self showAction];
}

- (void)dismiss
{
    [self hideAction];
}

- (void)showAction
{
    self.alpha = 0;

    [self.indicatorView startAnimating];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 1;
        
        [self.layOnView bringSubviewToFront:self];
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)hideAction
{
    [self.indicatorView stopAnimating];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 0;
        
        [self.layOnView sendSubviewToBack:self];
        
    } completion:^(BOOL finished) {
        

    }];
}


@end
