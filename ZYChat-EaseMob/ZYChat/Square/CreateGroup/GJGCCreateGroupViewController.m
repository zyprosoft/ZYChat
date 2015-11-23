//
//  GJGCCreateGroupViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCCreateGroupViewController.h"
#import "GJGCCreateGroupBaseCell.h"
#import "GJGCCreateGroupDataManager.h"
#import "BTDateActionSheetViewController.h"
#import "GJGCMutilTextInputViewController.h"
#import "GJGCCreateGroupLabelsSheetViewController.h"
#import "GJGCCreateGroupMemberCountSheetViewController.h"
#import "GJGCCreateGroupTypeSheetViewController.h"
#import "WallPaperViewController.h"
#import "GJGCCreateGroupAddressSheetViewController.h"

@interface GJGCCreateGroupViewController ()<
                                            UITableViewDataSource,
                                            UITableViewDelegate,
                                            GJGCCreateGroupCellDelegate,
                                            GJGCCreateGroupDataManagerDelegate,
                                            GJGCMutilTextInputViewControllerDelegate
                                            >

@property (nonatomic,strong)GJGCCreateGroupDataManager *dataManager;

@property (nonatomic,strong)UITableView *listTable;

@property (nonatomic,strong)UIButton *submitBtn;

@property (nonatomic,strong)NSIndexPath *updateIndexPath;

@property (nonatomic,assign)NSInteger editingIndex;

/**
 *  完成编辑按钮
 */
@property (nonatomic,strong)UIButton *finishEditButton;



@end

@implementation GJGCCreateGroupViewController

- (void)dealloc
{
    [GJCFNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    
    [self setStrNavTitle:@"创建群组"];
    
    self.dataManager = [[GJGCCreateGroupDataManager alloc]init];
    self.dataManager.delegate = self;
    
    self.listTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, GJCFSystemScreenWidth, GJCFSystemScreenHeight - 64 - 46)];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTable];
    
    self.submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, GJCFSystemScreenHeight - 44, GJCFSystemScreenWidth * 1/2, 32)];
    [self.submitBtn setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], self.submitBtn.gjcf_size) forState:UIControlStateNormal];
    self.submitBtn.layer.cornerRadius = 4.f;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"提交创建" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.submitBtn.gjcf_centerX = GJCFSystemScreenWidth/2;
    self.submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn.gjcf_bottom = GJCFSystemScreenHeight - 64 - 10.f;
    [self.view addSubview:self.submitBtn];
    
    [self.dataManager createMemberList];
    
    //
    [GJCFNotificationCenter addObserver:self selector:@selector(observeKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeKeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)leftNavigationBarItemPressed
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"退出编辑所有数据都将丢失，是否放弃?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"放弃"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

#pragma mark - tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataManager.totalCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DefaultCellIdentifier = @"DefaultCellIdentifier";
    
    NSString *cellIdentifier = [self.dataManager cellIdentifierAtIndexPath:indexPath];
    
    Class cellClass = [self.dataManager cellClassAtIndexPath:indexPath];
    
    if (!cellClass || !cellIdentifier) {
        
        return [[GJGCCreateGroupBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultCellIdentifier];
    }
    
    GJGCCreateGroupBaseCell *cell = (GJGCCreateGroupBaseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = (GJGCCreateGroupBaseCell *)[[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    
    [cell setContentModel:[self.dataManager contentModelAtIndexPath:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCCreateGroupContentModel *content = [self.dataManager contentModelAtIndexPath:indexPath];
    
    return content.contentHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GJGCCreateGroupContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    //隐藏键盘
    switch (contentModel.contentType) {
        case GJGCCreateGroupContentTypeLabels:
        case GJGCCreateGroupContentTypeLocation:
        case GJGCCreateGroupContentTypeHeadThumb:
        case GJGCCreateGroupContentTypeDescription:
        case GJGCCreateGroupContentTypeAddress:
        case GJGCCreateGroupContentTypeMemberCount:
        case GJGCCreateGroupContentTypeGroupType:
        {
            [self hideKeyboard];
        }
            break;
            
        default:
            break;
    }
    
    switch (contentModel.contentType) {
        case GJGCCreateGroupContentTypeHeadThumb:
        {
            WallPaperViewController *wallPaper = [[WallPaperViewController alloc]init];
            GJCFWeakSelf weakSelf = self;
            wallPaper.resultBlock = ^(NSString *imageUrl){
                
                [weakSelf.dataManager updateHeadUrl:imageUrl];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:wallPaper animated:YES];
        }
            break;
        case GJGCCreateGroupContentTypeAddress:
        {
            GJGCCreateGroupAddressSheetViewController *memberCountVC = [[GJGCCreateGroupAddressSheetViewController alloc]init];
            memberCountVC.title = @"选择地址";
            GJCFWeakSelf weakSelf = self;
            memberCountVC.resultBlock = ^(BTActionSheetBaseContentModel *resultModel){
                
                [weakSelf.dataManager updateAddress:resultModel.userInfo[@"data"]];
            };
            [memberCountVC showFromViewController:self];
        }
            break;
        case GJGCCreateGroupContentTypeMemberCount:
        {
            GJGCCreateGroupMemberCountSheetViewController *memberCountVC = [[GJGCCreateGroupMemberCountSheetViewController alloc]init];
            memberCountVC.title = @"选择群人数";
            GJCFWeakSelf weakSelf = self;
            memberCountVC.resultBlock = ^(BTActionSheetBaseContentModel *resultModel){
                
                [weakSelf.dataManager updateMemberCount:resultModel.userInfo[@"data"]];
            };
            [memberCountVC showFromViewController:self];
        }
            break;
        case GJGCCreateGroupContentTypeLabels:
        {
            GJGCCreateGroupLabelsSheetViewController *memberCountVC = [[GJGCCreateGroupLabelsSheetViewController alloc]init];
            memberCountVC.title = @"选择群标签";
            GJCFWeakSelf weakSelf = self;
            memberCountVC.resultBlock = ^(BTActionSheetBaseContentModel *resultModel){
                
                [weakSelf.dataManager updateLabels:resultModel.userInfo[@"data"]];
            };
            [memberCountVC showFromViewController:self];
        }
            break;
        case GJGCCreateGroupContentTypeDescription:
        {
            GJGCMutilTextInputViewController *mutilInput = [[GJGCMutilTextInputViewController alloc]init];
            mutilInput.delegate = self;
            mutilInput.title = @"填写群简介";
            mutilInput.paramString = contentModel.content;
            
            [self.navigationController pushViewController:mutilInput animated:YES];
        }
            break;
        case GJGCCreateGroupContentTypeGroupType:
        {
            GJGCCreateGroupTypeSheetViewController *typeVC = [[GJGCCreateGroupTypeSheetViewController alloc]init];
            typeVC.title = @"选择群类型";
            GJCFWeakSelf weakSelf = self;
            typeVC.resultBlock = ^(BTActionSheetBaseContentModel *resultModel){
                
                [weakSelf.dataManager updateGroupType:resultModel.userInfo[@"type"] display:resultModel.userInfo[@"display"]];
            };
            [typeVC showFromViewController:self];
        }
            break;
        default:
            break;
    }
}

#pragma mark - keyboard Notification

- (void)observeKeyboardWillShow:(NSNotification *)noti
{
    self.listTable.contentInset = UIEdgeInsetsMake(0, 0, 216 + 20, 0);
    
    CGRect keyboardBeginFrame = [noti.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect keyboardEndFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (keyboardBeginFrame.origin.y >= GJCFSystemScreenHeight) {
        
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            
            if (strongSelf) {
                
                strongSelf.finishEditButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
                
                
                [strongSelf.finishEditButton setBackgroundImage:[UIImage imageNamed:@"keyboardButton"] forState:UIControlStateNormal];
                [strongSelf.finishEditButton setBackgroundImage:[UIImage imageNamed:@"keyboardButton-点击"] forState:UIControlStateHighlighted];
                
                [strongSelf.finishEditButton addTarget: strongSelf action:@selector(hideKeyboard) forControlEvents: UIControlEventTouchUpInside];
                strongSelf.finishEditButton.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.45].CGColor;
                strongSelf.finishEditButton.layer.shadowOffset = CGSizeMake(1.5, -1.5);
                strongSelf.finishEditButton.layer.shadowOpacity = 0.45;
                strongSelf.finishEditButton.layer.shadowRadius = 0.8;
                strongSelf.finishEditButton.gjcf_width = 57;
                strongSelf.finishEditButton.gjcf_height = 33;
                strongSelf.finishEditButton.gjcf_left = 15.f;
                strongSelf.finishEditButton.gjcf_bottom = strongSelf.view.gjcf_height;
                [strongSelf.view addSubview:strongSelf.finishEditButton];
                
                [UIView animateWithDuration:0.26 animations:^{
                    strongSelf.finishEditButton.gjcf_bottom = strongSelf.view.gjcf_height - keyboardEndFrame.size.height;
                    
                }];
            }
            
            
        });
        
    }
    else
    {
        self.finishEditButton.gjcf_bottom = self.view.gjcf_height - keyboardEndFrame.size.height;
    }
}

- (void)hideKeyboard
{
    NSIndexPath *editingIndexPath = [NSIndexPath indexPathForRow:self.editingIndex inSection:0];
    
    GJGCCreateGroupBaseCell *editingCell = (GJGCCreateGroupBaseCell *)[self.listTable cellForRowAtIndexPath:editingIndexPath];
    
    [editingCell resignInputFirstResponse];
}

- (void)observeKeyboardWillHidden:(NSNotification *)noti
{
    self.listTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.finishEditButton removeFromSuperview];
    self.finishEditButton = nil;
}

#pragma mark - BTUploadShopBaseCellDelegate

- (void)inputTextCellDidBeginEdit:(GJGCCreateGroupBaseCell *)inputTextCell
{
    NSIndexPath *indexPath = [self.listTable indexPathForCell:inputTextCell];
    
    self.editingIndex = indexPath.row;
    
    CGRect convertCellToView = [self.listTable convertRect:inputTextCell.frame toView:self.view];
    
    if (convertCellToView.origin.y - 44 > (216 + 20)) {
        
        [self.listTable scrollRectToVisible:inputTextCell.frame animated:YES];
    }
}

- (void)inputTextCell:(GJGCCreateGroupBaseCell *)inputTextCell didUpdateContent:(NSString *)content
{
    NSIndexPath *indexPath = [self.listTable indexPathForCell:inputTextCell];
    
    [self.dataManager updateTextContentWith:content forIndexPath:indexPath];
}

- (void)inputTextCellDidTriggleMaxLengthInputLimit:(GJGCCreateGroupBaseCell *)inputTextCell maxLength:(NSInteger)maxLength
{
    NSString *errMsg = [NSString stringWithFormat:@"最长允许输入%ld个字",maxLength];
    
    [self showErrorMessage:errMsg];
}


#pragma mark - DataManager Delegate

- (void)dataManagerRequireRefresh:(GJGCCreateGroupDataManager *)dataManager
{
    [self.listTable reloadData];
}

- (void)dataManagerRequireRefresh:(GJGCCreateGroupDataManager *)dataManager reloadAtIndexPaths:(NSArray *)indexPaths
{
    [self.listTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dataManager:(GJGCCreateGroupDataManager *)dataManager showErrorMessage:(NSString *)message
{
    [self.statusHUD dismiss];
    [self showErrorMessage:message];
}

- (void)dataManagerDidCreateGroupSuccess:(GJGCCreateGroupDataManager *)dataManager
{
    BTToast(@"创建成功");
    [self.statusHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitClick
{
    [self.statusHUD showWithStatusText:@"正在创建..."];
    [self.dataManager uploadGroupInfoAction];
}

#pragma mark - MutilInputText

- (void)mutilTextInputViewController:(GJGCMutilTextInputViewController *)inputViewController didFinishInputText:(NSString *)text
{
    [self.dataManager updateSimpleDescription:text];
}

@end
