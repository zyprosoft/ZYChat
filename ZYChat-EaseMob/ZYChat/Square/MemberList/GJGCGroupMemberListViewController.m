//
//  GJGCGroupMemberListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCGroupMemberListViewController.h"
#import "GJGCGroupMemberListDataManager.h"
#import "GJGCChatFriendViewController.h"
#import "GJGCRecentChatDataManager.h"
#import "GJGCPersonInformationViewController.h"

@interface GJGCGroupMemberListViewController ()

@end

@implementation GJGCGroupMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"群成员列表"];

}

- (void)setGroupId:(NSString *)groupId
{
    [(GJGCGroupMemberListDataManager *)self.dataManager setGroupId:groupId];
}

- (NSString *)groupId
{
    return [(GJGCGroupMemberListDataManager *)self.dataManager groupId];
}

- (void)initDataManager
{
    self.dataManager = [[GJGCGroupMemberListDataManager alloc]init];
    self.dataManager.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCInfoBaseListContentModel *contentModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    GJGCChatFriendTalkModel *talkModel = [[GJGCChatFriendTalkModel alloc]init];
    talkModel.talkType = GJGCChatFriendTalkTypePrivate;
    talkModel.toId = contentModel.title;
    talkModel.toUserName = contentModel.title;
    
    EMMessage *message = [talkModel.conversation latestMessageFromOthers];
    if (message) {
        //普通文本消息和依靠普通文本消息扩展出来的消息类型
        GJGCMessageExtendModel *extendModel = [[GJGCMessageExtendModel alloc]initWithDictionary:message.ext];
        GJGCPersonInformationViewController *personVC = [[GJGCPersonInformationViewController alloc]initWithExtendUser:extendModel.userInfo withUserId:message.from];
        [self.navigationController pushViewController:personVC animated:YES];
        return;
    }
    
    
}

@end
