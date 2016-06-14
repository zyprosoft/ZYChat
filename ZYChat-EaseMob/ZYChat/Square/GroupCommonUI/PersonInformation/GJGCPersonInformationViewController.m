//
//  GJGCPersonInformationViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/22.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCPersonInformationViewController.h"
#import "GJGCGroupPersonInformationShowMap.h"
#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatFriendViewController.h"
#import "GJGCRecentChatDataManager.h"

@interface GJGCPersonInformationViewController ()

@property (nonatomic,strong)GJGCMessageExtendUserModel *theUser;

@property (nonatomic,strong)NSString *theUserId;

@property (nonatomic,strong)UIImageView *bottomBarSeprateLine;

@property (nonatomic,strong)UIButton *joinChatButton;

@end

@implementation GJGCPersonInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"个人资料"];

    [self setupMyInformation];
}

- (instancetype)initWithExtendUser:(GJGCMessageExtendUserModel *)aUser withUserId:(NSString *)userId
{
    if (self = [super init]) {
        
        self.theUser = aUser;
        
        self.theUserId = [userId copy];
    }
    return self;
}

- (void)setupMyInformation
{
    if (!self.theUser) {
        return;
    }
    
    //展示群头像信息
    GJGCInformationCellContentModel *contentModel = [[GJGCInformationCellContentModel alloc]init];
    contentModel.baseContentType = GJGCInformationContentTypeGroupHeadInfo;
    contentModel.groupHeadUrl = self.theUser.headThumb;
    contentModel.groupName = self.theUser.nickName;
    contentModel.contentHeight = 164.f;
    
    [self.dataSourceManager addInformationItem:contentModel];
    
    /* 群账号 */
    if (self.theUserId) {
        
        GJGCInformationCellContentModel *accountItem = [GJGCGroupPersonInformationShowMap itemWithContentValueBaseText:self.theUserId tagName:@"账  号"];
        accountItem.topLineMargin = 13.f;
        accountItem.seprateStyle = GJGCInformationSeprateLineStyleTopFullBottomShort;
        
        [self.dataSourceManager addInformationItem:accountItem];
    }
    
    /* 群等级 */
    GJGCInformationCellContentModel *nicknameItem = nil;
    nicknameItem = [GJGCGroupPersonInformationShowMap itemWithTextAndIcon:self.theUser.nickName  icon:@"详细地址icon.png" tagName:@"昵  称"];
    [self.dataSourceManager addInformationItem:nicknameItem];
    
    /* 群等级 */
    GJGCInformationCellContentModel *levelItem = nil;
    levelItem = [GJGCGroupPersonInformationShowMap itemWithLevelValue:@"新手小白" tagName:@"等  级"];
    [self.dataSourceManager addInformationItem:levelItem];
    
    /* 群位置 */
    if (!GJCFStringIsNull(self.theUser.sex)) {
        
        NSString *sex = [self.theUser.sex integerValue] == 0? @"男":@"女";
        
        GJGCInformationCellContentModel *locationItem = [GJGCGroupPersonInformationShowMap itemWithTextAndIcon:sex  icon:@"详细地址icon.png" tagName:@"性  别"];
        locationItem.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomFull;
        locationItem.isIconShowMap = YES;
        [self.dataSourceManager addInformationItem:locationItem];
    }
    
    [self.informationListTable reloadData];
    
    
    if (![[[ZYUserCenter shareCenter] currentLoginUser].userId isEqualToString:self.theUserId]) {
        
        [self setupBottomBar];
    }
}

- (void)setupBottomBar
{
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
    [self.joinChatButton setTitle:@"开始聊天" forState:UIControlStateNormal];
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
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    talk.toId = self.theUserId;
    talk.toUserName = self.theUser.nickName;
    
    //如果有会话记录才插入这样一条会话，不然就什么都不做
    if ([GJGCRecentChatDataManager isConversationHasBeenExist:talk.toId]) {
        
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:talk.conversation.conversationId type:EMConversationTypeChat createIfNotExist:NO];
        talk.conversation = conversation;
        
    }
    
    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
    [self.navigationController pushViewController:privateChat animated:YES];
}

@end
