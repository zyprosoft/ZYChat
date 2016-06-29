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

@property (nonatomic,strong)UIButton *exitButton;

@property (nonatomic,strong)UIButton *joinChatButton;

@property (nonatomic,strong)UIButton *beginChatButton;

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
    NSArray *myContacts = [[EMClient sharedClient].contactManager getContacts];
    if (myContacts.count == 0) {
        [self setupUserNotFriend];
        return;
    }
    
     __block BOOL isMyFriend = NO;
    [myContacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([(NSString *)obj isEqualToString:self.theUserId]){
            isMyFriend = YES;
            *stop = YES;
        }
        
    }];
    
    if (isMyFriend) {
        [self setupUserIsFriend];
    }else{
        [self setupUserNotFriend];
    }
}

- (void)setupUserIsFriend
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
    [self.exitButton setTitle:@"解除关系" forState:UIControlStateNormal];
    [self.exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.exitButton.layer.cornerRadius = 4.f;
    self.exitButton.layer.masksToBounds = YES;
    self.exitButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    [self.exitButton addTarget:self action:@selector(deleteContactAction) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)setupUserNotFriend
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
    [self.exitButton setTitle:@"打招呼" forState:UIControlStateNormal];
    [self.exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.exitButton.layer.cornerRadius = 4.f;
    self.exitButton.layer.masksToBounds = YES;
    self.exitButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    [self.exitButton addTarget:self action:@selector(beginChatAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.exitButton];
    
    self.beginChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginChatButton.gjcf_width = GJCFSystemScreenWidth*1/3;
    self.beginChatButton.gjcf_height = 32.f;
    [self.beginChatButton setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], self.exitButton.gjcf_size) forState:UIControlStateNormal];
    [self.beginChatButton setTitle:@"加为好友" forState:UIControlStateNormal];
    [self.beginChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.beginChatButton.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    self.beginChatButton.layer.cornerRadius = 4.f;
    self.beginChatButton.layer.masksToBounds = YES;
    [self.beginChatButton addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.beginChatButton];
    
    CGFloat margin = (GJCFSystemScreenWidth - GJCFSystemScreenWidth *2/3)/3;
    
    self.exitButton.gjcf_left = margin;
    self.beginChatButton.gjcf_left = self.exitButton.gjcf_right + margin;
    self.exitButton.gjcf_centerY = GJCFSystemScreenHeight - 64 - 32/2 - 6;
    self.beginChatButton.gjcf_centerY = self.exitButton.gjcf_centerY;
}

- (void)deleteContactAction
{
    [self.statusHUD showWithStatusText:@"正在解除..."];
    [[EMClient sharedClient].contactManager asyncDeleteContact:self.theUserId success:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statusHUD dismiss];
            [self setupUserNotFriend];
        });
        BTToast(@"解除成功");
        
    } failure:^(EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statusHUD dismiss];
        });
    }];
}

- (void)beginChatAction
{
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    talk.toId = self.theUserId;
    talk.toUserName = self.theUser.nickName;
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.theUserId type:EMConversationTypeChat createIfNotExist:YES];
    talk.conversation = conversation;
    
    GJGCChatFriendViewController *chatVC = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)addContactAction
{
    [self.statusHUD showWithStatusText:@"正在申请..."];
    [[EMClient sharedClient].contactManager asyncAddContact:self.theUserId message:@"申请加你为好友" success:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statusHUD dismiss];
        });
        BTToast(@"申请成功");
        
    } failure:^(EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statusHUD dismiss];
        });
    }];
}

@end
