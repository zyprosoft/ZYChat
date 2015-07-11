//
//  GJCFImageBrowserNavigationViewController.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCUImageBrowserNavigationViewController.h"
#import "GJCFUitils.h"

@interface GJCUImageBrowserNavigationViewController ()

@property (nonatomic,strong)GJCUImageBrowserViewController *imageBrowserController;

@property (nonatomic,strong)UIView *customBottomToolBar;

@property (nonatomic,strong)UIView *customRightNavigationBarItem;

@end

@implementation GJCUImageBrowserNavigationViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initBrowserDefault];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self initBrowserDefault];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        
        [self initBrowserDefault];
    }
    return self;
}


/**
 *  使用Model初始化
 *
 *  @param imageModels
 *
 *  @return
 */
- (instancetype)initWithImageModels:(NSArray*)imageModels
{
    if (self = [super init]) {
        
        [self initBrowserViewControllerWithImageModels:imageModels];
        
    }
    return self;
}

/**
 *  使用图片地址数组初始化
 *
 *  @param imageUrls
 *
 *  @return
 */
- (instancetype)initWithImageUrls:(NSArray *)imageUrls
{
    if (self = [super init]) {
        
        [self initBrowserViewControllerWithImageUrls:imageUrls];
        
    }
    return self;
}

/**
 *  使用本地图片路径组初始化
 *
 *  @param imageFilePaths
 *
 *  @return
 */
- (instancetype)initWithLocalImageFilePaths:(NSArray *)imageFilePaths
{
    if (self = [super init]) {
        
        [self initBrowserViewControllerWithImageLocalPaths:imageFilePaths];
        
    }
    return self;
}

/**
 *  预览ALAssets对象组
 *
 *  @param assetsArray
 *
 *  @return
 */
- (instancetype)initWithImageAssets:(NSArray *)assetsArray
{
    if (self = [super init]) {
        
        [self initBrowserViewControllerWithALAssets:assetsArray];
        
    }
    return self;
}

/**
 *  预览GJCFAssets对象组
 *
 *  @param assetsArray
 *
 *  @return
 */
- (instancetype)initWithGJCFAssets:(NSArray *)assetsArray
{
    if (self = [super init]) {
        
        [self initBrowserViewControllerWithGJCFAssets:assetsArray];
        
    }
    return self;
}

- (void)removeImageAtIndex:(NSInteger)index
{
    [self.imageBrowserController removeImageAtIndex:index];
}


- (void)initBrowserDefault
{
    self.imageBrowserController = [[GJCUImageBrowserViewController alloc]init];
    self.imageBrowserController.isPresentModelState = YES;
    [self setViewControllers:@[self.imageBrowserController] animated:NO];

}

- (void)initBrowserViewControllerWithImageModels:(NSArray *)imageModes
{
    self.imageBrowserController = [[GJCUImageBrowserViewController alloc]initWithImageModels:imageModes];
    self.imageBrowserController.isPresentModelState = YES;
    [self setViewControllers:@[self.imageBrowserController] animated:NO];
}

- (void)initBrowserViewControllerWithImageUrls:(NSArray *)imageUrls
{
    self.imageBrowserController = [[GJCUImageBrowserViewController alloc]initWithImageUrls:imageUrls];
    self.imageBrowserController.isPresentModelState = YES;
    [self setViewControllers:@[self.imageBrowserController] animated:NO];
}

- (void)initBrowserViewControllerWithImageLocalPaths:(NSArray *)localPaths
{
    self.imageBrowserController = [[GJCUImageBrowserViewController alloc]initWithLocalImageFilePaths:localPaths];
    self.imageBrowserController.isPresentModelState = YES;
    [self setViewControllers:@[self.imageBrowserController] animated:NO];
}

- (void)initBrowserViewControllerWithALAssets:(NSArray *)assetsArray
{
    self.imageBrowserController = [[GJCUImageBrowserViewController alloc]initWithImageAssets:assetsArray];
    self.imageBrowserController.isPresentModelState = YES;
    [self setViewControllers:@[self.imageBrowserController] animated:NO];
}

- (void)initBrowserViewControllerWithGJCFAssets:(NSArray *)assetsArray
{
    self.imageBrowserController = [[GJCUImageBrowserViewController alloc]initWithGJCFAssets:assetsArray];
    self.imageBrowserController.isPresentModelState = YES;
    [self setViewControllers:@[self.imageBrowserController] animated:NO];
}

- (NSInteger)pageIndex
{
    return self.imageBrowserController.pageIndex;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    if (self.imageBrowserController.pageIndex == pageIndex) {
        return;
    }
    self.imageBrowserController.pageIndex = pageIndex;
}

- (void)setBrowserDataSource:(id<GJCUImageBrowserViewControllerDataSource>)browserDataSource
{
    if (_browserDataSource == browserDataSource) {
        return;
    }
    _browserDataSource = nil;
    _browserDataSource = browserDataSource;
    self.imageBrowserController.browserDataSource = _browserDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCustomViews
{
    NSLog(@"GJCFBrowserDataSource :%@",self.browserDataSource);
    
    /* 默认返回 */
    self.navigationItem.leftBarButtonItem = [self rightCancelBarItem];

    if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowserShouldCustomBottomToolBar:)]) {
        self.customBottomToolBar = [self.browserDataSource imageBrowserShouldCustomBottomToolBar:self.imageBrowserController];
    }
    
    if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowserShouldCustomRightNavigationBarItem:)]) {
        self.customRightNavigationBarItem = [self.browserDataSource imageBrowserShouldCustomRightNavigationBarItem:self.imageBrowserController];
    }
    
    if (self.customRightNavigationBarItem) {
        
        UIBarButtonItem *customRightItem = [[UIBarButtonItem alloc]initWithCustomView:self.customRightNavigationBarItem];
        self.navigationItem.rightBarButtonItem = customRightItem;
        customRightItem = nil;
        
    }
    
    if (self.customBottomToolBar && ![self.view.subviews containsObject:self.customBottomToolBar]) {
        
        [self.view addSubview:self.customBottomToolBar];
        
    }
    
    if (self.browserDataSource && [self.browserDataSource respondsToSelector:@selector(imageBrowserShouldCustomNavigationBar:)]) {
        
        UIImage *customNavigationBarBack = [self.browserDataSource imageBrowserShouldCustomNavigationBar:self.imageBrowserController];
        
        [self.navigationBar setBackgroundImage:customNavigationBarBack forBarMetrics:UIBarMetricsDefault];
        
    }else{
        
        NSString *bunldePath = GJCFMainBundlePath(@"GJCUImageBrowserResourceBundle.bundle");
        NSString *bundleImagePath = GJCFBundlePath(bunldePath,@"GjImageBrowser_Navigation_bar_back.png");
        UIImage *navImage = GJCFQuickImageByFilePath(bundleImagePath);
        
        [self.navigationBar setBackgroundImage:GJCFImageStrecth(navImage, 3, 3) forBarMetrics:UIBarMetricsDefault];
        
    }
    
}


@end
