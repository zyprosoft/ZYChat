//
//  GJGCSystemNotiViewController.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-11.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatSystemNotiViewController.h"
//#import "GJGCPersonInformationViewController.h"
//#import "GJGCGroupInformationViewController.h"
#import "GJGCChatFriendViewController.h"


@interface GJGCChatSystemNotiViewController ()<GJGCChatBaseCellDelegate>

@end

@implementation GJGCChatSystemNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputPanel.hidden = YES;

    [self setStrNavTitle:self.dataSourceManager.title];
    
    self.chatListTable.gjcf_height = GJCFSystemScreenHeight - GJCFSystemOriginYDelta - 44;
    
    
    /* 滚动到最底部 */
    if (self.dataSourceManager.totalCount > 0) {
        [self.chatListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceManager.totalCount-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - 内部初始化

- (void)initDataManager
{
    self.dataSourceManager = [[GJGCChatSystemNotiDataManager alloc]initWithTalk:self.taklInfo withDelegate:self];
}

#pragma mark - chatInputPanel Delegte

- (BOOL)chatInputPanelShouldShowMyFavoriteItem:(GJGCChatInputPanel *)panel
{
    return NO;
}

#pragma mark - TableView  Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCChatSystemNotiModel *notiModel = (GJGCChatSystemNotiModel *)[self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    /* 帖子系统消息 */
    if (notiModel.notiType == GJGCChatSystemNotiTypePostSystemNoti && notiModel.postSystemJumpType > 0) {
        
    }
    
    /* 如果是引导card */
    if (notiModel.assistType == GJGCChatSystemNotiAssistTypeTemplate) {
        
    }
}

#pragma mark - 系统通知Cell 代理方法

- (void)systemNotiBaseCellDidTapOnAcceptApplyButton:(GJGCChatBaseCell *)tapedCell
{
    
}

- (void)acceptOrRejectOtherUserApplyWithFaildErrorCode:(NSInteger)errorCode forContentAtIndex:(NSIndexPath *)index errMsg:(NSString *)errMsg
{
    
}

- (void)systemNotiBaseCellDidTapOnJoinGroupChatButton:(GJGCChatBaseCell *)tapedCell
{
}

- (void)systemNotiBaseCellDidTapOnRejectApplyButton:(GJGCChatBaseCell *)tapedCell
{
    
}

- (void)systemNotiBaseCellDidTapOnRoleView:(GJGCChatBaseCell *)tapedCell
{    
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatSystemNotiModel *contentModel = (GJGCChatSystemNotiModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
    if (contentModel.isUserContent) {
        
//        GJGCPersonInformationViewController *personInformationVC = [[GJGCPersonInformationViewController alloc]initWithUserId:contentModel.userId reportType:GJGCReportTypePerson];
//        [[GJGCUIStackManager share]pushViewController:personInformationVC animated:YES];
        
    }
    
    if (contentModel.isGroupContent) {
        
//        GJGCGroupInformationViewController *groupInformationVC = [[GJGCGroupInformationViewController alloc]initWithGroupId:contentModel.groupId];
//        [[GJGCUIStackManager share]pushViewController:groupInformationVC animated:YES];
    }

}

- (void)systemNotiBaseCellDidTapOnInviteFriendJoinGroup:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatSystemNotiModel *contentModel = (GJGCChatSystemNotiModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
}

- (void)systemNotiBaseCellDidTapOnSystemActiveGuideButton:(GJGCChatBaseCell *)tapedCell
{

}

@end
