//
//  GJGCAppWallViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/26.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCAppWallViewController.h"
#import "WJItemsControlView.h"
#import "GJGCAppWallDataManager.h"
#import "BTDateActionSheetViewController.h"
#import "GJGCAppWallAreaSheetViewController.h"
#import "GJGCAppWallParamsModel.h"


@interface GJGCAppWallViewController ()<UIActionSheetDelegate>

@property (nonatomic,strong)WJItemsControlView *itemControlView;
@property (nonatomic,strong)UISegmentedControl *payTypeSegement;

@property (nonatomic,strong)UIButton *dateButton;
@property (nonatomic,strong)UIButton *areaButton;
@property (nonatomic,strong)UIButton *deviceButton;

@end

@implementation GJGCAppWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTitleView];
    
    //头部控制的segMent
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = GJCFSystemScreenWidth/3.0;
    
    _itemControlView = [[WJItemsControlView alloc]initWithFrame:CGRectMake(0,0, GJCFSystemScreenWidth, 40)];
    _itemControlView.tapAnimation = YES;
    _itemControlView.config = config;
    _itemControlView.titleArray = [[self categroyDict]allKeys];
    GJCFWeakSelf weakSelf = self;
    [_itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        [weakSelf.itemControlView moveToIndex:index];
        [weakSelf setupCategorAtIndex:index];
        
    }];
    [self.view addSubview:_itemControlView];
    [self setupCategorAtIndex:0];
    
    self.listTable.gjcf_height = GJCFSystemScreenHeight - self.contentOriginY - 40.f;
    self.listTable.gjcf_top = _itemControlView.gjcf_bottom;
    
    GJGCAppWallDataManager *selfDataManager = (GJGCAppWallDataManager *)self.dataManager;
    [selfDataManager requestAppListNow];
}

- (void)setupCategorAtIndex:(NSInteger)index
{
    NSString *key = [self categroyDict].allKeys[index];
    GJGCAppWallDataManager *selfDataManager = (GJGCAppWallDataManager *)self.dataManager;
    
    if (![selfDataManager.paramsModel.categoryId isEqualToString:[self categroyDict][key]]) {
        
        selfDataManager.paramsModel.categoryId = [self categroyDict][key];

        [self autoUpdateList];
    }
}

- (void)autoUpdateList
{
    GJGCAppWallDataManager *selfDataManager = (GJGCAppWallDataManager *)self.dataManager;
    if (!selfDataManager.isFirstLoadingFinish) {
        return;
    }
    selfDataManager.isFirstLoadingFinish = NO;
    [self startRefresh];
    [self.listTable scrollRectToVisible:self.listTable.bounds animated:YES];
    selfDataManager.isRefresh = YES;
    [selfDataManager requestAppListNow];
}

- (void)setupTitleView
{
    UIView *titleView = [[UIView alloc]init];
    titleView.gjcf_width = GJCFSystemScreenWidth - 2*30.f;
    titleView.gjcf_height = 44.f;
    
    self.payTypeSegement = [[UISegmentedControl alloc]initWithItems:@[@"免费",@"付费"]];
    self.payTypeSegement.tintColor = [UIColor whiteColor];
    self.payTypeSegement.selectedSegmentIndex = 0;
    [titleView addSubview:self.payTypeSegement];
    self.payTypeSegement.gjcf_centerY = titleView.gjcf_height/2;
    
    self.dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dateButton.gjcf_width = 100.f;
    self.dateButton.gjcf_height = 30.f;
    self.dateButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    [self.dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dateButton.layer.cornerRadius = 5.f;
    self.dateButton.layer.masksToBounds = YES;
    self.dateButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dateButton.layer.borderWidth = 0.5f;
    [self.dateButton addTarget:self action:@selector(chooseDateAction) forControlEvents:UIControlEventTouchUpInside];
    NSDate *date = [NSDate date];
    [self setupDate:date];
    
    [titleView addSubview:self.dateButton];
    self.dateButton.gjcf_left = self.payTypeSegement.gjcf_right + 10.f;
    self.dateButton.gjcf_centerY = self.payTypeSegement.gjcf_centerY;
    
    self.areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.areaButton.gjcf_width = 60.f;
    self.areaButton.gjcf_height = 30.f;
    self.areaButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    [self.areaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.areaButton.layer.cornerRadius = 5.f;
    self.areaButton.layer.masksToBounds = YES;
    self.areaButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.areaButton.layer.borderWidth = 0.5f;
    [self.areaButton addTarget:self action:@selector(chooseAreaAction) forControlEvents:UIControlEventTouchUpInside];
    [self setupArea:@"中国" areaId:@"cn"];
    
    [titleView addSubview:self.areaButton];
    self.areaButton.gjcf_left = self.dateButton.gjcf_right + 10.f;
    self.areaButton.gjcf_centerY = self.payTypeSegement.gjcf_centerY;
    
    self.deviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deviceButton.gjcf_width = 55.f;
    self.deviceButton.gjcf_height = 30.f;
    self.deviceButton.titleLabel.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
    [self.deviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deviceButton.layer.cornerRadius = 5.f;
    self.deviceButton.layer.masksToBounds = YES;
    self.deviceButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.deviceButton.layer.borderWidth = 0.5f;
    [self.deviceButton addTarget:self action:@selector(chooseDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self setupDevice:@"iPhone"];
    
    [titleView addSubview:self.deviceButton];
    self.deviceButton.gjcf_left = self.areaButton.gjcf_right + 5;
    self.deviceButton.gjcf_centerY = self.payTypeSegement.gjcf_centerY;
    
    self.navigationItem.titleView = titleView;
}

- (void)chooseDateAction
{
    BTDateActionSheetViewController *dateChoose = [[BTDateActionSheetViewController alloc]init];
    dateChoose.title = @"选择日期";
    GJCFWeakSelf weakSelf = self;
    dateChoose.startDate = GJCFDateFromStringByFormat(@"2008-6-8",kNSDateHelperFormatSQLDate);
    dateChoose.endDate = [NSDate date];
    dateChoose.selectedDate = [NSDate date];
    dateChoose.resultBlock = ^(BTActionSheetBaseContentModel *resultModel){
      
        [weakSelf setupDate:resultModel.userInfo[@"date"]];
    };
    [dateChoose showFromViewController:self];
}

- (void)setupDate:(NSDate *)date
{
    NSString *dateString = GJCFDateToStringByFormat(date, kNSDateHelperFormatSQLDate);
    [self.dateButton setTitle:dateString forState:UIControlStateNormal];
    GJGCAppWallDataManager *selfDataManager = (GJGCAppWallDataManager *)self.dataManager;
    
    if (![selfDataManager.paramsModel.date isEqualToString:dateString]) {
        
        selfDataManager.paramsModel.date = dateString;
        
        [self autoUpdateList];
    }
}

- (void)chooseAreaAction
{
    GJGCAppWallAreaSheetViewController *areaChoose = [[GJGCAppWallAreaSheetViewController alloc]init];
    areaChoose.title = @"选择地区";
    GJCFWeakSelf weakSelf = self;
    areaChoose.resultBlock = ^(BTActionSheetBaseContentModel *resultModel){
        
        [weakSelf setupArea:resultModel.userInfo[@"name"] areaId:resultModel.userInfo[@"data"]];
    };
    [areaChoose showFromViewController:self];
}

- (void)setupArea:(NSString *)areaName areaId:(NSString *)areaId
{
    [self.areaButton setTitle:areaName forState:UIControlStateNormal];
    GJGCAppWallDataManager *selfDataManager = (GJGCAppWallDataManager *)self.dataManager;
    
    if (![selfDataManager.paramsModel.area isEqualToString:areaId]) {
        
        selfDataManager.paramsModel.area = areaId;
        
        [self autoUpdateList];

    }
}

- (void)chooseDeviceAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择类型" delegate:self cancelButtonTitle:@"退出" destructiveButtonTitle:@"iPhone" otherButtonTitles:@"iPad", nil];
    [actionSheet showInView:self.view];
}

- (void)setupDevice:(NSString *)deviceName
{
    [self.deviceButton setTitle:deviceName forState:UIControlStateNormal];
    GJGCAppWallDataManager *selfDataManager = (GJGCAppWallDataManager *)self.dataManager;
    
    if (![selfDataManager.paramsModel.device isEqualToString:deviceName]) {
        
        selfDataManager.paramsModel.device = deviceName;

        [self autoUpdateList];
    }
}

#pragma mark - Device Choose ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        
        [self setupDevice:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
}

- (void)initDataManager
{
    self.dataManager = [[GJGCAppWallDataManager alloc]init];
    self.dataManager.delegate = self;
}

- (void)setParamsModel:(GJGCAppWallParamsModel *)paramsModel
{
    [(GJGCAppWallDataManager *)self.dataManager setParamsModel:paramsModel];
}

- (GJGCAppWallParamsModel *)paramsModel
{
    return [(GJGCAppWallDataManager *)self.dataManager paramsModel];
}

- (NSDictionary *)categroyDict
{
    return @{
             @"商务":@"6000",
             @"天气":@"6001",
             @"工具":@"6002",
             @"旅行":@"6003",
             @"体育":@"6004",
             @"社交":@"6005",
             @"参考":@"6006",
             @"效率":@"6007",
             @"摄影与录像":@"6008",
             @"新闻":@"6009",
             @"导航":@"6010",
             @"音乐":@"6011",
             @"生活":@"6012",
             @"健康健美":@"6013",
             @"游戏":@"6014",
             @"财务":@"6015",
             @"娱乐":@"6016",
             @"教育":@"6017",
             @"图书":@"6018",
             @"医疗":@"6020",
             @"报刊杂志":@"6021",
             @"商品指南":@"6022",
             @"美食与饮品":@"6023",
             };
}

@end
