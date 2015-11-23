//
//  BTActionSheetViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetViewController.h"

@interface BTActionSheetViewController ()<UITableViewDataSource,UITableViewDelegate>



@end

@implementation BTActionSheetViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initDataManager];
    }
    return self;
}

- (void)initDataManager
{
    self.dataManager = [[BTActionSheetDataManager alloc]init];
    self.dataManager.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //蒙层
    self.backMaskView = [[UIView alloc]init];
    self.backMaskView.gjcf_width = GJCFSystemScreenWidth;
    self.backMaskView.gjcf_height = GJCFSystemScreenHeight;
    self.backMaskView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    self.backMaskView.alpha = 0.f;
    [self.view addSubview:self.backMaskView];
    
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnMaskView:)];
    [self.backMaskView addGestureRecognizer:tapR];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.gjcf_width = GJCFSystemScreenWidth;
    self.contentView.gjcf_height = GJCFSystemScreenHeight - 64 - 60;
    self.contentView.gjcf_top = GJCFSystemScreenHeight;
    [self.view addSubview:self.contentView];
    
    //工具栏
    self.toolBar = [[UIView alloc]init];
    self.toolBar.backgroundColor = [GJGCCommonFontColorStyle mainThemeColor];
    self.toolBar.gjcf_width = GJCFSystemScreenWidth + 4;
    self.toolBar.gjcf_height = 40.f;
    self.toolBar.gjcf_left = -2.f;
    self.toolBar.layer.borderColor = [GJGCCommonFontColorStyle mainSeprateLineColor].CGColor;
    self.toolBar.layer.borderWidth = 0.5f;
    [self.contentView addSubview:self.toolBar];
    
    //取消
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.gjcf_width = 50.f;
    self.cancelButton.gjcf_height = 26.f;
    self.cancelButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    self.cancelButton.layer.borderColor = [GJGCCommonFontColorStyle mainSeprateLineColor].CGColor;
    self.cancelButton.layer.borderWidth = 0.5f;
    self.cancelButton.layer.cornerRadius = 3.f;
    self.cancelButton.layer.masksToBounds = YES;
    [self.cancelButton setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainSeprateLineColor], self.cancelButton.gjcf_size) forState:UIControlStateHighlighted];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.toolBar addSubview:self.cancelButton];
    self.cancelButton.gjcf_centerY = self.toolBar.gjcf_height/2;
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.gjcf_left = 13.f;
    
    //标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.gjcf_width = 120.f;
    self.titleLabel.gjcf_height = self.cancelButton.gjcf_height;
    self.titleLabel.gjcf_centerX = GJCFSystemScreenWidth/2;
    self.titleLabel.gjcf_centerY = self.cancelButton.gjcf_centerY;
    self.titleLabel.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.toolBar addSubview:self.titleLabel];
    
    //确定按钮
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.gjcf_width = 50.f;
    self.doneButton.gjcf_height = 26.f;
    self.doneButton.layer.cornerRadius = 3.f;
    self.doneButton.layer.masksToBounds = YES;
    self.doneButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    self.doneButton.layer.borderColor = [GJGCCommonFontColorStyle mainSeprateLineColor].CGColor;
    self.doneButton.layer.borderWidth = 0.5f;
    [self.doneButton setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainSeprateLineColor], self.cancelButton.gjcf_size) forState:UIControlStateHighlighted];
    [self.doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.toolBar addSubview:self.doneButton];
    self.doneButton.gjcf_centerY = self.toolBar.gjcf_height/2;
    [self.doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.gjcf_right = GJCFSystemScreenWidth - 13.f;
    self.doneButton.hidden = YES;
    if (self.isMutilSelect) {
        self.doneButton.hidden = NO;
    }
    
    self.listTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,GJCFSystemScreenWidth,self.contentView.gjcf_height - self.toolBar.gjcf_height-64)];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    self.listTable.gjcf_top = self.toolBar.gjcf_bottom;
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.listTable];
    [self.dataManager requestContentList];
    
    [self animationShowSheet];
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    self.contentView.gjcf_height = contentHeight;
    self.listTable.gjcf_height = self.contentView.gjcf_height - self.toolBar.gjcf_height;
    self.listTable.gjcf_bottom = self.contentView.gjcf_height;
    self.contentView.gjcf_bottom = GJCFSystemScreenHeight;
}

- (void)setIsMutilSelect:(BOOL)isMutilSelect
{
    _isMutilSelect = isMutilSelect;
    self.dataManager.isMutilSelect = isMutilSelect;
}

- (void)setSelectedItems:(NSArray *)selectedItems
{
    self.dataManager.selectedItems = selectedItems;
}

- (void)animationShowSheet
{
    [UIView animateWithDuration:0.3 animations:^{
       
        self.backMaskView.alpha = 1.f;
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.contentView.gjcf_bottom = GJCFSystemScreenHeight;
        
    }];
}

- (void)animationHiddeSheet
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.gjcf_top = GJCFSystemScreenHeight;
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backMaskView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self  removeFromParentViewController];
        
    }];
}

#pragma mark - tableView delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataManager.totalCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self.dataManager cellIdentifierAtIndexPath:indexPath];
    BTActionSheetBaseCell *cell = (BTActionSheetBaseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Class className = [self.dataManager cellClassAtIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[className alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setContentModel:[self.dataManager contentModelAtIndexPath:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataManager contentHeightAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTActionSheetBaseContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    if (self.dataManager.isMutilSelect) {
        
        if (!contentModel.disableMutilSelectUserInteract) {
            
            [self.dataManager changeSelectedStateAtIndexPath:indexPath];

        }
        
    }else{
        
        if (self.resultBlock) {
            
            self.resultBlock(contentModel);
        }
        
        [self cancelAction];

    }
}

#pragma mark dataManager delegate

- (void)dataManagerRequireRefresh:(BTActionSheetDataManager *)dataManager
{
    [self.listTable reloadData];
}

- (void)dataManagerRequireRefresh:(BTActionSheetDataManager *)dataManager reloadAtIndexPaths:(NSArray *)indexPaths
{
    [self.listTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showFromViewController:(UIViewController *)aViewController
{
    [aViewController addChildViewController:self];
    [aViewController.view addSubview:self.view];
    [self animationShowSheet];
}

- (void)tapOnMaskView:(UITapGestureRecognizer *)tapR
{
    [self cancelAction];
}

- (void)cancelAction
{
    //没数据退出了界面
    if (self.cancelBlock && self.dataManager.totalCount == 0) {
        
        self.cancelBlock();
    }
    
    [self animationHiddeSheet];
}

- (void)doneAction
{
    if (self.mutilChooseResultBlock) {
        
        self.mutilChooseResultBlock([self.dataManager selectedModels]);
    }
    [self animationHiddeSheet];
}

@end
