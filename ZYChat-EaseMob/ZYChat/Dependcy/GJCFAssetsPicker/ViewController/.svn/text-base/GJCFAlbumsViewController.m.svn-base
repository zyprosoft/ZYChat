//
//  GJAlbumsViewController.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import "GJCFAlbumsViewController.h"
#import "GJCFPhotosViewController.h"
#import "GJCFAlbums.h"
#import "GJCFAssetsPickerAlbumsCell.h"
#import "GJCFAssetsPickerConstans.h"
#import "GJCFUitils.h"

#define kGJPhotoViewControllerCustomKey      @"kGJPhotoViewControllerCustomKey"
#define kGJAlbumsViewControllerCellCustomKey @"kGJAlbumsViewControllerCellCustomKey"
#define kGJAlbumsViewControllerCellCustomHeightKey @"kGJAlbumsViewControllerCellCustomHeightKey"

@interface GJCFAlbumsViewController ()<UITableViewDataSource,UITableViewDelegate,GJCFPhotosViewControllerDelegate>

@property (nonatomic,strong)ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong)UITableView *groupTable;
@property (nonatomic,strong)NSMutableArray *assetsGroupArray;
@property (nonatomic,strong)NSMutableDictionary *customClassDict;

@end

@implementation GJCFAlbumsViewController

- (id)init
{
    if (self = [super init]) {
        
        self.photoControllerColums = 4;//默认4行
        self.mutilSelectLimitCount = 0;//默认不限制选中数量
        self.customClassDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.photoControllerColums = 4;//默认4行
        self.mutilSelectLimitCount = 0;//默认不限制选中数量
        self.customClassDict = [[NSMutableDictionary alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.groupTable = [[UITableView alloc]init];
    self.groupTable.frame = self.view.bounds;
    self.groupTable.delegate = self;
    self.groupTable.dataSource = self;
    if ([GJCFAssetsPickerConstans isIOS7]) {
        
        if ([self.groupTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.groupTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        /* 适配iOS7 */
        CGRect groupTableFrame = self.groupTable.frame;
        groupTableFrame.size.height = self.view.frame.size.height - 64;
        self.groupTable.frame = groupTableFrame;
        
    }else{
        
        /* 适配iOS7以下 */
        CGRect groupTableFrame = self.groupTable.frame;
        groupTableFrame.size.height = self.view.frame.size.height - 44;
        self.groupTable.frame = groupTableFrame;
        
    }
    
    [self.view addSubview:self.groupTable];
    
    self.assetsGroupArray = [[NSMutableArray alloc]init];
    
    /* 使用全局的library ,否则造成 ALAsset 对象 离开Library对象之后就失效了 */
    self.assetsLibrary = [GJCFAssetsPickerConstans shareAssetsLibrary];
    
    [self setupStyle];
    
    [self setupAlumbs];
}

- (void)setupAlumbs
{
    
    void (^GetAlumbsGroupSuccessBlock) (ALAssetsGroup *,BOOL *) = ^(ALAssetsGroup *group,BOOL *stop){
        
        if (group == nil) {
            return ;
        }
        
        NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
        NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
        
        GJCFAlbums *albums = [[GJCFAlbums alloc]initWithAssetsGroup:group];
        albums.filter = self.assetsFilter;
        
        if (([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] || [[sGroupPropertyName lowercaseString] isEqualToString:@"相机胶卷"]) && nType == ALAssetsGroupSavedPhotos) {
            
            [self.assetsGroupArray insertObject:albums atIndex:0];
        }
        else {
            [self.assetsGroupArray addObject:albums];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.groupTable reloadData];
        });
    };
    
    void (^GetAlumbsGroupFaildBlock) (NSError *) = ^(NSError *error){
        
        NSError *accessError = [NSError errorWithDomain:kGJAssetsPickerErrorDomain code:GJAssetsPickerErrorTypePhotoLibarayNotAuthorize userInfo:@{@"errorType":@(GJAssetsPickerErrorTypePhotoLibarayNotAuthorize)}];
        
        [GJCFAssetsPickerConstans postNoti:kGJAssetsPickerComeAcrossAnErrorNoti withObject:accessError];
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:GetAlumbsGroupSuccessBlock failureBlock:GetAlumbsGroupFaildBlock];
}

// 外观
- (GJCFAssetsPickerStyle *)defaultStyle
{
    GJCFAssetsPickerStyle *defaultStyle = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumsViewControllerShouldUseCustomStyle:)]) {
        defaultStyle = [self.delegate albumsViewControllerShouldUseCustomStyle:self];
    }else{
        defaultStyle = [GJCFAssetsPickerStyle defaultStyle];
    }
    return defaultStyle;
}

//设置
- (void)setupStyle
{
    GJCFAssetsPickerStyle *defaultStyle = [self defaultStyle];
    
    //图片选择列表没一行的照片数量
    self.photoControllerColums = defaultStyle.numberOfColums;
    
    //navigationBar 背景
    if (defaultStyle.sysAlbumsNavigationBarDes.backgroundColor) {
        UIImage *colorImage = [GJCFAssetsPickerConstans imageForColor:defaultStyle.sysPhotoNavigationBarDes.backgroundColor withSize:CGSizeMake(self.view.frame.size.width,64)];
        [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    }
    if (defaultStyle.sysPhotoNavigationBarDes.backgroundImage) {
        [self.navigationController.navigationBar setBackgroundImage:defaultStyle.sysPhotoNavigationBarDes.backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    if ([GJCFSystemAppBundleIdentifier isEqualToString:@"com.ganji.life"]) {
        /* 先写死让赶集生活发包 */
        [self setupTitleView:titleLabel];//赶集生活临时发版更改
    }else{
        [titleLabel setCommonStyleDescription:defaultStyle.sysAlbumsNavigationBarDes];
        self.title = defaultStyle.sysAlbumsNavigationBarDes.title;
    }
    self.navigationItem.titleView = titleLabel;
    titleLabel = nil;
        
    //取消返回
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([GJCFSystemAppBundleIdentifier isEqualToString:@"com.ganji.life"]) {
        /* 先写死让赶集生活发包 */
        [self setupCancelBtn:cancelBtn];//赶集生活临时发版更改
    }else{
        [cancelBtn setCommonStyleDescription:defaultStyle.sysCancelBtnDes];
    }
    //响应事件
    [cancelBtn addTarget:self action:@selector(dismissPickerViewController) forControlEvents:UIControlEventTouchUpInside];
    
    //设置Item
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    rightBarItem = nil;
}

//为了临时赶集生活发版 ////////////////////////////////////
- (void)setupTitleView:(UILabel *)aLabel
{
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.frame = CGRectMake(0, 0, 100, 35);
    
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.font = [UIFont boldSystemFontOfSize:16];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.text = @"选择相册";
    self.title = aLabel.text;
    
}
- (void)setupCancelBtn:(UIButton *)button
{
    button.frame = CGRectMake(0, 0, 40, 20);
    //标题
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    //标题状态颜色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}/////////////////////////////////////////////////////////////


- (void)dismissPickerViewController
{
    [GJCFAssetsPickerConstans postNoti:kGJAssetsPickerNeedCancelNoti];
}

#pragma mark - PhotoViewController Delegate
- (GJCFAssetsPickerStyle*)photoViewControllerShouldUseCustomStyle:(GJCFPhotosViewController *)photoViewController
{
    return [self defaultStyle];
}

- (void)photoViewController:(GJCFPhotosViewController *)photoViewController didFinishEnumrateAssets:(NSArray *)assets forAlbums:(GJCFAlbums *)destAlbums
{
    for (int i= 0; i<self.assetsGroupArray.count; i++) {
        
        GJCFAlbums *albums = [self.assetsGroupArray objectAtIndex:i];
        
        if ([albums isEqual:destAlbums]) {
            
            [albums.assetsArray addObjectsFromArray:assets];
            
            [self.assetsGroupArray replaceObjectAtIndex:i withObject:albums];
            
            break;
        }
        
    }
}

#pragma mark - tableView delegate and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //自定义相册Cell
    NSDictionary *customCellDict = self.customClassDict[kGJAlbumsViewControllerCellCustomKey];
    NSString *customAlbumsCellClassName = [customCellDict objectForKey:kGJAlbumsViewControllerCellCustomKey];
    Class customAlbumsCellClass = NSClassFromString(customAlbumsCellClassName);

    if (customAlbumsCellClass && [customAlbumsCellClass isSubclassOfClass:[GJCFAssetsPickerAlbumsCell class]]) {
        
        static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
        GJCFAssetsPickerAlbumsCell *customCell = (GJCFAssetsPickerAlbumsCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!customCell) {
            customCell = [[customAlbumsCellClass alloc]init];
        }
        
        [customCell setAlbums:[self.assetsGroupArray objectAtIndex:indexPath.row]];
        
        return customCell;
    
    }
    
    //使用系统的效果
    static NSString *CellIdentifier = @"CellIdentifier";
    GJCFAssetsPickerAlbumsCell *cell = (GJCFAssetsPickerAlbumsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[GJCFAssetsPickerAlbumsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setAlbums:[self.assetsGroupArray objectAtIndex:indexPath.row]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //自定义相册Cell
    NSDictionary *customCellDict = self.customClassDict[kGJAlbumsViewControllerCellCustomKey];
    if (customCellDict) {
        return [[customCellDict objectForKey:kGJAlbumsViewControllerCellCustomHeightKey] floatValue];
    }else{
        return 65.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //如果有自定义的选择照片的页面
    NSString *customPhotoControllerName = self.customClassDict[kGJPhotoViewControllerCustomKey];
    Class customPhotoControllerClass = NSClassFromString(customPhotoControllerName);

    if (customPhotoControllerName && [customPhotoControllerClass isSubclassOfClass:[GJCFPhotosViewController class]]) {
        
        GJCFPhotosViewController *customPhotoController = [[customPhotoControllerClass alloc]init];
        customPhotoController.colums = self.photoControllerColums;
        customPhotoController.albums = [self.assetsGroupArray objectAtIndex:indexPath.row];
        customPhotoController.mutilSelectLimitCount = self.mutilSelectLimitCount;
        customPhotoController.shouldInitSelectedStateAssetArray = self.shouldInitSelectedStateAssetArray;
        customPhotoController.delegate = self;
        customPhotoController.title = [(GJCFAlbums*)[self.assetsGroupArray objectAtIndex:indexPath.row] name];
        [self.navigationController pushViewController:customPhotoController animated:YES];
        
        return;
    }
    
    //使用系统效果
    GJCFPhotosViewController *photosViewController = [[GJCFPhotosViewController alloc]init];
    photosViewController.colums = self.photoControllerColums;
    photosViewController.delegate = self;
    photosViewController.albums = [self.assetsGroupArray objectAtIndex:indexPath.row];
    photosViewController.mutilSelectLimitCount = self.mutilSelectLimitCount;
    photosViewController.shouldInitSelectedStateAssetArray = self.shouldInitSelectedStateAssetArray;
    photosViewController.title = [(GJCFAlbums*)[self.assetsGroupArray objectAtIndex:indexPath.row] name];
    [self.navigationController pushViewController:photosViewController animated:YES];
    
}

#pragma mark - 对外接口

- (void)pushDefaultAlbums
{
    GJCFPhotosViewController *photosViewController = [[GJCFPhotosViewController alloc]init];
    photosViewController.colums = self.photoControllerColums;
    photosViewController.albums = [self.assetsGroupArray objectAtIndex:0];
    photosViewController.mutilSelectLimitCount = self.mutilSelectLimitCount;
    photosViewController.shouldInitSelectedStateAssetArray = self.shouldInitSelectedStateAssetArray;
    photosViewController.title = [(GJCFAlbums*)[self.assetsGroupArray objectAtIndex:0] name];
    [self.navigationController pushViewController:photosViewController animated:NO];
}

- (void)registPhotoViewControllerClass:(Class)aPhotoViewControllerClass
{
    if (!aPhotoViewControllerClass) {
        return;
    }
    [self.customClassDict setObject:NSStringFromClass(aPhotoViewControllerClass) forKey:kGJPhotoViewControllerCustomKey];
}

- (void)registAlbumsCustomCellClass:(Class)aAlbumsCustomCellClass
{
    if (!aAlbumsCustomCellClass) {
        return;
    }
    [self registAlbumsCustomCellClass:aAlbumsCustomCellClass withCellHeight:44.f];
}

- (void)registAlbumsCustomCellClass:(Class)aAlbumsCustomCellClass withCellHeight:(CGFloat)cellHeight
{
    if (!aAlbumsCustomCellClass) {
        return;
    }
    NSDictionary *customCellDict = @{kGJAlbumsViewControllerCellCustomKey:NSStringFromClass(aAlbumsCustomCellClass),kGJAlbumsViewControllerCellCustomHeightKey:@(cellHeight)};
    [self.customClassDict setObject:customCellDict forKey:kGJAlbumsViewControllerCellCustomKey];
}

@end
