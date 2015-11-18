//
//  GJAssetsPickerScrollView.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import "GJCFAssetsPickerScrollView.h"
#import "GJCFAssetsPickerConstans.h"

@interface GJCFAssetsPickerScrollView()

@property (nonatomic,assign)CGSize imageSize;

@end

@implementation GJCFAssetsPickerScrollView

- (id)init
{
    if (self = [super init]) {
        
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom                    = YES;
        self.decelerationRate               = UIScrollViewDecelerationRateFast;
        self.delegate = self;


    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom                    = YES;
        self.decelerationRate               = UIScrollViewDecelerationRateFast;
        self.delegate = self;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 当图片缩小的时候，让图片在中间
    CGSize boundsSize       = self.bounds.size;
    CGRect frameToCenter    = self.contentImageView.frame;
    
    // 水平设置中间
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // 垂直设置中间
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.contentImageView.frame    = frameToCenter;
}


- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    [self displayImageAtIndex:index];
    
}

- (void)displayImageAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(assetAtIndex:)])
    {
        // 获取Asset
        GJCFAsset *asset = [self.dataSource assetAtIndex:index];
        
        UIImage *image = asset.fullScreenImage;
    
        // 恢复默认的缩放
        self.zoomScale = 1.0;
        
        // 重新设置图片
        if (!self.contentImageView) {
            self.contentImageView = [[UIImageView alloc]initWithImage:image];
        }
        self.contentImageView.image = image;
        self.contentImageView.userInteractionEnabled = YES;
        
        self.contentImageView.isAccessibilityElement   = YES;
        self.contentImageView.accessibilityTraits      = UIAccessibilityTraitImage;
        self.contentImageView.accessibilityLabel       = asset.accessibilityLabel;
        self.contentImageView.tag                      = 1;
        
        //添加点击事件
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView)];
        [self.contentImageView addGestureRecognizer:tapR];
        
        [self addSubview:self.contentImageView];
        
        [self configureWithContentAsset];
        
    }
}

- (void)configureWithContentAsset
{
    GJCFAsset *contentAsset = [self.dataSource assetAtIndex:self.index];
    
    self.imageSize = [contentAsset fullScreenImage].size;
    self.contentSize = self.imageSize;
    
    [self fitZoomScaleSize];
}

- (void)fitZoomScaleSize
{
    CGSize boundsSize = self.bounds.size;
    
    CGFloat xScale = boundsSize.width  / self.imageSize.width;    // 最佳缩放宽的倍数
    CGFloat yScale = boundsSize.height / self.imageSize.height;   // 最佳缩放高的倍数
    
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = 2.0 * minScale;

    self.minimumZoomScale = minScale;
    self.maximumZoomScale = maxScale;
    
    self.zoomScale      = self.minimumZoomScale;
}

//点击发送通知，让预览视图是否隐藏navigationBar和工具条
- (void)tapOnView
{
    [GJCFAssetsPickerConstans postNoti:kGJAssetsPickerPreviewItemControllerDidTapNoti];
}

#pragma mark - 需要放大的视图
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentImageView;
}

@end
