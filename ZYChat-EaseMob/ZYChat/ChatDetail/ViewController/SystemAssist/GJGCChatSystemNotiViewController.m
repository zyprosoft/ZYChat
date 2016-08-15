//
//  GJGCSystemNotiViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-11.
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
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
        GJGCChatSystemNotiModel *contentModel = (GJGCChatSystemNotiModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
    EMTextMessageBody *body = (EMTextMessageBody *)contentModel.message.body;
    NSMutableDictionary *messageInfo = [[body.text toDictionary]mutableCopy];

    if (contentModel.assistType == GJGCChatSystemNotiAssistTypeFriend) {
        
        [self.statusHUD showWithStatusText:@"正在执行"];
        GJCFWeakSelf weakSelf = self;
        [[EMClient sharedClient].contactManager asyncAcceptInvitationForUsername:contentModel.userId success:^{
            
            GJCFStrongSelf strongSelf = weakSelf;
            
            //更新数据库
            [messageInfo setObject:[@(GJGCChatSystemNotiAcceptStateFinish) stringValue] forKey:@"acceptState"];
            EMTextMessageBody *nBody = [[EMTextMessageBody alloc]initWithText:[messageInfo toJson]];
            contentModel.message.body = nBody;
            [strongSelf.taklInfo.conversation updateMessage:contentModel.message];
            
            [contentModel setNotiType:GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState];
            contentModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已通过"];
            [strongSelf.dataSourceManager updateContentModel:contentModel atIndex:tapIndexPath.row];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.statusHUD dismiss];
                [strongSelf.chatListTable reloadRowsAtIndexPaths:@[tapIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
            
            
        } failure:^(EMError *aError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.statusHUD dismiss];
                BTToast(@"执行失败");
            });
            
        }];

    }
    
    if (contentModel.assistType == GJGCChatSystemNotiAssistTypeGroup) {
        
        [self.statusHUD showWithStatusText:@"正在执行"];
        GJCFWeakSelf weakSelf = self;
        [[EMClient sharedClient].groupManager asyncAcceptJoinApplication:contentModel.groupId applicant:contentModel.userId success:^{
            
            GJCFStrongSelf strongSelf = weakSelf;
            
            //更新数据库
            [messageInfo setObject:[@(GJGCChatSystemNotiAcceptStateFinish) stringValue] forKey:@"acceptState"];
            EMTextMessageBody *nBody = [[EMTextMessageBody alloc]initWithText:[messageInfo toJson]];
            contentModel.message.body = nBody;
            [strongSelf.taklInfo.conversation updateMessage:contentModel.message];
            
            [contentModel setNotiType:GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState];
            contentModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已通过"];
            [strongSelf.dataSourceManager updateContentModel:contentModel atIndex:tapIndexPath.row];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.statusHUD dismiss];
                [strongSelf.chatListTable reloadRowsAtIndexPaths:@[tapIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
            
        } failure:^(EMError *aError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.statusHUD dismiss];
                NSLog(@"error :%@",aError.errorDescription);
                BTToast(@"执行失败");
            });
            
        }];
    }
}

- (void)acceptOrRejectOtherUserApplyWithFaildErrorCode:(NSInteger)errorCode forContentAtIndex:(NSIndexPath *)index errMsg:(NSString *)errMsg
{
    
}

- (void)systemNotiBaseCellDidTapOnJoinGroupChatButton:(GJGCChatBaseCell *)tapedCell
{
}

- (void)systemNotiBaseCellDidTapOnRejectApplyButton:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatSystemNotiModel *contentModel = (GJGCChatSystemNotiModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
    EMTextMessageBody *body = (EMTextMessageBody *)contentModel.message.body;
    NSMutableDictionary *messageInfo = [[body.text toDictionary]mutableCopy];

    if (contentModel.assistType == GJGCChatSystemNotiAssistTypeFriend) {
        
        [self.statusHUD showWithStatusText:@"正在执行"];
        GJCFWeakSelf weakSelf = self;
        [[EMClient sharedClient].contactManager asyncDeclineInvitationForUsername:contentModel.userId success:^{
            
            GJCFStrongSelf strongSelf = weakSelf;
            
            //更新数据库
            [messageInfo setObject:[@(GJGCChatSystemNotiAcceptStateReject) stringValue] forKey:@"acceptState"];
            EMTextMessageBody *nBody = [[EMTextMessageBody alloc]initWithText:[messageInfo toJson]];
            contentModel.message.body = nBody;
            [strongSelf.taklInfo.conversation updateMessage:contentModel.message];
            
            [contentModel setNotiType:GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState];
            contentModel.applyReason = [GJGCChatSystemNotiCellStyle formateApplyReason:@"已拒绝"];
            [strongSelf.dataSourceManager updateContentModel:contentModel atIndex:tapIndexPath.row];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.statusHUD dismiss];
                [strongSelf.chatListTable reloadRowsAtIndexPaths:@[tapIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
            
            
        } failure:^(EMError *aError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.statusHUD dismiss];
                BTToast(@"执行失败");
            });
            
        }];
        
    }
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
