//
//  GJGCChatGroupViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatGroupViewController.h"
#import "GJGCChatGroupDataSourceManager.h"
#import "GJGCGroupInformationViewController.h"
#import "GJGCPersonInformationViewController.h"

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
    GJGCGroupInformationViewController *groupInformation = [[GJGCGroupInformationViewController alloc]initWithGroupId:self.taklInfo.toId];
    [self.navigationController pushViewController:groupInformation animated:YES];

    /* 收起输入键盘 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reserveChatInputPanelState];
    });
    
}

#pragma mark - 群聊的时候加个@功能

- (void)chatCellDidLongPressOnHeadView:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    
}

/**
 *  点击新人欢迎card
 *
 *  @param tappedCell
 */
- (void)chatCellDidTapOnWelcomeMemberCard:(GJGCChatBaseCell *)tappedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tappedCell];
    
}


@end
