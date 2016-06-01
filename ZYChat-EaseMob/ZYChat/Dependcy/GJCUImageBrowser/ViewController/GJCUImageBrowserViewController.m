//
//  GJCFImageBrowserViewController.m
//  GJCommonFoundation
//
//  Created by ZYVincent QQ:1003081775 on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCUImageBrowserViewController.h"
#import "GJCUImageBrowserItemViewController.h"
#import "GJCUImageBrowserConstans.h"
#import "GJCFUitils.h"
#import "GJCFFileDownloadManager.h"
#import "UIView+GJCFViewFrameUitil.h"
#import "GJCFCachePathManager.h"

#define GJCU_NOTIFICATION_TOAST_NAME @"GJGC_NOTIFICATION_TOAST_NAME"

@interface GJCUImageBrowserViewController ()<GJCUImageBrowserItemViewControllerDataSource,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,strong)UIView *customBottomToolBar;

@property (nonatomic,strong)UIView *customRightNavigationBarItem;

@end

@implementation GJCUImageBrowserViewController

- (instancetype)initWithImageModels:(NSArray *)imageModels
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@30.f}];
    
    if (self) {
        
        self.imageModelArray = [[NSMutableArray alloc]initWithArray:imageModels];
        self.dataSource             = self;
        self.delegate               = self;
        self.view.backgroundColor   = [UIColor blackColor];
        self.pageIndex = 0;
        if (GJCFSystemIsOver7) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        /* 初始化下载管理 */
        [self initImageDownloadConfig];
        [self addObserverForItemViewController];
    }
    return self;
}

- (void)dealloc
{
    if (self.customBottomToolBar) {
        [self.customBottomToolBar removeFromSuperview];
        self.customBottomToolBar = nil;
    }
    
    if (self.customRightNavigationBarItem) {
        [self.customRightNavigationBarItem removeFromSuperview];
        self.customRightNavigationBarItem = nil;
    }
    
    [[GJCFFileDownloadManager shareDownloadManager] clearTaskBlockForObserver:self];

    [GJCFNotificationCenter removeObserver:self];
}


- (instancetype)initWithImageUrls:(NSArray *)imageUrls
{
    NSMutableArray *imageModels = [NSMutableArray array];
    for (NSString *url in imageUrls) {
        
        GJCUImageBrowserModel *aImageModel = [[GJCUImageBrowserModel alloc]init];
        aImageModel.imageUrl = url;
        
        [imageModels addObject:aImageModel];
    }
    return [self initWithImageModels:imageModels];
}

- (instancetype)initWithLocalImageFilePaths:(NSArray *)imageFilePaths
{
    NSMutableArray *imageModels = [NSMutableArray array];
    for (NSString *cachePath in imageFilePaths) {
        
        GJCUImageBrowserModel *aImageModel = [[GJCUImageBrowserModel alloc]init];
        aImageModel.cachePath = cachePath;
        aImageModel.filePath = cachePath;
        
        [imageModels addObject:aImageModel];
    }
    return [self initWithImageModels:imageModels];
}

- (instancetype)initWithImageAssets:(NSArray *)assetsArray
{
    NSMutableArray *imageModels = [NSMutableArray array];
    for (ALAsset *asset in assetsArray) {
        
        GJCUImageBrowserModel *aImageModel = [[GJCUImageBrowserModel alloc]init];
        aImageModel.contentAsset = asset;
        aImageModel.isPreviewAsset = YES;
        
        [imageModels addObject:aImageModel];
    }
    return [self initWithImageModels:imageModels];
}

- (instancetype)initWithGJCFAssets:(NSArray *)assetsArray
{
    NSMutableArray *imageModels = [NSMutableArray array];
    for (GJCFAsset *asset in assetsArray) {
        
        GJCUImageBrowserModel *aImageModel = [[GJCUImageBrowserModel alloc]init];
        aImageModel.gjcfAsset = asset;
        aImageModel.isPreviewAsset = YES;
        
        [imageModels addObject:aImageModel];
    }
    return [self initWithImageModels:imageModels];
}

/**
 *  使用环信的图片消息体初始化
 *
 *  @param imageMessageBodys
 *
 *  @return
 */
- (instancetype)initWithEaseImageMessageBody:(NSArray *)imageMessageBodys
{
    NSMutableArray *imageModels = [NSMutableArray array];
    for (EMImageMessageBody *messageBody in imageMessageBodys) {
        
        GJCUImageBrowserModel *aImageModel = [[GJCUImageBrowserModel alloc]init];
        aImageModel.filePath = messageBody.localPath;
        if (!GJCFStringIsNull(messageBody.remotePath)) {
            aImageModel.imageUrl = messageBody.remotePath;
        }
        
        [imageModels addObject:aImageModel];
    }
    return [self initWithImageModels:imageModels];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* 设置自定义风格 */
    [self setupCustomViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowserWillCancel:)]) {
        [self.browserDataSource  imageBrowserWillCancel:self];
    }
}

- (void)setBrowserDataSource:(id<GJCUImageBrowserViewControllerDataSource>)browserDataSource
{
    if (_browserDataSource == browserDataSource) {
        return;
    }
    _browserDataSource = nil;
    _browserDataSource = browserDataSource;
    
    /* 设置自定义风格 */
    [self setupCustomViews];
}

#pragma mark - 设置自定义工具条

- (UIBarButtonItem *)rightCancelBarItem
{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 40, 20);
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    
    return rightBarItem;
}

- (UIBarButtonItem *)rightSavePhotoItem
{
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(self.view.frame.size.width - 44 - 10, 0, 20, 20);
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    NSString *bunldePath = GJCFMainBundlePath(@"GJCUImageBrowserResourceBundle.bundle");
    NSString *bundleImagePath = GJCFBundlePath(bunldePath,@"标题栏-icon-下载.png");
    UIImage *navImage = GJCFQuickImageByFilePath(bundleImagePath);
    
    [saveButton setBackgroundImage:navImage forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(savePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    
    return rightBarItem;
}

- (void)savePhotoAction
{
    UIImage *saveImage = [self currentDisplayImage];
    
    if (saveImage) {
        
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GJCU_NOTIFICATION_TOAST_NAME object:nil userInfo:@{@"message":@"图片保存失败"}];

    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GJCU_NOTIFICATION_TOAST_NAME object:nil userInfo:@{@"message":@"图片保存成功"}];

    }
}

- (void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCustomViews
{
    NSLog(@"GJCFBrowserDataSource :%@",self.browserDataSource);
    
    /* 默认返回 */
    if (!self.isPresentModelState) {
        
        self.navigationItem.leftBarButtonItem = [self rightCancelBarItem];
        
        if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowserShouldCustomBottomToolBar:)]) {
            self.customBottomToolBar = [self.browserDataSource imageBrowserShouldCustomBottomToolBar:self];
        }
        
        if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowserShouldCustomRightNavigationBarItem:)]) {
            self.customRightNavigationBarItem = [self.browserDataSource imageBrowserShouldCustomRightNavigationBarItem:self];
        }
        
        if (self.customRightNavigationBarItem) {
            
            UIBarButtonItem *customRightItem = [[UIBarButtonItem alloc]initWithCustomView:self.customRightNavigationBarItem];
            self.navigationItem.rightBarButtonItem = customRightItem;
            customRightItem = nil;
            
        }else{
            
            if (GJCFSystemIsOver7)//左边button的偏移量，从左移动13个像素
            {
                UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                negativeSeperator.width = 10;
                [self.navigationItem setRightBarButtonItems:@[[self rightSavePhotoItem],negativeSeperator]];
            }
            else
            {
                [self.navigationItem setRightBarButtonItem:[self rightSavePhotoItem]];
            }
        }
        
        if (self.customBottomToolBar && ![self.view.subviews containsObject:self.customBottomToolBar]) {
            
            [self.view addSubview:self.customBottomToolBar];
            
        }
        
        
        if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowserShouldCustomNavigationBar:)]) {
            
            UIImage *customNavigationBarBack = [self.browserDataSource imageBrowserShouldCustomNavigationBar:self];
            
            [self.navigationController.navigationBar setBackgroundImage:customNavigationBarBack forBarMetrics:UIBarMetricsDefault];
            
        }else{
            
            NSString *bunldePath = GJCFMainBundlePath(@"GJCUImageBrowserResourceBundle.bundle");
            NSString *bundleImagePath = GJCFBundlePath(bunldePath,@"GjImageBrowser_Navigation_bar_back.png");
            UIImage *navImage = GJCFQuickImageByFilePath(bundleImagePath);
            
            [self.navigationController.navigationBar setBackgroundImage:GJCFImageStrecth(navImage, 3, 3) forBarMetrics:UIBarMetricsDefault];
            
        }
    }
    
}

#pragma mark - Page Index
- (NSInteger)pageIndex
{
    return [(GJCUImageBrowserItemViewController *)self.viewControllers[0] pageIndex];
}

- (UIImage *)currentDisplayImage
{
    return [(GJCUImageBrowserItemViewController *)self.viewControllers[0] currentDisplayImage];
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    NSInteger count = self.imageModelArray.count;
    
    if (pageIndex >= 0 && pageIndex < count)
    {
        GJCUImageBrowserItemViewController *page = [GJCUImageBrowserItemViewController itemViewForPageIndex:pageIndex];
        page.dataSource = self;

        [self setViewControllers:@[page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
        [self imageShouldStartDownloadAtIndex:pageIndex];

        [self setTitleIndex:pageIndex + 1];
        
    }
}

#pragma mark - 更新标题

- (void)setTitleIndex:(NSInteger)index
{
    NSInteger count = self.imageModelArray.count;
    self.title      = [NSString stringWithFormat:@"%ld / %ld", (long)index, (long)count];
    
    NSLog(@"GJCFImageBrowserTitle :%@",self.title);
    
    if (self.navigationItem.titleView) {
        UILabel *titleLabel  = (UILabel *)self.navigationItem.titleView;
        titleLabel.text = self.title;
        return;
    }
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 0, 150, 35);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = self.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    titleLabel = nil;
}


#pragma mark - UIPageViewController DataSource and Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((GJCUImageBrowserItemViewController *)viewController).pageIndex;
    
    if (index > 0)
    {
        GJCUImageBrowserItemViewController *page = [GJCUImageBrowserItemViewController itemViewForPageIndex:(index - 1)];
        page.dataSource = self;

        return page;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger count = self.imageModelArray.count;
    NSInteger index = ((GJCUImageBrowserItemViewController *)viewController).pageIndex;
    
    if (index < count - 1)
    {
        GJCUImageBrowserItemViewController *page = [GJCUImageBrowserItemViewController itemViewForPageIndex:(index + 1)];
        page.dataSource = self;

        return page;
    }
    
    return nil;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        GJCUImageBrowserItemViewController *vc   = (GJCUImageBrowserItemViewController *)pageViewController.viewControllers[0];
        [self imageShouldStartDownloadAtIndex:vc.pageIndex];
        NSInteger index                 = vc.pageIndex + 1;

        [self setTitleIndex:index];
        
    }
}

#pragma mark - GJAssetsPickerPreviewItemViewController dataSource
- (GJCUImageBrowserModel*)imageModelAtIndex:(NSInteger)index
{
    return [self.imageModelArray objectAtIndex:index];
}

- (void)imageShouldStartDownloadAtIndex:(NSInteger)index
{
    GJCUImageBrowserModel *imageModel = [self.imageModelArray objectAtIndex:index];
    if (GJCFQuickImageByFilePath(imageModel.filePath) || imageModel.isPreviewAsset) {
        return;
    }
    imageModel.cachePath = [self cachePathForUrl:imageModel.imageUrl];
    imageModel.filePath = imageModel.cachePath;
    GJCFFileDownloadTask *downloadTask = [GJCFFileDownloadTask taskWithDownloadUrl:imageModel.imageUrl withCachePath:imageModel.cachePath withObserver:self getTaskIdentifer:nil];
    downloadTask.userInfo = @{@"index":@(index)};
    [[GJCFFileDownloadManager shareDownloadManager]addTask:downloadTask];
    GJCFNotificationPostObj(GJCUImageBrowserViewControllerDidBeginDownloadTaskNoti, @(index));
}

#pragma mark - 图片下载管理

- (NSString *)cacheDirectory
{
    NSString *cacheDir = [[GJCFCachePathManager shareManager]mainImageCacheDirectory];
    
    return cacheDir;
}

- (NSString *)cachePathForUrl:(NSString *)imageUrl
{
    NSString *fileName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [[self cacheDirectory]stringByAppendingPathComponent:fileName];
}

- (void)initImageDownloadConfig
{
    GJCFWeakSelf weakSelf = self;
    
    /* 完成下载 */
    [[GJCFFileDownloadManager shareDownloadManager]setDownloadCompletionBlock:^(GJCFFileDownloadTask *task, NSData *fileData, BOOL isFinishCache) {
        
        NSInteger imageIndex = [task.userInfo[@"index"]intValue];
        [weakSelf downloadCompletion:fileData cacheState:isFinishCache withIndex:imageIndex];
        
    } forObserver:self];
    
    /* 下载失败 */
    [[GJCFFileDownloadManager shareDownloadManager]setDownloadFaildBlock:^(GJCFFileDownloadTask *task, NSError *error) {
        
        NSInteger imageIndex = [task.userInfo[@"index"]intValue];

        [weakSelf downloadFaild:error withIndex:imageIndex];
        
    } forObserver:self];
    
    /* 下载进度 */
    [[GJCFFileDownloadManager shareDownloadManager]setDownloadProgressBlock:^(GJCFFileDownloadTask *task, CGFloat progress) {
        
        [weakSelf downloadProgress:progress];
        
    } forObserver:self];
    
}

- (void)downloadCompletion:(NSData *)fileData cacheState:(BOOL)finish withIndex:(NSInteger)index
{
    GJCUImageBrowserModel *imageModel = [self.imageModelArray objectAtIndex:index];
    
    UIImage *image = [UIImage imageWithData:fileData];
    imageModel.imageSize = image.size;
    
    if (finish) {
        GJCFNotificationPostObj(GJCUImageBrowserViewControllerDidFinishDownloadTaskNoti, @(index));
    }else{
        GJCFNotificationPostObj(GJCUImageBrowserViewControllerDidFaildDownloadTaskNoti, @(index));
    }
}

- (void)downloadFaild:(NSError *)error withIndex:(NSInteger)index
{
    GJCFNotificationPostObj(GJCUImageBrowserViewControllerDidFaildDownloadTaskNoti, @(index));
}

- (void)downloadProgress:(CGFloat)progress
{
    
}

#pragma mark - 隐藏显示NavigationBar和底部的自定义工具栏


- (void)fadeNavigationBarAndBottomToolBar
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.view.backgroundColor = [UIColor blackColor];
        

        if (self.customBottomToolBar) {
            self.customBottomToolBar.alpha = 0;
            self.customBottomToolBar.hidden = YES;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showNavigationBarAndBottomToolBar
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.view.backgroundColor = [UIColor blackColor];
        
        if (self.customBottomToolBar) {
            self.customBottomToolBar.alpha = 1;
            self.customBottomToolBar.hidden = NO;
        }

    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 观察详情页面的点击通知
- (void)addObserverForItemViewController
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observeItemViewControllerDidTapNoti:) name:GJCUImageBrowserItemViewControllerDidTapNoti object:nil];
}
- (void)observeItemViewControllerDidTapNoti:(NSNotification*)noti
{
    if (self.navigationController.navigationBar.hidden == NO) {
        [self fadeNavigationBarAndBottomToolBar];
    }else{
        [self showNavigationBarAndBottomToolBar];
    }
}

#pragma mark - 公开接口

- (void)removeImageAtIndex:(NSInteger)index
{
    if (index < 0 || index > self.imageModelArray.count ) {
        return;
    }
    
    if (self.imageModelArray.count == 1) {
        
        if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowserShouldReturnWhileRemoveLastOnlyImage:)]) {
            [self.browserDataSource imageBrowserShouldReturnWhileRemoveLastOnlyImage:self];
        }
        
        if (self.isPresentModelState) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        return;
    }
    
    [self.imageModelArray removeObjectAtIndex:index];
    
    if (index == 0) {
        [self setPageIndex:0];
    }else{
        [self setPageIndex:index -1];
    }
    if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowser:didFinishRemoveAtIndex:)]) {
        [self.browserDataSource imageBrowser:self didFinishRemoveAtIndex:index];
    }
}


@end
