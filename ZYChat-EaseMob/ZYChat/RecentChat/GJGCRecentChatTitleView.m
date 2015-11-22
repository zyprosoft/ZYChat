//
//  GJGCRecentChatTitleView.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/19.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCRecentChatTitleView.h"

@implementation GJGCRecentChatTitleView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [GJGCCommonFontColorStyle navigationBarTitleViewFont];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.indicatorView];
        
        self.gjcf_size = CGSizeMake(150, 34);
    }
    return self;
}

- (NSDictionary *)statusLabelDict
{
    return @{
             
             @(GJGCRecentChatConnectStateConnecting):@"连接中",
             
             @(GJGCRecentChatConnectStateFaild):@"消息(未连接)",

             @(GJGCRecentChatConnectStateSuccess):@"消息",

             };
}

- (void)setConnectState:(GJGCRecentChatConnectState)connectState
{
    _connectState = connectState;
    
    NSString *title = [self statusLabelDict][@(connectState)];
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    
    self.indicatorView.gjcf_size = (CGSize){self.titleLabel.gjcf_height,self.titleLabel.gjcf_height};
    self.indicatorView.gjcf_right = self.titleLabel.gjcf_left;
    self.titleLabel.gjcf_centerX = self.gjcf_width/2;
    self.titleLabel.gjcf_centerY = self.gjcf_height/2;
    self.indicatorView.gjcf_centerY = self.titleLabel.gjcf_centerY;
    
    if (connectState == GJGCRecentChatConnectStateConnecting) {
        
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
        
    }else{
        
        self.indicatorView.hidden = YES;
        [self.indicatorView stopAnimating];
    }
}


@end
