//
//  GJGCChatGroupViewController.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatGroupViewController.h"
#import "GJGCChatGroupDataSourceManager.h"
//#import "GJGCGroupInformationViewController.h"
//#import "GJGCPersonInformationViewController.h"

@interface GJGCChatGroupViewController ()


@end

@implementation GJGCChatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setRightButtonWithStateImage:@"title-icon-群资料" stateHighlightedImage:nil stateDisabledImage:nil titleName:nil];

    [self setStrNavTitle:self.dataSourceManager.title];
    
    /* 读草稿 */
//    [self.inputPanel setLastMessageDraft:messageDraft];
    
}




#pragma mark - 数据源

- (void)initDataManager
{
    self.dataSourceManager = [[GJGCChatGroupDataSourceManager alloc]initWithTalk:self.taklInfo withDelegate:self];
}

- (void)rightButtonPressed:(id)sender
{
//    GJGCGroupInformationViewController *groupInformation = [[GJGCGroupInformationViewController alloc]initWithGroupId:[self.taklInfo.toId longLongValue]];
//    [[GJGCUIStackManager share]pushViewController:groupInformation animated:YES];
    
    /* 收起输入键盘 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reserveChatInputPanelState];
    });
    
}

#pragma mark - 群聊的时候加个@功能

- (void)chatCellDidLongPressOnHeadView:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
    [self.inputPanel appendFocusOnOther:[NSString stringWithFormat:@"@%@",contentModel.senderName.string]];
    
}

/**
 *  点击新人欢迎card
 *
 *  @param tappedCell
 */
- (void)chatCellDidTapOnWelcomeMemberCard:(GJGCChatBaseCell *)tappedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tappedCell];
    GJGCChatFriendContentModel  *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
//    GJGCPersonInformationViewController *informationVC = [[GJGCPersonInformationViewController alloc]initWithUserId:[contentModel.userId longLongValue] reportType:GJGCReportTypePerson];
//    [[GJGCUIStackManager share]pushViewController:informationVC animated:YES];

}


@end
