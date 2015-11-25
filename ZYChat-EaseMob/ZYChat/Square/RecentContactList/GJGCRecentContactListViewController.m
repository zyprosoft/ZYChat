//
//  GJGCRecentContactListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCRecentContactListViewController.h"
#import "GJGCRecentContactListDataManager.h"
#import "GJGCMessageExtendGroupModel.h"
#import "GJGCMessageExtendContentWebPageModel.h"
#import "Base64.h"
#import "UIImage+Resize.h"
#import "GJGCMessageExtendMusicShareModel.h"

@interface GJGCRecentContactListViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong)GJGCRecentChatForwardContentModel *theContent;

@property (nonatomic,strong)NSIndexPath *selectIndex;

@end

@implementation GJGCRecentContactListViewController

- (instancetype)initWithForwardContent:(GJGCRecentChatForwardContentModel *)contentModel
{
    if (self = [super init]) {
        
        self.theContent = contentModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"发送给朋友"];
    
    [self setLeftButtonWithImageName:@"title-icon-向左返回" bgImageName:nil];

}

- (void)leftButtonPressed:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initDataManager
{
    self.dataManager = [[GJGCRecentContactListDataManager alloc]init];
    self.dataManager.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath;
    
    [self showAlertCheck];
}

- (void)showAlertCheck
{
    GJGCInfoBaseListContentModel *contentModel = [self.dataManager contentModelAtIndexPath:self.selectIndex];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否把内容发给: %@ ?",contentModel.title] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        GJGCInfoBaseListContentModel *contentModel = [self.dataManager contentModelAtIndexPath:self.selectIndex];
        
        [self sendMessageContentWithConversation:contentModel];
    }
}

- (void)sendMessageContentWithConversation:(GJGCInfoBaseListContentModel *)contentModel
{
    NSString *displayText = nil;
    switch (self.theContent.contentType) {
        case GJGCChatFriendContentTypeWebPage:
        {
            displayText = @"[网页]请更新代码以支持此类型消息显示";
        }
            break;
        case GJGCChatFriendContentTypeMusicShare:
        {
            displayText = @"[音乐]请更新代码以支持此类型消息显示";
        }
            break;
        default:
            break;
    }
    
    EMMessage *sendMessage = [self sendWebPageWithToUserId:contentModel.conversation.chatter withNotDisplayText:displayText];
    
    //添加用户扩展信息
    GJGCMessageExtendModel *extendInfo = [[GJGCMessageExtendModel alloc]init];
    extendInfo.userInfo = [[ZYUserCenter shareCenter]extendUserInfo];
    extendInfo.isExtendMessageContent = NO;
    
    //添加群组扩展信息
    if (contentModel.conversation.conversationType == eConversationTypeGroupChat) {
        
        GJGCMessageExtendGroupModel *groupInfo = [[GJGCMessageExtendGroupModel alloc]init];
        
        //是否有扩展信息
        groupInfo.groupName = contentModel.title;
        groupInfo.groupHeadThumb = contentModel.headUrl;
        
        extendInfo.isGroupMessage = YES;
        extendInfo.groupInfo = groupInfo;
    }

    //设置消息类型
    switch (contentModel.conversation.conversationType) {
        case eConversationTypeChat:
            sendMessage.messageType = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            sendMessage.messageType = eMessageTypeGroupChat;
            break;
        default:
            break;
    }
    
    switch (self.theContent.contentType) {
        case GJGCChatFriendContentTypeWebPage:
        {
            extendInfo.isExtendMessageContent = YES;
            
            GJGCMessageExtendContentWebPageModel *webpageModel = [[GJGCMessageExtendContentWebPageModel alloc]init];
            webpageModel.title = self.theContent.title;
            webpageModel.thumbImageBase64 = @"noimage.png";
            webpageModel.sumary = self.theContent.sumary;
            webpageModel.url = self.theContent.webUrl;
            webpageModel.displayText = self.theContent.title;
            
            extendInfo.chatFriendContentType = self.theContent.contentType;
            extendInfo.messageContent = webpageModel;
            
            sendMessage.ext = [extendInfo contentDictionary];
        }
            break;
        case GJGCChatFriendContentTypeMusicShare:
        {
            extendInfo.isExtendMessageContent = YES;

            GJGCMessageExtendMusicShareModel *musicModel = [[GJGCMessageExtendMusicShareModel alloc]init];
            musicModel.title = self.theContent.title;
            musicModel.songUrl = self.theContent.webUrl;
            musicModel.songId = self.theContent.songId;
            musicModel.author = self.theContent.sumary;
            musicModel.displayText = self.theContent.title;
            
            extendInfo.chatFriendContentType = self.theContent.contentType;
            extendInfo.messageContent = musicModel;
            
            sendMessage.ext = [extendInfo contentDictionary];

        }
            break;
        default:
            break;
    }
    
    [self.statusHUD showWithStatusText:@"正在发送..."];
    
    GJCFWeakSelf weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:sendMessage progress:nil prepare:^(EMMessage *message, EMError *error) {
        
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        
        [weakSelf.statusHUD dismiss];
        
        if (!error) {
            
            BTToast(@"已发送");
            
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            BTToast(@"发送失败");
        }
        
    } onQueue:nil];
    
    
}

- (EMMessage *)sendWebPageWithToUserId:(NSString *)toId withNotDisplayText:(NSString *)displayText
{
    NSString *notSupportDisplayText = displayText;
    EMChatText *chatText = [[EMChatText alloc]initWithText:notSupportDisplayText];
    EMTextMessageBody *messageBody = [[EMTextMessageBody alloc]initWithChatObject:chatText];
    EMMessage *aMessage = [[EMMessage alloc]initWithReceiver:toId bodies:@[messageBody]];
    
    return aMessage;
}

@end
