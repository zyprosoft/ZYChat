//
//  GJAssetsPickerViewController.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAssetsPickerViewController.h"
#import "GJCFAlbumsViewController.h"

#define kGJPhotoViewControllerCustomKey      @"kGJPhotoViewControllerCustomKey"
#define kGJAlbumsViewControllerCellCustomKey @"kGJAlbumsViewControllerCellCustomKey"
#define kGJAlbumsViewControllerCellCustomHeightKey @"kGJAlbumsViewControllerCellCustomHeightKey"

@interface GJCFAssetsPickerViewController ()<GJCFAlbumsViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)GJCFAssetsPickerStyle *customStyle;
@property (nonatomic,strong)GJCFAlbumsViewController *albumsViewController;
@property (nonatomic,strong)NSMutableDictionary *customClassDict;

@end

@implementation GJCFAssetsPickerViewController

#pragma mark - 生命周期

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.customClassDict = [[NSMutableDictionary alloc]init];
        
        [self initAlbums];
    }
    return self;
}
- (id)init
{
    if (self = [super init]) {
        
        self.customClassDict = [[NSMutableDictionary alloc]init];
        
        [self initAlbums];

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //是否有自定义的UI
    if (!self.customStyle) {
        
        if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewShouldUseCustomStyle:)]) {
            self.customStyle = [self.pickerDelegate pickerViewShouldUseCustomStyle:self];
        }else{
            self.customStyle = [GJCFAssetsPickerStyle defaultStyle];
        }
        
    }
    
    self.albumsViewController.mutilSelectLimitCount = self.mutilSelectLimitCount;

    //观察必要通知
    [self observeAssetsPickerNotis];
}

#pragma mark - 初始化相册
- (void)initAlbums
{
    self.albumsViewController = [[GJCFAlbumsViewController alloc]init];
    self.albumsViewController.shouldInitSelectedStateAssetArray = self.shouldInitSelectedStateAssetArray;
    self.albumsViewController.delegate = self;
    
    /* 是否有自定义UI */
    if ([self.customClassDict objectForKey:kGJPhotoViewControllerCustomKey]) {
        [self.albumsViewController registPhotoViewControllerClass:NSClassFromString([self.customClassDict objectForKey:kGJPhotoViewControllerCustomKey])];
    }
    if ([self.customClassDict objectForKey:kGJAlbumsViewControllerCellCustomKey]) {
        NSDictionary *customCellDict = [self.customClassDict objectForKey:kGJAlbumsViewControllerCellCustomKey];
        [self.albumsViewController registAlbumsCustomCellClass:NSClassFromString([customCellDict objectForKey:kGJAlbumsViewControllerCellCustomKey]) withCellHeight:[[customCellDict objectForKey:kGJAlbumsViewControllerCellCustomHeightKey] floatValue]];
    }
    
    [self setViewControllers:@[self.albumsViewController] animated:NO];
}

#pragma mark - GJCFAssetsPickerAlbumsViewController delegate
- (GJCFAssetsPickerStyle*)albumsViewControllerShouldUseCustomStyle:(GJCFAlbumsViewController *)albumsViewController
{
    return self.customStyle;
}

#pragma mark - NSNotification 通知处理

//观察所有必要的通知
- (void)observeAssetsPickerNotis
{
    /*
     * 观察GJPhotosViewController多选时候已选择照片数量的变化
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observePhotoControllerMutilSelectLimitCountChange:) name:kGJAssetsPickerPhotoControllerDidReachLimitCountNoti object:nil];
    
    /*
     * 观察发生错误的消息
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observeComeAcrossAnErrorNoti:) name:kGJAssetsPickerComeAcrossAnErrorNoti object:nil];
    
    /*
     * 观察图片预览消息
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observePhotoControlleRequirePreviewButNoSelectedImages:) name:kGJAssetsPickerRequirePreviewButNoSelectPhotoTipNoti object:nil];
    
    /*
     * 观察图片选择退出消息
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observePickerControllerNeedCancel:) name:kGJAssetsPickerNeedCancelNoti object:nil];
    
    /*
     * 观察图片选择已经完成的消息
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observeChooseMediaDidFinishNoti:) name:kGJAssetsPickerDidFinishChooseMediaNoti object:nil];
}

/*
 * 处理当图片选择达到限制数量的消息
 */
- (void)observePhotoControllerMutilSelectLimitCountChange:(NSNotification*)noti
{
    NSNumber *limitCount = (NSNumber*)noti.object;
    
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewController:didReachLimitSelectedCount:)]) {
        [self.pickerDelegate pickerViewController:self didReachLimitSelectedCount:[limitCount intValue]];
    }
}

/*
 * 图片想要预览却没有选中图片
 */
- (void)observePhotoControlleRequirePreviewButNoSelectedImages:(NSNotification*)noti
{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewControllerRequirePreviewButNoSelectedImage:)]) {
        [self.pickerDelegate pickerViewControllerRequirePreviewButNoSelectedImage:self];
    }
}

/*
 * 图片选择已经完成了的消息
 */
- (void)observeChooseMediaDidFinishNoti:(NSNotification*)noti
{
    NSArray *resultArray = (NSArray*)noti.object;
    
    if (resultArray.count > 0) {
        
        if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewController:didFinishChooseMedia:)]) {
            [self.pickerDelegate pickerViewController:self didFinishChooseMedia:resultArray];
        }
        
    }else{
        
        if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewController:didFaildWithErrorMsg:withErrorType:)]) {
            [self.pickerDelegate pickerViewController:self didFaildWithErrorMsg:@"至少选择一张照片" withErrorType:GJAssetsPickerErrorTypePhotoLibarayChooseZeroCountPhoto];
        }
    }

}

/*
 * 发生了错误的消息
 */
- (void)observeComeAcrossAnErrorNoti:(NSNotification*)noti
{
    NSError *error = (NSError*)noti.object;
        
    //如果是本身的错误
    NSString *errorDomain = [error domain];
    if ([errorDomain isEqualToString:kGJAssetsPickerErrorDomain]) {
        
        GJAssetsPickerErrorType errorType = error.code;
        
        switch (errorType) {
            case GJAssetsPickerErrorTypePhotoLibarayNotAuthorize:
            {
                if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewControllerPhotoLibraryAccessDidNotAuthorized:)]) {
                    
                    [self.pickerDelegate pickerViewControllerPhotoLibraryAccessDidNotAuthorized:self];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

/*
 * 图片选择需要退出
 */
- (void)observePickerControllerNeedCancel:(NSNotification*)noti
{
    [self dismissPickerViewController];
}

#pragma mark - 对外接口

- (void)dismissPickerViewController
{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewControllerWillCancel:)]) {
        [self.pickerDelegate pickerViewControllerWillCancel:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 公开自定义UI接口

- (void)registAlbumsCustomCellClass:(Class)aAlbumsCustomCellClass
{
    if (!aAlbumsCustomCellClass) {
        return;
    }
    [self registAlbumsCustomCellClass:aAlbumsCustomCellClass withCellHeight:44.f];
}

- (void)registAlbumsCustomCellClass:(Class)aAlbumsCustomCellClass withCellHeight:(CGFloat)cellHeight
{
    NSDictionary *customCellDict = @{kGJAlbumsViewControllerCellCustomKey:NSStringFromClass(aAlbumsCustomCellClass),kGJAlbumsViewControllerCellCustomHeightKey:@(cellHeight)};
    [self.customClassDict setObject:customCellDict forKey:kGJAlbumsViewControllerCellCustomKey];
}

- (void)registPhotoViewControllerClass:(Class)aPhotoViewControllerClass
{
    if (!aPhotoViewControllerClass) {
        return;
    }
    [self.customClassDict setObject:NSStringFromClass(aPhotoViewControllerClass) forKey:kGJPhotoViewControllerCustomKey];
}

- (void)setCustomStyle:(GJCFAssetsPickerStyle *)aCustomStyle
{
    if (!aCustomStyle) {
        return;
    }
    
    if (_customStyle == aCustomStyle) {
        return;
    }
    
    _customStyle = aCustomStyle;
}

- (void)setCustomStyleByKey:(NSString *)aExistCustomStyleKey
{
    if (!aExistCustomStyleKey) {
        return;
    }
    
    NSMutableDictionary *styles = [GJCFAssetsPickerStyle persistStyleDict];
    if (!styles) {
        return;
    }
    
    self.customStyle = [styles objectForKey:aExistCustomStyleKey];
}

@end