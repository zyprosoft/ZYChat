//
//  GJCFImageBrowserScrollView.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCUImageBrowserScrollView.h"
#import "GJCUImageBrowserConstans.h"
#import "GJCUImageBrowserModel.h"
#import "GJCFUitils.h"
#import "UIView+GJCFViewFrameUitil.h"

@interface GJCUImageBrowserScrollView()<UIScrollViewDelegate>

@property (nonatomic,assign)CGSize imageSize;

@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;

@end

@implementation GJCUImageBrowserScrollView
- (id)init
{
    if (self = [super init]) {
        
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom                    = YES;
        self.decelerationRate               = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        
        /* 观察下载任务 */
        [self observeDownloadTask];
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
        
        /* 观察下载任务 */
        [self observeDownloadTask];
        
    }
    return self;
}

- (void)dealloc
{
    [GJCFNotificationCenter removeObserver:self];
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
    if ([self.dataSource respondsToSelector:@selector(imageModelAtIndex:)])
    {
        // 获取Asset
        GJCUImageBrowserModel *imageModel = [self.dataSource imageModelAtIndex:index];
        NSLog(@"GJCFImageBrowserScrollView image file path:%@",imageModel.filePath);
        
        UIImage *image = nil;
        self.contentImageView.image = nil;
        
        /* 支持预览ALAsset对象 */
        if (imageModel.isPreviewAsset) {
            if (imageModel.contentAsset) {
                image = [UIImage imageWithCGImage:[[imageModel.contentAsset defaultRepresentation] fullScreenImage]];
            }
            if (imageModel.gjcfAsset) {
                image = imageModel.gjcfAsset.fullScreenImage;
            }
        }else{
            if (imageModel.filePath) {
                image = GJCFQuickImageByFilePath(imageModel.filePath);
            }
        }
        
        
        // 恢复默认的缩放
        self.zoomScale = 1.0;
        
        // 重新设置图片
        if (!self.contentImageView) {
            
            if (imageModel.thumbImage) {
                self.contentImageView = [[UIImageView alloc]initWithImage:imageModel.thumbImage];
            }else{
                self.contentImageView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,self.gjcf_width,self.gjcf_height}];
            }
            
        }
        if (!self.indicatorView) {
            self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            self.indicatorView.center = self.center;
            self.indicatorView.hidden = YES;
            [self addSubview:self.indicatorView];
        }
        if (image) {
            self.contentImageView.image = image;
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
        }else{
            self.contentImageView.image = imageModel.thumbImage;
        }
        [self autoAdjustContentImageView];

        self.contentImageView.userInteractionEnabled = YES;
        
        self.contentImageView.isAccessibilityElement   = YES;
        self.contentImageView.accessibilityTraits      = UIAccessibilityTraitImage;
        self.contentImageView.tag                      = 1;
        
        //添加点击事件
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView)];
        [self.contentImageView addGestureRecognizer:tapR];
        
        [self addSubview:self.contentImageView];
        
        [self configureWithContentModel];
        
    }
}

#pragma mark - 观察下载任务完成情况
- (void)observeDownloadTask
{
    [GJCFNotificationCenter addObserver:self selector:@selector(observeDownloadFinished:) name:GJCUImageBrowserViewControllerDidFinishDownloadTaskNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeDownloadFaild:) name:GJCUImageBrowserViewControllerDidFaildDownloadTaskNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeBeginDownload:) name:GJCUImageBrowserViewControllerDidBeginDownloadTaskNoti object:nil];
}

- (void)observeBeginDownload:(NSNotification *)noti
{
    NSInteger index = [noti.object intValue];
    if (index == self.index) {
        
        GJCFAsyncMainQueue(^{
            
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
            
        });
        
    }
}

- (void)observeDownloadFinished:(NSNotification *)noti
{
    NSLog(@"GJCFImageBrowserScrollView recieve image finish download :%@",noti.object);
    NSInteger index = [noti.object intValue];
    if (index == self.index) {
        
        GJCFAsyncMainQueue(^{
            
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            
            GJCUImageBrowserModel *imageModel = [self.dataSource imageModelAtIndex:self.index];
            self.contentImageView.image = GJCFQuickImageByFilePath(imageModel.filePath);
            [self autoAdjustContentImageView];
            [self configureWithContentModel];
            [self setNeedsLayout];
            
        });
        
    }
}

- (void)observeDownloadFaild:(NSNotification *)noti
{
    NSInteger index = [noti.object intValue];
    if (index == self.index) {
        
        GJCFAsyncMainQueue(^{
            
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            
        });
    }
}

- (void)autoAdjustContentImageView
{
    if (self.contentImageView.image) {
        
        CGFloat widthScale = 1.0;
        CGFloat heightScale = 1.0;
        
        CGSize contentImageSize = self.contentImageView.image.size;
        NSLog(@"contentImageSize:%@",NSStringFromCGSize(contentImageSize));
        
        if (contentImageSize.width > GJCFSystemScreenWidth) {
            widthScale = GJCFSystemScreenWidth/self.contentImageView.image.size.width;
        }
        
        if (contentImageSize.height > GJCFSystemScreenHeight) {
            heightScale = GJCFSystemScreenHeight/self.contentImageView.image.size.height;
        }
        
        CGFloat scaleSize = MIN(widthScale, heightScale);
        CGFloat contentImgViewWidth = contentImageSize.width * scaleSize;
        CGFloat contentImgViewHeight = contentImageSize.height * scaleSize;
        
        NSLog(@"contentImagWidth:%f contentImageHeight:%f",contentImgViewWidth,contentImgViewHeight);
        
        self.contentImageView.gjcf_width = contentImgViewWidth;
        self.contentImageView.gjcf_height = contentImgViewHeight;
        
        [self setNeedsLayout];
        
        NSLog(@"cotnenImgView frame:%@",NSStringFromCGRect(self.contentImageView.frame));
    }
}

- (void)configureWithContentModel
{
    GJCUImageBrowserModel *imageModel = [self.dataSource imageModelAtIndex:self.index];
    
    NSLog(@"GJCFImageBrowserScrollView imageSize:%@",NSStringFromCGSize(imageModel.imageSize));
    if (CGSizeEqualToSize(imageModel.imageSize, CGSizeZero)) {
        self.imageSize = self.gjcf_size;
    }else{
        self.imageSize = imageModel.imageSize;
    }
    
    self.contentSize = self.imageSize;
    
    [self fitZoomScaleSize];
}

- (void)fitZoomScaleSize
{
    CGSize boundsSize = self.bounds.size;
    if (self.contentImageView.image) {
        boundsSize = self.contentImageView.image.size;
    }
    
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
    GJCFNotificationPost(GJCUImageBrowserItemViewControllerDidTapNoti);
}

#pragma mark - 需要放大的视图
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentImageView;
}


@end
