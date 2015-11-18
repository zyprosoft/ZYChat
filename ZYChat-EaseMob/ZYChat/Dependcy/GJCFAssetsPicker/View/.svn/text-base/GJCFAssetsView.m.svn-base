//
//  GJAssetsView.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import "GJCFAssetsView.h"

@interface GJCFAssetsView ()

@property (nonatomic,strong)UIImageView *containImageView;



@end

@implementation GJCFAssetsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.containImageView = [[UIImageView alloc]init];
        self.containImageView.userInteractionEnabled = NO;
        [self addSubview:self.containImageView];
        
        self.overlayView = [GJCFAssetsPickerOverlayView defaultOverlayView];
        [self addSubview:self.overlayView];
        [self.overlayView switchNormalState];//默认状态

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.containImageView) {
        
        self.containImageView.frame = (CGRect){0,0,self.frame.size.width,self.frame.size.height};
        
    }
    
    if (self.overlayView) {
        
        self.overlayView.frame = self.containImageView.frame;
    }
    
}

- (void)setOverlayView:(GJCFAssetsPickerOverlayView *)aOverlayView
{
    if (![aOverlayView isKindOfClass:[GJCFAssetsPickerOverlayView class]]) {
        return;
    }
    if (!aOverlayView) {
        return;
    }
    [_overlayView removeFromSuperview];
    _overlayView = nil;
    _overlayView = aOverlayView;
    _overlayView.tag = self.tag;
    if (![self.subviews containsObject:_overlayView]) {
        [self addSubview:_overlayView];
    }
    [_overlayView switchNormalState];//默认状态
}

- (void)setAsset:(GJCFAsset *)asset
{
    if (!asset || ![asset isKindOfClass:[GJCFAsset class]]) {
        return;
    }
    
    if (self.containImageView) {
        
        UIImage *thumbImage = [UIImage imageWithCGImage:asset.containtAsset.thumbnail];
        self.containImageView.image = thumbImage;
    }
    
    if (self.overlayView) {
        
        self.overlayView.selected = asset.selected;
    }
    
    [self setNeedsLayout];
}


@end
