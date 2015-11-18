//
//  GJAssetsPreviewController.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import "GJCFAssetsPreviewController.h"
#import "GJCFAssetsPickerPreviewItemViewController.h"
#import "GJCFPhotosViewController.h"
#import "GJCFAssetsPickerConstans.h"
#import "GJCFUitils.h"

@interface GJCFAssetsPreviewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,GJCFAssetsPickerPreviewItemViewControllerDataSource>

@property (nonatomic,strong)UIButton *finishDoneBtn;

@property (nonatomic,strong)UIButton *stateChangeBtn;

@end

@implementation GJCFAssetsPreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithAssets:(NSArray *)sAsstes
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@30.f}];

    if (self) {
        
        self.assets = [[NSMutableArray alloc]initWithArray:sAsstes];
        self.dataSource             = self;
        self.delegate               = self;
        self.view.backgroundColor   = [UIColor whiteColor];
        if ([GJCFAssetsPickerConstans isIOS7]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return self;
}

- (void)dealloc
{
    [GJCFNotificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设定UI
    [self setupStyle];
    
    //观察通知
    [self addObserverForItemViewController];
}

#pragma mark - 设置外观
// 外观
- (GJCFAssetsPickerStyle *)defaultStyle
{
    GJCFAssetsPickerStyle *defaultStyle = nil;
    if (self.previewDelegate && [self.previewDelegate respondsToSelector:@selector(previewControllerShouldCustomStyle:)]) {
        defaultStyle = [self.previewDelegate previewControllerShouldCustomStyle:self];
    }else{
        defaultStyle = [GJCFAssetsPickerStyle defaultStyle];
    }
    return defaultStyle;
}

//设置
- (void)setupStyle
{
    GJCFAssetsPickerStyle *defaultStyle = [self defaultStyle];
    
    //navigationBar 背景
    if (defaultStyle.sysPreviewNavigationBarDes.backgroundColor) {
        UIImage *colorImage = [GJCFAssetsPickerConstans imageForColor:defaultStyle.sysPhotoNavigationBarDes.backgroundColor withSize:CGSizeMake(self.view.frame.size.width,64)];
        [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    }
    if (defaultStyle.sysPreviewNavigationBarDes.backgroundImage) {
        [self.navigationController.navigationBar setBackgroundImage:defaultStyle.sysPreviewNavigationBarDes.backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setCommonStyleDescription:defaultStyle.sysPhotoNavigationBarDes];
    if (self.importantTitle) {
        titleLabel.text = self.importantTitle;
    }
    self.navigationItem.titleView = titleLabel;
    titleLabel = nil;
    
    //返回上一级
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setCommonStyleDescription:defaultStyle.sysBackBtnDes];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:[self defaultStyle].sysPhotoNavigationBarDes.title forState:UIControlStateNormal];
    
    //设置返回Item
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    //右上角状态改变图标
    self.stateChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stateChangeBtn setCommonStyleDescription:defaultStyle.sysPreviewChangeSelectStateBtnDes];
    [self.stateChangeBtn addTarget:self action:@selector(changeCurrentAssetState:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.stateChangeBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    rightBarItem = nil;
    
    //底部的工具栏
    self.customBottomToolBar = [[UIImageView alloc]init];
    self.customBottomToolBar.userInteractionEnabled = YES;
    self.customBottomToolBar.frame = CGRectOffset(self.view.frame,0,self.view.frame.size.height - defaultStyle.sysPreviewBottomToolBarDes.frameSize.height-64);
    self.customBottomToolBar.backgroundColor = defaultStyle.sysPreviewBottomToolBarDes.backgroundColor;
    self.customBottomToolBar.image = defaultStyle.sysPreviewBottomToolBarDes.backgroundImage;
    [self.view addSubview:self.customBottomToolBar];
    
    //设置完成按钮
    self.finishDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishDoneBtn setCommonStyleDescription:defaultStyle.sysFinishDoneBtDes];
    [self.customBottomToolBar addSubview:self.finishDoneBtn];
    CGRect oldFrame = self.finishDoneBtn.frame;
    oldFrame.origin.x = GJCFSystemScreenWidth - self.finishDoneBtn.frame.size.width - 2.5;
    self.finishDoneBtn.frame = oldFrame;
    [self.finishDoneBtn addTarget:self action:@selector(finishSelectImage) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeCurrentAssetState:(UIButton*)sender
{
    NSInteger currentAssetsIndex = [self pageIndex];

    GJCFAsset *currentAsset = [self.assets objectAtIndex:currentAssetsIndex];
    
    /* 先判断是不是要变成选中状态，如果是从未选中变成选中状态，那么先判断当前了已经选中的数量 */
    if ( currentAsset.selected == NO && [self totalSelectedAssets].count == self.mutilSelectLimitCount && self.mutilSelectLimitCount > 0) {
        
        [GJCFAssetsPickerConstans postNoti:kGJAssetsPickerPhotoControllerDidReachLimitCountNoti withObject:[NSNumber numberWithInteger:self.mutilSelectLimitCount]];
        
        return;
    }
    
    sender.selected = !sender.selected;
    
    currentAsset.selected = !currentAsset.selected;
    
    [self.assets replaceObjectAtIndex:currentAssetsIndex withObject:currentAsset];
    
    if (self.previewDelegate && [self.previewDelegate respondsToSelector:@selector(previewController:didUpdateAssetSelectedState:)]) {
        [self.previewDelegate previewController:self didUpdateAssetSelectedState:[self.assets objectAtIndex:[self pageIndex]]];
    }
    
    [self updateFinishDoneBtnTitle];
    
}

#pragma mark - 计算已经选中的图片数量
- (NSArray *)totalSelectedAssets
{
    NSMutableArray *selectedArray = [NSMutableArray array];
    [self.assets enumerateObjectsUsingBlock:^(GJCFAsset *asset, NSUInteger idx, BOOL *stop) {
        
        if (asset.selected) {
            [selectedArray addObject:asset];
        }
        
    }];
    
    return selectedArray;
}

- (void)finishSelectImage
{
    /**
     *  当前选中照片数为0的时候，主动选中当前图片为结果
     */
    GJCFAssetsPickerStyle *defaultStyle = [self defaultStyle];
    if (defaultStyle.enableAutoChooseInDetail && [self totalSelectedAssets].count == 0) {
        [self changeCurrentAssetState:self.stateChangeBtn];
    }
    
    [GJCFAssetsPickerConstans postNoti:kGJAssetsPickerDidFinishChooseMediaNoti withObject:[self totalSelectedAssets]];
}

- (void)updateStateBtn
{
    NSInteger currentAssetsIndex = [self pageIndex];
    
    GJCFAsset *currentAsset = [self.assets objectAtIndex:currentAssetsIndex];
    
    self.stateChangeBtn.selected = currentAsset.selected;
    
    [self updateFinishDoneBtnTitle];
}

- (void)updateFinishDoneBtnTitle
{
    GJCFAssetsPickerStyle *defaultStyle = [self defaultStyle];
    NSString *newTitle = [NSString stringWithFormat:@"%@(%d)",defaultStyle.sysFinishDoneBtDes.normalStateTitle,[self totalSelectedAssets].count];
    
    [self.finishDoneBtn setTitle:newTitle forState:UIControlStateNormal];
}

#pragma mark - Page Index
- (NSInteger)pageIndex
{
    return [(GJCFAssetsPickerPreviewItemViewController *)self.viewControllers[0] pageIndex];
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    NSInteger count = self.assets.count;
    
    if (pageIndex >= 0 && pageIndex < count)
    {
        GJCFAssetsPickerPreviewItemViewController *page = [GJCFAssetsPickerPreviewItemViewController itemViewForPageIndex:pageIndex];
        page.dataSource = self;
        
        [self setViewControllers:@[page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
        
        [self setTitleIndex:pageIndex + 1];
        
        [self updateStateBtn];
    }
}


#pragma mark - 更新标题

- (void)setTitleIndex:(NSInteger)index
{
    NSInteger count = self.assets.count;
    self.title      = [NSString stringWithFormat:@"%d / %d", index, count];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setCommonStyleDescription:[self defaultStyle].sysPreviewNavigationBarDes];
    titleLabel.text = self.title;
    /* 如果设置了重要标题 */
    if (self.importantTitle) {
        titleLabel.text = self.importantTitle;
    }
    self.navigationItem.titleView = titleLabel;
    titleLabel = nil;
}


#pragma mark - UIPageViewController DataSource and Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((GJCFAssetsPickerPreviewItemViewController *)viewController).pageIndex;
    
    if (index > 0)
    {
        GJCFAssetsPickerPreviewItemViewController *page = [GJCFAssetsPickerPreviewItemViewController itemViewForPageIndex:(index - 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger count = self.assets.count;
    NSInteger index = ((GJCFAssetsPickerPreviewItemViewController *)viewController).pageIndex;
    
    if (index < count - 1)
    {
        GJCFAssetsPickerPreviewItemViewController *page = [GJCFAssetsPickerPreviewItemViewController itemViewForPageIndex:(index + 1)];
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
        GJCFAssetsPickerPreviewItemViewController *vc   = (GJCFAssetsPickerPreviewItemViewController *)pageViewController.viewControllers[0];
        NSInteger index                 = vc.pageIndex + 1;
        
        [self setTitleIndex:index];
        
        [self updateStateBtn];
    }
}

#pragma mark - GJAssetsPickerPreviewItemViewController dataSource
- (GJCFAsset *)assetAtIndex:(NSInteger)index
{
    return [self.assets objectAtIndex:index];
}

#pragma mark - 隐藏显示NavigationBar和底部的自定义工具栏

- (void)fadeNavigationBarAndBottomToolBar
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.view.backgroundColor = [UIColor blackColor];
        
        self.customBottomToolBar.alpha = 0;
        self.customBottomToolBar.hidden = YES;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showNavigationBarAndBottomToolBar
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.customBottomToolBar.alpha = 1;
        self.customBottomToolBar.hidden = NO;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 观察详情页面的点击通知
- (void)addObserverForItemViewController
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observeItemViewControllerDidTapNoti:) name:kGJAssetsPickerPreviewItemControllerDidTapNoti object:nil];
}
- (void)observeItemViewControllerDidTapNoti:(NSNotification*)noti
{
    if (self.customBottomToolBar.hidden == NO) {
        [self fadeNavigationBarAndBottomToolBar];
    }else{
        [self showNavigationBarAndBottomToolBar];
    }
}


@end
