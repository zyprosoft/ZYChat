//
//  GJCURoundCornerButton.m
//  GJCoreUserInterface
//
//  Created by ZYVincent on 14-11-4.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import "GJCURoundCornerButton.h"
#import "GJCFCoreTextContentView.h"
#import "GJCFUitils.h"

@interface GJCURoundCornerButton ()

@property (nonatomic,copy)GJCURoundCornerButtonDidTapActionBlock tapBlock;

@end

@implementation GJCURoundCornerButton

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cornerBackView.frame = self.bounds;
    self.titleView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)initSubViews
{
    self.cornerBackView = [[GJCURoundCornerView alloc]init];
    self.cornerBackView.drawnBordersSides = GJCUDrawnBorderSidesNone;
    [self.cornerBackView setFillColor:[UIColor clearColor]];
    self.normalBackColor = [UIColor clearColor];
    [self addSubview:self.cornerBackView];
    
    self.titleView = [[GJCFCoreTextContentView alloc]init];
    self.titleView.gjcf_size = CGSizeMake(80, 20);
    self.titleView.contentBaseWidth = self.titleView.gjcf_width;
    self.titleView.contentBaseHeight = self.titleView.gjcf_height;
    self.titleView.userInteractionEnabled = NO;
    self.titleView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleView];
}

#pragma mark - touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.highlightBackColor) {
        
        [self.cornerBackView setFillColor:self.highlightBackColor];
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.cornerBackView setFillColor:self.normalBackColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.cornerBackView setFillColor:self.normalBackColor];
    
    if (self.tapBlock) {
        self.tapBlock(self);
    }
}

#pragma mark - 公开接口

- (void)configureButtonDidTapAction:(GJCURoundCornerButtonDidTapActionBlock)tapAction
{
    if (self.tapBlock) {
        self.tapBlock = nil;
    }
    self.tapBlock = tapAction;
}



@end
