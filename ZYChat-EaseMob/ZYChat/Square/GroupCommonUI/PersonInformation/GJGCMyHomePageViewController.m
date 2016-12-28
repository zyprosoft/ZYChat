//
//  GJGCMyHomePageViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/22.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMyHomePageViewController.h"
#import "GJGCGroupInfoExtendModel.h"
#import "Base64.h"
#import "GJGCGroupPersonInformationShowMap.h"
#import "GJGCChatGroupViewController.h"
#import "GJGCMutilTextInputViewController.h"
#import "WallPaperViewController.h"
#import "AppDelegate.h"
#import "GJGCMusicSharePlayer.h"

@interface GJGCMyHomePageViewController ()<GJGCMutilTextInputViewControllerDelegate>

@end

@implementation GJGCMyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"我的"];
    
    [self setupMyInformation];
    
    [self setRightButtonWithTitle:@"注销登录"];
}

- (void)rightButtonPressed:(UIButton *)sender
{
    [[ZYUserCenter shareCenter]LogoutWithSuccess:^(NSString *message) {
       
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate logOutAction];
        
        [[GJGCMusicSharePlayer sharePlayer] signOut];
        
    } withFaild:^(NSError *error) {
        
        BTToastError(error);
        
    }];
}

- (void)setupMyInformation
{
    ZYUserModel *currentLoginUser = [[ZYUserCenter shareCenter]currentLoginUser];
    
    //展示群头像信息
    GJGCInformationCellContentModel *contentModel = [[GJGCInformationCellContentModel alloc]init];
    contentModel.baseContentType = GJGCInformationContentTypeGroupHeadInfo;
    contentModel.groupHeadUrl = currentLoginUser.headThumb;
    contentModel.groupName = currentLoginUser.nickname;
    contentModel.contentHeight = 86.f;
    contentModel.shouldShowIndicator = YES;
    
    [self.dataSourceManager addInformationItem:contentModel];
    
    /* 群账号 */
    if (currentLoginUser.userId) {
        
        GJGCInformationCellContentModel *accountItem = [GJGCGroupPersonInformationShowMap itemWithContentValueBaseText:currentLoginUser.userId tagName:@"账  号"];
        accountItem.topLineMargin = 13.f;
        accountItem.seprateStyle = GJGCInformationSeprateLineStyleTopFullBottomShort;
        
        [self.dataSourceManager addInformationItem:accountItem];
    }
    
    /* 群等级 */
    GJGCInformationCellContentModel *nicknameItem = nil;
    nicknameItem = [GJGCGroupPersonInformationShowMap itemWithTextAndIcon:currentLoginUser.nickname  icon:@"详细地址icon.png" tagName:@"昵  称"];
    [self.dataSourceManager addInformationItem:nicknameItem];
    
    /* 群等级 */
    GJGCInformationCellContentModel *levelItem = nil;
    levelItem = [GJGCGroupPersonInformationShowMap itemWithLevelValue:@"新手小白" tagName:@"等  级"];
    [self.dataSourceManager addInformationItem:levelItem];
    
    /* 群位置 */
    if (!GJCFStringIsNull(currentLoginUser.sex)) {
        
        NSString *sex = [currentLoginUser.sex integerValue] == 0? @"男":@"女";
        
        GJGCInformationCellContentModel *locationItem = [GJGCGroupPersonInformationShowMap itemWithTextAndIcon:sex  icon:@"详细地址icon.png" tagName:@"性  别"];
        locationItem.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomFull;
        locationItem.isIconShowMap = YES;
        [self.dataSourceManager addInformationItem:locationItem];
    }
    
    [self.informationListTable reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCInformationCellContentModel *contentModel = (GJGCInformationCellContentModel *)[self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    if ([contentModel.tag.string isEqualToString:@"昵  称"]) {
        
        GJGCMutilTextInputViewController *inputText = [[GJGCMutilTextInputViewController alloc]init];
        inputText.title = @"修改昵称";
        inputText.delegate = self;
        inputText.paramString = contentModel.baseContent.string;
        
        [self.navigationController pushViewController:inputText animated:YES];
    }
    
    if (contentModel.baseContentType == GJGCInformationContentTypeGroupHeadInfo) {
        
        WallPaperViewController *wallPage = [[WallPaperViewController alloc]init];
        GJCFWeakSelf weakSelf = self;
        wallPage.resultBlock = ^(NSString *imageUrl){
            
            [weakSelf updateUserAvatar:imageUrl];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        [self.navigationController pushViewController:wallPage animated:YES];
    }
}

- (void)updateUserAvatar:(NSString *)imageUrl
{
    [[ZYUserCenter shareCenter] updateAvatar:imageUrl];
    
    [self.dataSourceManager removeAllData];
    [self setupMyInformation];
}

#pragma mark - 昵称输入回调

- (void)mutilTextInputViewController:(GJGCMutilTextInputViewController *)inputViewController didFinishInputText:(NSString *)text
{
    if (GJCFStringIsNull(text)) {
        return;
    }
    [[ZYUserCenter shareCenter] updateNickname:text];
    [self.dataSourceManager removeAllData];
    [self  setupMyInformation];
}

@end
