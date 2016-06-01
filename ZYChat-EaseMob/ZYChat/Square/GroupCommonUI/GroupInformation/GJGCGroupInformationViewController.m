//
//  GJGCGroupInformationViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/22.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCGroupInformationViewController.h"
#import "GJGCGroupInfoExtendModel.h"
#import "Base64.h"
#import "GJGCGroupPersonInformationShowMap.h"
#import "GJGCChatGroupViewController.h"
#import "GJGCGroupMemberListViewController.h"
#import "GJGCRecentChatDataManager.h"

@interface GJGCGroupInformationViewController ()

@property (nonatomic,strong)NSString *currentGroupId;

@property (nonatomic,strong)EMGroup *currentGroup;

@property (nonatomic,strong)UIButton *exitButton;

@property (nonatomic,strong)UIButton *joinChatButton;

@property (nonatomic,strong)UIButton *beginChatButton;

@property (nonatomic,strong)GJGCGroupInfoExtendModel *groupExtendInfo;

@property (nonatomic,strong)UIImageView *bottomBarSeprateLine;

@end

@implementation GJGCGroupInformationViewController

- (instancetype)initWithGroupId:(NSString *)groupId
{
    if (self = [super init]) {
        
        self.currentGroupId = [groupId copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStrNavTitle:@"群资料"];
    
    [self requestGroupInfo];
}

- (void)requestGroupInfo
{
    [self.statusHUD showWithStatusText:@"正在获取..."];
    
    GJCFWeakSelf weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:weakSelf.currentGroupId includeMembersList:YES error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"groupInfo:%@",group.debugDescription);
            
            [weakSelf.statusHUD dismiss];
            
            if (!error) {
                [weakSelf createInformationListWith:group];
            }
        });
    });
}

- (void)createInformationListWith:(EMGroup *)group
{
    self.currentGroup = group;
    
    NSData *extendData = [group.subject base64DecodedData];
    NSDictionary *extendDict = [NSKeyedUnarchiver unarchiveObjectWithData:extendData];
    
    GJGCGroupInfoExtendModel *groupInfoExtend = [[GJGCGroupInfoExtendModel alloc]initWithDictionary:extendDict error:nil];
    self.groupExtendInfo = groupInfoExtend;
    
    NSLog(@"groupExtendInfo:%@",groupInfoExtend);

    //展示群头像信息
    GJGCInformationCellContentModel *contentModel = [[GJGCInformationCellContentModel alloc]init];
    contentModel.baseContentType = GJGCInformationContentTypeGroupHeadInfo;
    contentModel.groupHeadUrl = groupInfoExtend.headUrl;
    contentModel.groupName = groupInfoExtend.name;
    contentModel.contentHeight = 86.f;
    
    [self.dataSourceManager addInformationItem:contentModel];
    
    /* 群账号 */
    if (group.groupId) {
        
        GJGCInformationCellContentModel *accountItem = [GJGCGroupPersonInformationShowMap itemWithContentValueBaseText:groupInfoExtend.name tagName:@"群  名  称"];
        accountItem.topLineMargin = 13.f;
        accountItem.seprateStyle = GJGCInformationSeprateLineStyleTopFullBottomShort;
        
        [self.dataSourceManager addInformationItem:accountItem];
    }
    
    /* 群名称 */
    GJGCInformationCellContentModel *nicknameItem = nil;
    nicknameItem = [GJGCGroupPersonInformationShowMap itemWithTextAndIcon:group.groupId  icon:@"详细地址icon.png" tagName:@"群  账  号"];
    [self.dataSourceManager addInformationItem:nicknameItem];
    
    /* 群等级 */
    GJGCInformationCellContentModel *levelItem = nil;
    if (groupInfoExtend.level) {
        
        levelItem = [GJGCGroupPersonInformationShowMap itemWithLevelValue:groupInfoExtend.level tagName:@"群  等  级"];
        
        [self.dataSourceManager addInformationItem:levelItem];
    }
    
    /* 群成员 */
    NSString *memberInfo = [NSString stringWithFormat:@"共%ld人",self.currentGroup.occupantsCount];
    GJGCInformationCellContentModel *memberItem = [GJGCGroupPersonInformationShowMap itemWithTextAndIcon:memberInfo icon:@"详细地址icon.png" tagName:@"群  成  员"];
    memberItem.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomShort;
    memberItem.isIconShowMap = YES;
    [self.dataSourceManager addInformationItem:memberItem];
    
    /* 群位置 */
    if (!GJCFStringIsNull(groupInfoExtend.address)) {
        
        GJGCInformationCellContentModel *locationItem = [GJGCGroupPersonInformationShowMap itemWithTextAndIcon:groupInfoExtend.address icon:@"详细地址icon.png" tagName:@"群  位  置"];
        locationItem.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomFull;
        locationItem.isIconShowMap = YES;
        [self.dataSourceManager addInformationItem:locationItem];
    }
    
    /* 群标签 */
    if (groupInfoExtend.labels) {
        
        GJGCInformationCellContentModel *labelItem = [GJGCGroupPersonInformationShowMap itemWithContentValueSummaryText:groupInfoExtend.labels tagName:@"群  标  签"];
        labelItem.topLineMargin = 13.f;
        labelItem.seprateStyle = GJGCInformationSeprateLineStyleTopFullBottomShort;
        
        [self.dataSourceManager addInformationItem:labelItem];
    }
    
    /* 创建时间 */
    GJGCInformationCellContentModel *createTimeItem = nil;
    if (groupInfoExtend.addTime) {
        
        createTimeItem = [GJGCGroupPersonInformationShowMap itemWithContentValueBaseText:groupInfoExtend.addTime tagName:@"创建时间"];
        
        [self.dataSourceManager addInformationItem:createTimeItem];
    }
    
    /* 群简介 */
    if (!GJCFStringIsNull(groupInfoExtend.simpleDescription)) {
        
        GJGCInformationCellContentModel *introducItem = [GJGCGroupPersonInformationShowMap itemWithContentValueSummaryText:groupInfoExtend.simpleDescription tagName:@"群  简  介"];
        introducItem.baseLineMargin = 13.f;
        introducItem.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomFull;
        
        [self.dataSourceManager addInformationItem:introducItem];
        
    }
    
    [self.informationListTable reloadData];
    
    [self initBottomBar];
}

- (void)initBottomBar
{
    self.informationListTable.showsHorizontalScrollIndicator = NO;
    self.informationListTable.showsVerticalScrollIndicator = NO;
    
    NSArray *myGroupList = [[EMClient sharedClient].groupManager getAllGroups];
    
    BOOL isMyGroup = NO;
    for (EMGroup *existGroup in myGroupList) {
        
        if ([existGroup.groupId isEqualToString:self.currentGroupId]) {
            isMyGroup = YES;break;
        }
    }
    
    if (isMyGroup) {
        
        [self setupGroupIsMember];
        
    }else{
        
        [self setupGroupNotMember];
    }
    
}

- (void)setupGroupIsMember
{
    if (self.joinChatButton) {
        [self.joinChatButton removeFromSuperview];
    }
    
    if (!self.bottomBarSeprateLine) {
        self.bottomBarSeprateLine = [[UIImageView alloc]init];
        self.bottomBarSeprateLine.gjcf_height = 0.5f;
        self.bottomBarSeprateLine.gjcf_width = GJCFSystemScreenWidth;
        self.bottomBarSeprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.view addSubview:self.bottomBarSeprateLine];
        self.bottomBarSeprateLine.gjcf_bottom = GJCFSystemScreenHeight - 64 - 46.f;
    }
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitButton.gjcf_width = GJCFSystemScreenWidth*1/3;
    self.exitButton.gjcf_height = 32.f;
    [self.exitButton setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], self.exitButton.gjcf_size) forState:UIControlStateNormal];
    [self.exitButton setTitle:@"退出群组" forState:UIControlStateNormal];
    [self.exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.exitButton.layer.cornerRadius = 4.f;
    self.exitButton.layer.masksToBounds = YES;
    self.exitButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    [self.exitButton addTarget:self action:@selector(exitGroupAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.exitButton];

    self.beginChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginChatButton.gjcf_width = GJCFSystemScreenWidth*1/3;
    self.beginChatButton.gjcf_height = 32.f;
    [self.beginChatButton setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], self.exitButton.gjcf_size) forState:UIControlStateNormal];
    [self.beginChatButton setTitle:@"开始聊天" forState:UIControlStateNormal];
    [self.beginChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.beginChatButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    self.beginChatButton.layer.cornerRadius = 4.f;
    self.beginChatButton.layer.masksToBounds = YES;
    [self.beginChatButton addTarget:self action:@selector(beginChatAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.beginChatButton];

    CGFloat margin = (GJCFSystemScreenWidth - GJCFSystemScreenWidth *2/3)/3;
    
    self.exitButton.gjcf_left = margin;
    self.beginChatButton.gjcf_left = self.exitButton.gjcf_right + margin;
    self.exitButton.gjcf_centerY = GJCFSystemScreenHeight - 64 - 32/2 - 6;
    self.beginChatButton.gjcf_centerY = self.exitButton.gjcf_centerY;
}

- (void)setupGroupNotMember
{
    if (self.exitButton && self.beginChatButton) {
        [self.exitButton removeFromSuperview];
        [self.beginChatButton removeFromSuperview];
    }
    
    if (!self.bottomBarSeprateLine) {
        self.bottomBarSeprateLine = [[UIImageView alloc]init];
        self.bottomBarSeprateLine.gjcf_height = 0.5f;
        self.bottomBarSeprateLine.gjcf_width = GJCFSystemScreenWidth;
        self.bottomBarSeprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.view addSubview:self.bottomBarSeprateLine];
        self.bottomBarSeprateLine.gjcf_bottom = GJCFSystemScreenHeight - 64 - 46.f;
    }
    
    self.joinChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.joinChatButton.gjcf_width = GJCFSystemScreenWidth*1/3;
    self.joinChatButton.gjcf_height = 32.f;
    [self.joinChatButton setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], self.joinChatButton.gjcf_size) forState:UIControlStateNormal];
    [self.joinChatButton setTitle:@"加入群组" forState:UIControlStateNormal];
    [self.joinChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.joinChatButton.layer.cornerRadius = 4.f;
    self.joinChatButton.layer.masksToBounds = YES;
    [self.joinChatButton addTarget:self action:@selector(joinGroupAction) forControlEvents:UIControlEventTouchUpInside];
    self.joinChatButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    self.joinChatButton.gjcf_centerX = GJCFSystemScreenWidth/2;
    self.joinChatButton.gjcf_centerY = GJCFSystemScreenHeight - 64 - 32/2 - 6;
    
    [self.view addSubview:self.joinChatButton];
}

- (void)joinGroupAction
{
    [self.statusHUD showWithStatusText:@"正在申请..."];
    
    if (self.currentGroup.isPublic) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            [[EMClient sharedClient].groupManager joinPublicGroup:self.currentGroupId error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.statusHUD dismiss];
                if (!error) {
                    BTToast(@"加入成功");
                    
                    [self setupGroupIsMember];
                }
            });
        });
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            [[EMClient sharedClient].groupManager applyJoinPublicGroup:self.currentGroup.groupId message:@"想要加入" error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }
}

- (void)exitGroupAction
{
    [self.statusHUD showWithStatusText:@"正在退出..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient].groupManager leaveGroup:self.currentGroupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                
                BTToast(@"退出成功");
                
                [self setupGroupNotMember];
            }
        });
    });
}

- (void)beginChatAction
{
    GJGCChatFriendTalkModel *talkModel = [[GJGCChatFriendTalkModel alloc]init];
    talkModel.toId = self.currentGroupId;
    talkModel.toUserName = self.groupExtendInfo.name;
    talkModel.talkType = GJGCChatFriendTalkTypeGroup;
    talkModel.groupInfo.groupHeadThumb = self.groupExtendInfo.headUrl;
    talkModel.groupInfo.groupName = self.groupExtendInfo.name;
    
    //如果有会话记录才插入这样一条会话，不然就什么都不做
    if ([GJGCRecentChatDataManager isConversationHasBeenExist:talkModel.toId]) {
        
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:talkModel.toUserName type:EMConversationTypeGroupChat createIfNotExist:YES];
        talkModel.conversation = conversation;
        
    }
    
    GJGCChatGroupViewController *groupChat =  [[GJGCChatGroupViewController alloc]initWithTalkInfo:talkModel];
    
    [self.navigationController pushViewController:groupChat animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCInformationCellContentModel *contentModel = (GJGCInformationCellContentModel *)[self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    if ([contentModel.tag.string isEqualToString:@"群  成  员"]) {
        
        GJGCGroupMemberListViewController *memberListVC = [[GJGCGroupMemberListViewController alloc]init];
        memberListVC.groupId = self.currentGroupId;
        
        [self.navigationController pushViewController:memberListVC animated:YES];
    }
}

@end
