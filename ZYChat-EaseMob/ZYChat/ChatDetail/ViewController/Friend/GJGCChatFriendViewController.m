//
//  GJGCChatFriendViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendViewController.h"
#import "GJCFAudioPlayer.h"
#import "GJGCChatFriendAudioMessageCell.h"
#import "GJGCChatFriendImageMessageCell.h"
#import "GJCUImageBrowserNavigationViewController.h"
#import "UIImage+GJFixOrientation.h"
#import "GJGCChatContentEmojiParser.h"
#import "GJGCPersonInformationViewController.h"
#import "GJCUCaptureViewController.h"
#import "GJCFUitils.h"
#import "GJGCGIFLoadManager.h"
#import "GJGCChatFriendGifCell.h"
#import "GJGCDrfitBottleDetailViewController.h"
#import "GJGCChatFriendDriftBottleCell.h"
#import "GJCFAssetsPickerViewControllerDelegate.h"
#import "GJGCWebViewController.h"
#import "GJCFAssetsPickerViewController.h"
#import "GJGCWebHostListViewController.h"
#import "GJGCMusicPlayViewController.h"
#import "GJGCAppWallViewController.h"
#import "GJGCVideoPlayerViewController.h"
#import "GJGCChatFriendVideoCell.h"
#import "GJGCChatFriendMusicShareCell.h"
#import "GJGCRecentContactListViewController.h"
#import "WechatShortVideoController.h"
#import "GJGCVideoPlayerViewController.h"
#import "AppDelegate.h"
#import "GJGCVoiceCallViewController.h"
#import "GJGCVideoCallViewController.h"
#import "GJGCMusicSharePlayer.h"
#import "GJGCMusicPlayingViewController.h"

#define GJGCActionSheetCallPhoneNumberTag 132134

#define GJGCActionSheetShowMyFavoritePost 132135

static NSString * const GJGCActionSheetAssociateKey = @"GJIMSimpleCellActionSheetAssociateKey";

@interface GJGCChatFriendViewController ()<
                                            GJCFAudioPlayerDelegate,
                                            UIImagePickerControllerDelegate,
                                            UINavigationControllerDelegate,
                                            GJCFAssetsPickerViewControllerDelegate,
                                            GJCUCaptureViewControllerDelegate,
                                            GJGCVideoPlayerViewControllerDelegate,
                                            WechatShortVideoDelegate,EMCallManagerDelegate
                                          >

@property (nonatomic,strong)NSString *playingAudioMsgId;

@property (nonatomic,assign)NSInteger lastPlayedAudioMsgIndex;

@property (nonatomic,assign)BOOL isLastPlayedMyAudio;

@property (nonatomic,strong)UILabel *sendLimitTipLabel;


/*
 *  拨打电话webview
 */
@property (nonatomic,strong) UIWebView *callWebview;

@end

@implementation GJGCChatFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setRightButtonWithStateImage:@"title-icon-个人资料" stateHighlightedImage:nil stateDisabledImage:nil titleName:nil];
    
    [self setupMusicBar];
    
    if ([GJGCMusicSharePlayer sharePlayer].musicMsgId.length > 0 && [[GJGCMusicSharePlayer sharePlayer].musicChatId isEqualToString:self.taklInfo.conversation.conversationId]) {
        self.playingAudioMsgId = [GJGCMusicSharePlayer sharePlayer].musicMsgId;
    }
    
    [self setStrNavTitle:self.dataSourceManager.title];
    
//    [self.inputPanel setLastMessageDraft:messageDraft];
    
    /* 陌生人不可发语音 */
    if (self.dataSourceManager.taklInfo.talkType == GJGCChatFriendTalkTypePrivate) {
        
        if ([(GJGCChatFriendDataSourceManager *)self.dataSourceManager isMyFriend] == NO) {
            
            self.inputPanel.disableActionType = GJGCChatInputBarActionTypeRecordAudio;
            
        }
    }

    /* 观察录音工具开始录音 */
    NSString *formateNoti = [GJGCChatInputConst panelNoti:GJGCChatInputPanelBeginRecordNoti formateWithIdentifier:self.inputPanel.panelIndentifier];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeChatInputPanelBeginRecord:) name:formateNoti object:nil];
    [GJCFNotificationCenter addObserver:self selector:@selector(observeApplicationResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[EMClient sharedClient].callManager removeDelegate:self];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
}

-(void)dealloc{
    [[EMClient sharedClient].callManager removeDelegate:self];
}

#pragma mark - 应用程序事件

- (void)observeApplicationResignActive:(NSNotification *)noti
{
    [self stopPlayCurrentAudio];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[GJGCMusicSharePlayer sharePlayer] shouldStopPlay];
    [[GJGCMusicSharePlayer sharePlayer] removePlayObserver:self];
    [[GJGCMusicSharePlayer sharePlayer] removePlayObserver:self.musicBar];
    [self.inputPanel removeKeyboardObserve];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[GJGCMusicSharePlayer sharePlayer] addPlayObserver:self.musicBar];
    [[GJGCMusicSharePlayer sharePlayer] addPlayObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.inputPanel startKeyboardObserve];
    
    if ([GJGCMusicSharePlayer sharePlayer].audioPlayer.isPlaying) {
        [self.musicBar startMove];
    }
}

- (void)rightButtonPressed:(id)sender
{
//    GJGCPersonInformationViewController *personInformation = [[GJGCPersonInformationViewController alloc]initWithUserId:[self.taklInfo.toId longLongValue] reportType:GJGCReportTypePerson];
//    [[GJGCUIStackManager share]pushViewController:personInformation animated:YES];
//    
    /* 收起输入键盘 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reserveChatInputPanelState];
    });
}

#pragma mark - 观察输入工具开始录音的通知

- (void)observeChatInputPanelBeginRecord:(NSNotification *)noti
{
    [self stopPlayCurrentAudio];
}

#pragma mark - 内部初始化

- (void)initDataManager
{
    NSLog(@"self.talkInfo.toId:%@",self.taklInfo.toId);
    self.dataSourceManager = [[GJGCChatFriendDataSourceManager alloc]initWithTalk:self.taklInfo withDelegate:self];
    
}

#pragma mark - DataSourceManager Delegate

- (void)dataSourceManagerRequireChangeAudioRecordEnableState:(GJGCChatDetailDataSourceManager *)dataManager state:(BOOL)enable
{
    if (enable) {
        self.inputPanel.disableActionType = GJGCChatInputBarActionTypeNone;
    }else{
        self.inputPanel.disableActionType = GJGCChatInputBarActionTypeRecordAudio;
    }
}

- (void)dataSourceManagerRequireAutoPlayNextAudioAtIndex:(NSInteger)index
{
    
}

#pragma mark - tableViewDelegate 重载
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - GJCFAudioPlayer Delegate
- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didFinishPlayAudio:(GJCFAudioModel *)audioFile
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self stopPlayCurrentAudio];
        
        if (self.musicBar) {
            [self.musicBar removeFromSuperview];
        }
        
        [self checkNextAudioMsgToPlay];
        
    });
}

- (void)checkNextAudioMsgToPlay
{
    NSInteger nextWaitPlayAudioIndex = NSNotFound;
    NSString *nextPlayMsgId = nil;
    
    NSInteger lastPlayIndex = self.lastPlayedAudioMsgIndex;
    
    /**
     *  没有可以播放的消息了
     */
    if (lastPlayIndex == [self.dataSourceManager totalCount] -1) {
        return;
    }

    //是自己的但是接下来还是自己的，那么停止播放
    if(self.isLastPlayedMyAudio){
        
        GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:lastPlayIndex + 1];

        if(contentModel.isFromSelf){
            return;
        }
        
    }
    
    while (lastPlayIndex < [self.dataSourceManager totalCount] -1) {
        
        lastPlayIndex ++ ;
        GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:lastPlayIndex];
        
        if (contentModel.contentType == GJGCChatFriendContentTypeAudio && !contentModel.isFromSelf) {
            
            if (contentModel.isRead) {
                
                
            }else{
                
                nextWaitPlayAudioIndex = lastPlayIndex;
                nextPlayMsgId = contentModel.localMsgId;
                
            }
            
            break;
        }
    }
    
    /**
     *  找到下一个可播放的语音继续播放
     */
    if (nextWaitPlayAudioIndex != NSNotFound) {
        
        self.playingAudioMsgId = nextPlayMsgId;
        
        [self startPlayCurrentAudio];
        
    }
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didOccusError:(NSError *)error
{
    NSLog(@"play error:%@",error);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self stopPlayCurrentAudio];

    });

}
- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didUpdateSoundMouter:(CGFloat)soundMouter
{
    /* 操作过快屏蔽 */
    if (self.playingAudioMsgId.length == 0) {
        return;
    }
    
    NSInteger playingIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:self.playingAudioMsgId];
    
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:playingIndex];
    
    if (contentModel.contentType == GJGCChatFriendContentTypeMusicShare) {
        
        GJGCChatFriendMusicShareCell *cell = (GJGCChatFriendMusicShareCell *)[self.chatListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:playingIndex inSection:0]];
        
        [cell updateMeter:soundMouter];
    }
}

#pragma mark - 文件下载处理

- (void)finishDownloadWithTask:(GJCFFileDownloadTask *)task withDownloadFileData:(NSData *)fileData
{
    [super finishDownloadWithTask:task withDownloadFileData:fileData];
    
    NSDictionary *userInfo = task.userInfo;
    
    NSString *taskType = userInfo[@"type"];
    
    if ([taskType isEqualToString:@"music"]) {
        
        [self startPlayCurrentAudio];
    }
    
}

- (void)downloadFileWithTask:(GJCFFileDownloadTask *)task progress:(CGFloat)progress
{
    [super downloadFileWithTask:task progress:progress];
    
    NSDictionary *userInfo = task.userInfo;
    
    NSString *taskType = userInfo[@"type"];
        
    if ([taskType isEqualToString:@"music"]) {
        
        NSLog(@"download music progess :%f",progress);
    }
}

- (void)faildDownloadFileWithTask:(GJCFFileDownloadTask *)task
{
    [super faildDownloadFileWithTask:task];
    
    NSDictionary *userInfo = task.userInfo;
    
    NSString *taskType = userInfo[@"type"];
    
    NSString *msgId = userInfo[@"msgId"];
    
    if ([taskType isEqualToString:@"music"]) {
        
        
    }
}

#pragma mark - GJGCChatBaseCellDelegate

- (void)audioMessageCellDidTap:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *indexPath = [self.chatListTable indexPathForCell:tapedCell];
    
    // 如果点击的是自己，那么停止了就不往下走了。如果
    GJGCChatContentBaseModel *contentModel = [self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    if ( self.playingAudioMsgId && [self.playingAudioMsgId isEqualToString:contentModel.localMsgId] && [GJGCMusicSharePlayer sharePlayer].audioPlayer.isPlaying) {
        
        [self stopPlayCurrentAudio];
        
        self.playingAudioMsgId = nil;
        
        return;
    }
    
    [self stopPlayCurrentAudio];
    self.playingAudioMsgId = contentModel.localMsgId;
    
    [self startPlayCurrentAudio];
}

- (void)videoMessageCellDidTap:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tappIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tappIndexPath.row];
    GJGCVideoPlayerViewController *player = [[GJGCVideoPlayerViewController alloc]initWithDelegate:self withVideoUrl:contentModel.videoUrl];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:player];
    [nav.navigationBar setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], nav.navigationBar.gjcf_size) forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)imageMessageCellDidTap:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *indexPath = [self.chatListTable indexPathForCell:tapedCell];
    
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    EMMessage *tappedMessage = contentModel.message;
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSInteger currentImageIndex = 0;
    
    for (int i = 0; i < [self.dataSourceManager totalCount]; i++) {
        
        GJGCChatFriendContentModel *itemModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:i];
        
        if (itemModel.contentType == GJGCChatFriendContentTypeImage) {
            
            EMMessage *imageMessage = itemModel.message;

            NSLog(@"imageMessageBody:%@",imageMessage);
            
            [imageUrls addObject:imageMessage.body];

            if ([imageMessage.messageId isEqualToString:tappedMessage.messageId]) {
                
                currentImageIndex = imageUrls.count - 1;
                
            }
        }
        
    }
    
    /* 进入大图浏览模式 */
    GJCUImageBrowserNavigationViewController *imageBrowser = [[GJCUImageBrowserNavigationViewController alloc]initWithEaseImageMessageBodys:imageUrls];
    imageBrowser.pageIndex = currentImageIndex;
    [self presentViewController:imageBrowser animated:YES completion:nil];
}

- (void)textMessageCellDidTapOnPhoneNumber:(GJGCChatBaseCell *)tapedCell withPhoneNumber:(NSString *)phoneNumber
{
    NSString *title = [NSString stringWithFormat:@"%@可能是一个电话号码，你可以",phoneNumber];
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"呼叫",@"复制",nil];
    action.tag = GJGCActionSheetCallPhoneNumberTag;
    objc_setAssociatedObject(action, &GJGCActionSheetAssociateKey, phoneNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [action showInView:self.view];    
}

- (void)textMessageCellDidTapOnUrl:(GJGCChatBaseCell *)tapedCell withUrl:(NSString *)url
{    
    GJGCWebViewController *webView = [[GJGCWebViewController alloc]initWithUrl:url];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)chatCellDidTapOnWebPage:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];

    GJGCWebViewController *webView = [[GJGCWebViewController alloc]initWithUrl:contentModel.webPageUrl];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)chatCellDidTapOnMusicShare:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];

    [self stopPlayCurrentAudio];
    
    GJGCMusicPlayViewController *musicVC = [[GJGCMusicPlayViewController alloc]initWithSongId:contentModel.musicSongId];
    [self.navigationController pushViewController:musicVC animated:YES];
}

- (void)chatCellDidTapOnMusicSharePlayButton:(GJGCChatBaseCell *)tapedCell
{
    [self audioMessageCellDidTap:tapedCell];
}

- (void)chatCellDidChooseDeleteMessage:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];

    /* 下载任务也要退出 */
    [self cancelDownloadAtIndexPath:tapIndexPath];
    
    /* 停止播放语音 */
    [self stopPlayCurrentAudio];
    
    NSArray *willDeletePaths = [self.dataSourceManager deleteMessageAtIndex:tapIndexPath.row];
    
    if (willDeletePaths && willDeletePaths.count > 0) {
        
        if (contentModel.isFromSelf) {
            [self.chatListTable deleteRowsAtIndexPaths:willDeletePaths withRowAnimation:UITableViewRowAnimationRight];
        }else{
            [self.chatListTable deleteRowsAtIndexPaths:willDeletePaths withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (void)chatCellDidChooseReSendMessage:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
    [self.dataSourceManager reSendMesssage:contentModel];
}

- (void)chatCellDidTapOnHeadView:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    
    GJGCChatFriendContentModel  *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
    EMMessage *theMessage = contentModel.message;
    
    GJGCMessageExtendModel *messageExtendModey = [[GJGCMessageExtendModel alloc]initWithDictionary:theMessage.ext];
    
    GJGCPersonInformationViewController *informationVC = [[GJGCPersonInformationViewController alloc]initWithExtendUser:messageExtendModey.userInfo withUserId:messageExtendModey.userInfo.userName];
    
    [self.navigationController pushViewController:informationVC animated:YES];
}

- (void)chatCellDidTapOnDriftBottleCard:(GJGCChatBaseCell *)tappedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tappedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];

    GJGCChatFriendDriftBottleCell *driftCell = (GJGCChatFriendDriftBottleCell *)tappedCell;
    
    GJGCDrfitBottleDetailViewController *driftVC = [[GJGCDrfitBottleDetailViewController alloc]initWithThumbImage:driftCell.contentImageView.image withImageUrl:contentModel.imageMessageUrl withContentString:contentModel.driftBottleContentString.string];
    [self.navigationController pushViewController:driftVC animated:YES];
}

#pragma mark UIActionSheet methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag ==  GJGCActionSheetCallPhoneNumberTag) {
        
        switch (buttonIndex) {
            case 0:
            {
                NSString *phoneNumber = objc_getAssociatedObject(actionSheet, &GJGCActionSheetAssociateKey);
                
                [self makePhoneCall:phoneNumber];
                
                objc_removeAssociatedObjects(actionSheet);
                
            }
                break;
            case 1:
            {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                NSString *phoneNumber = objc_getAssociatedObject(actionSheet, &GJGCActionSheetAssociateKey);
                [pasteboard setString:phoneNumber];
                objc_removeAssociatedObjects(actionSheet);
                
            }
                break;
                
            default:
                break;
        }

        return;
    }
}

#pragma mark - 打电话

- (void)makePhoneCall:(NSString *)phoneNumber
{
    if (!self.callWebview) {
        self.callWebview = [[UIWebView alloc] initWithFrame:CGRectZero];
        
    }
    NSURL * url =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
    
    /* 是否支持拨打电话 */
    if (!GJCFSystemCanMakePhoneCall) {
        return;
    }
    
    [self.callWebview loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - 语音播放

- (void)downloadAndPlayAudioAtRowIndex:(NSIndexPath *)rowIndex
{
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:rowIndex.row];
    
    [GJCFAudioFileUitil setupAudioFileTempEncodeFilePath:contentModel.audioModel];
    
    contentModel.audioModel.isDeleteWhileFinishConvertToLocalFormate  = YES;
    
    if (!contentModel.audioModel.localStorePath) {
        
        contentModel.audioModel.localStorePath = [[GJCFCachePathManager shareManager]mainAudioCacheFilePathForUrl:contentModel.audioModel.localStorePath];
        
    }
    
    GJCFWeakSelf weakSelf = self;
    [[EMClient sharedClient].chatManager asyncDownloadMessageAttachments:contentModel.message progress:^(int progress) {
        
        
    } completion:^(EMMessage *message, EMError *error) {
        
        BOOL isSuccess = error? NO:YES;
        
        [weakSelf downloadFileCompletionForMessage:message successState:isSuccess];
        
    }];

}

- (void)downloadAndPlayMusicAtRowIndex:(NSIndexPath *)rowIndex
{
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:rowIndex.row];
    
    GJCFFileDownloadTask *task = [GJCFFileDownloadTask taskWithDownloadUrl:contentModel.musicSongUrl withCachePath:contentModel.audioModel.localStorePath withObserver:self getTaskIdentifer:nil];
    task.userInfo = @{@"type":@"music"};
    
    [self addDownloadTask:task];
}

- (void)startPlayCurrentAudio
{
    /* 操作过快屏蔽 */
    if (!self.playingAudioMsgId) {
        return;
    }
    
    NSInteger playingIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:self.playingAudioMsgId];
    
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:playingIndex];
    
    NSString *localStorePath = contentModel.audioModel.localStorePath;

    NSIndexPath *playingIndexPath = [NSIndexPath indexPathForRow:playingIndex inSection:0];
    if (GJCFFileIsExist(localStorePath)) {
        
        //播放歌曲
        [GJGCMusicSharePlayer sharePlayer].musicSongName = contentModel.musicSongName;
        [GJGCMusicSharePlayer sharePlayer].musicSongUrl = contentModel.musicSongUrl;
        [GJGCMusicSharePlayer sharePlayer].musicSongAuthor = contentModel.musicSongAuthor;
        [GJGCMusicSharePlayer sharePlayer].musicSongId = contentModel.musicSongId;
        [GJGCMusicSharePlayer sharePlayer].musicSongImgUrl = contentModel.musicSongImgUrl;
        if (contentModel.contentType == GJGCChatFriendContentTypeMusicShare) {
            [GJGCMusicSharePlayer sharePlayer].musicMsgId = contentModel.localMsgId;
            [GJGCMusicSharePlayer sharePlayer].musicChatId = self.taklInfo.conversation.conversationId;
        }else{
            [GJGCMusicSharePlayer sharePlayer].musicMsgId = nil;
            [GJGCMusicSharePlayer sharePlayer].musicChatId = nil;
        }
        
        [[GJGCMusicSharePlayer sharePlayer].audioPlayer playAudioFile:contentModel.audioModel];
        contentModel.isPlayingAudio = YES;
        contentModel.isRead = YES;
        self.isLastPlayedMyAudio = contentModel.isFromSelf;
        [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:contentModel atIndex:playingIndex];
        
        [self setupMusicBar];//音乐播放条

        //音乐和语音区分
        switch (contentModel.contentType) {
            case GJGCChatFriendContentTypeAudio:
            {
                GJGCChatFriendAudioMessageCell *playingCell = (GJGCChatFriendAudioMessageCell *)[self.chatListTable cellForRowAtIndexPath:playingIndexPath];
                [playingCell playAudioAction];
            }
            break;
            case GJGCChatFriendContentTypeMusicShare:
            {
                GJGCChatFriendMusicShareCell *playingCell = (GJGCChatFriendMusicShareCell *)[self.chatListTable cellForRowAtIndexPath:playingIndexPath];
                [playingCell playAudioAction];
            }
            break;
            default:
            break;
        }
        
        return;
        
    }

    /* 加载下载转圈等待特效 */
    GJGCChatFriendContentModel *friendContentModel = (GJGCChatFriendContentModel *)contentModel;
    friendContentModel.isDownloading = YES;
    [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:friendContentModel atIndex:playingIndex];
    
    //分情况，音乐或者语音播放
    switch (friendContentModel.contentType) {
        case GJGCChatFriendContentTypeAudio:
        {
            GJGCChatFriendAudioMessageCell *playingCell = (GJGCChatFriendAudioMessageCell *)[self.chatListTable cellForRowAtIndexPath:playingIndexPath];
            [playingCell startDownloadAction];
            
            [self downloadAndPlayAudioAtRowIndex:playingIndexPath];
        }
        break;
        case GJGCChatFriendContentTypeMusicShare:
        {
            GJGCChatFriendMusicShareCell *playingCell = (GJGCChatFriendMusicShareCell *)[self.chatListTable cellForRowAtIndexPath:playingIndexPath];
            [playingCell startDownloadAction];
            
            [self downloadAndPlayMusicAtRowIndex:playingIndexPath];
        }
        break;
        default:
        break;
    }
}

- (void)stopPlayCurrentAudio
{
    if ([GJGCMusicSharePlayer sharePlayer].audioPlayer.isPlaying) {
        [[GJGCMusicSharePlayer sharePlayer].audioPlayer stop];
    }
    
    if (self.playingAudioMsgId) {
        
        NSInteger playingIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:self.playingAudioMsgId];
        self.lastPlayedAudioMsgIndex = playingIndex;
        
        if (playingIndex != NSNotFound) {
            
            GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:playingIndex];
            contentModel.isPlayingAudio = NO;
            contentModel.isDownloading = NO;
            
            [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:contentModel atIndex:playingIndex];
            self.playingAudioMsgId = nil;
            
            NSIndexPath *playingIndexPath = [NSIndexPath indexPathForRow:playingIndex inSection:0];
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:playingIndexPath]) {
                
                [self.chatListTable reloadRowsAtIndexPaths:@[playingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
    }
}

#pragma mark - 图片下载
- (void)downloadImageFile:(GJGCChatContentBaseModel *)contentModel forIndexPath:(NSIndexPath *)indexPath
{
    GJGCChatFriendContentModel *imageContentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    //gif 表情下载
    if (imageContentModel.contentType == GJGCChatFriendContentTypeGif) {
        
        [self downloadGifFile:imageContentModel forIndexPath:indexPath];
        
        return;
    }
    
    //短视频截图
    if (imageContentModel.contentType == GJGCChatFriendContentTypeLimitVideo) {
        
        EMVideoMessageBody *imageMessageBody = (EMVideoMessageBody *)imageContentModel.message.body;
        
        if (imageMessageBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed || imageMessageBody.downloadStatus > EMDownloadStatusSuccessed) {
            
            GJCFWeakSelf weakSelf = self;
            [[EMClient sharedClient].chatManager asyncDownloadMessageAttachments:imageContentModel.message progress:^(int progress) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self setProgress:progress forMessage:imageContentModel.message forMessageBody:imageContentModel.message.body];
                    
                });
              
                
            } completion:^(EMMessage *message, EMError *error) {
                
                NSString *nLocalPath = imageMessageBody.localPath;
                if (![imageMessageBody.localPath.lastPathComponent hasSuffix:@"mp4"]) {
                    nLocalPath = [imageMessageBody.localPath stringByAppendingPathExtension:@"mp4"];
                    [GJCFFileManager moveItemAtURL:[NSURL fileURLWithPath:imageMessageBody.localPath] toURL:[NSURL fileURLWithPath:nLocalPath] error:nil];
                    imageMessageBody.localPath = nLocalPath;
                    [self.taklInfo.conversation updateMessage:message];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    BOOL isSuccess = error? NO:YES;
                    
                    [weakSelf downloadFileCompletionForMessage:message successState:isSuccess];
                    
                });
                
            }];
        }
    }
    
    //普通图片下载
    if (imageContentModel.contentType == GJGCChatFriendContentTypeImage) {
        
        if (imageContentModel.isFromSelf) {
            return;
        }
        
        EMImageMessageBody *imageMessageBody = (EMImageMessageBody *)imageContentModel.message.body;
        
        if (imageMessageBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed) {
            
            GJCFWeakSelf weakSelf = self;
            [[EMClient sharedClient].chatManager asyncDownloadMessageThumbnail:imageContentModel.message progress:^(int progress) {
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self setProgress:progress forMessage:imageContentModel.message forMessageBody:imageContentModel.message.body];
                    
                });

            } completion:^(EMMessage *message, EMError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    BOOL isSuccess = error? NO:YES;
                    
                    [weakSelf downloadFileCompletionForMessage:message successState:isSuccess];
                    
                });
                
            }];
        }
    }
}

- (void)downloadGifFile:(GJGCChatFriendContentModel *)gifContentModel forIndexPath:(NSIndexPath *)indexPath
{
    if ([GJGCGIFLoadManager gifEmojiIsExistById:gifContentModel.gifLocalId]) {
        return;
    }
    
    NSString *taskIdentifier = nil;
    GJCFFileDownloadTask *downloadTask = [GJCFFileDownloadTask taskWithDownloadUrl:@"" withCachePath:[GJGCGIFLoadManager gifCachePathById:gifContentModel.gifLocalId] withObserver:self getTaskIdentifer:&taskIdentifier];
    gifContentModel.downloadTaskIdentifier = taskIdentifier;
    
    downloadTask.userInfo = @{@"type":@"gif",@"msgId":gifContentModel.localMsgId};
    
    [self addDownloadTask:downloadTask];

}

#pragma mark - 取消下载

- (void)cancelDownloadAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    if (contentModel.downloadTaskIdentifier) {
        [self cancelDownloadWithTaskIdentifier:contentModel.downloadTaskIdentifier];
    }
}

#pragma mark - 清除过早历史消息
- (void)clearAllEarlyMessage
{
    /* 清除过早历史消息 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.refreshFootView.isLoading && !self.refreshHeadView.isLoading) {
            
            [self.dataSourceManager clearOverEarlyMessage];
            
        }
    });
}

#pragma mark - GJGCChatInputPanelDelegate

- (GJGCChatInputExpandMenuPanelConfigModel *)chatInputPanelRequiredCurrentConfigData:(GJGCChatInputPanel *)panel
{
    GJGCChatInputExpandMenuPanelConfigModel *configModel = [[GJGCChatInputExpandMenuPanelConfigModel alloc]init];
    configModel.talkType = self.taklInfo.talkType;
    
    return configModel;
}

- (void)chatInputPanel:(GJGCChatInputPanel *)panel didChooseMenuAction:(GJGCChatInputMenuPanelActionType)actionType
{
    /* 清除过早消息，减轻内存压力 */
    [self clearAllEarlyMessage];
    
    switch (actionType) {
        case GJGCChatInputMenuPanelActionTypeCamera:
        {
            if (!GJCFCameraIsAvailable) {
                NSLog(@"照相机不支持");
                return;
            }
            if (!GJCFAppCanAccessCamera) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请在“设置-隐私-相机”选项中允许ZYChat访问你的相机"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            
            /*
             * 解决iOS7下iPhone4,iPhone4s,iPhone5c,iPhone5
             * 相机黑屏问题
             */
            BOOL isSystemRequire = GJCFSystemIsOver7 && !GJCFSystemIsOver8;
            BOOL isDeviceRequire = NO;
            if (GJCFSystemiPhone4 || GJCFSystemiPhone5) {
                isDeviceRequire = YES;
            }
            
            /* 
             * 条件满足就使用自定义相机解决黑屏问题
             * 否则继续使用系统相机
             */
            if (isSystemRequire && isDeviceRequire) {
                
                GJCUCaptureViewController *captureViewController = [[GJCUCaptureViewController alloc]init];
                captureViewController.delegate = self;
                [self presentViewController:captureViewController animated:YES completion:nil];
                
            }else{
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            
        }
            break;
        case GJGCChatInputMenuPanelActionTypePhotoLibrary:
        {
            GJCFAssetsPickerViewController *picker = [[GJCFAssetsPickerViewController alloc]init];
            picker.mutilSelectLimitCount = 8;
            picker.pickerDelegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case GJGCChatInputMenuPanelActionTypeMyFavoritePost:
        {
            
        }
            break;
        case GJGCChatInputMenuPanelActionTypeWebView:
        {
            GJGCWebHostListViewController *hostList = [[GJGCWebHostListViewController alloc]init];
            [self.navigationController pushViewController:hostList animated:YES];
        }
            break;
        case GJGCChatInputMenuPanelActionTypeMusicShare:
        {
            GJGCMusicPlayViewController *musicPlayer = [[GJGCMusicPlayViewController alloc]init];
            [self.navigationController pushViewController:musicPlayer animated:YES];
        }
            break;
        case GJGCChatInputMenuPanelActionTypeAppStore:
        {
            GJGCAppWallViewController *appWall = [[GJGCAppWallViewController alloc]init];
            [self.navigationController pushViewController:appWall animated:YES];
        }
            break;
        case GJGCChatInputMenuPanelActionTypeLimitVideo:
        {
            WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
            wechatShortVideoController.delegate = self;
            [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
        }
            break;
        case GJGCChatInputMenuPanelActionTypeFlower:
        {
            GJGCRecentChatForwardContentModel *forwardContentModel = [[GJGCRecentChatForwardContentModel alloc]init];
            forwardContentModel.title = @"赠送鲜花";
            forwardContentModel.contentType = GJGCChatFriendContentTypeSendFlower;
            
            GJGCRecentContactListViewController *recentList = [[GJGCRecentContactListViewController alloc]initWithForwardContent:forwardContentModel];
            
            UINavigationController *recentNav = [[UINavigationController alloc]initWithRootViewController:recentList];
            
            UIImage *navigationBarBack = GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], CGSizeMake(GJCFSystemScreenWidth * GJCFScreenScale, 64.f * GJCFScreenScale));
            [recentNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
            
            [self.navigationController presentViewController:recentNav animated:YES completion:nil];
        }
            break;
        case GJGCChatInputMenuPanelActionTypeVoice:
        {
            [self openTheVoice];
        }
            break;
            
        case GJGCChatInputMenuPanelActionTypeVideo:
        {
            [self openTheVideo];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Video Record

- (NSURL *)_convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [[GJCFCachePathManager shareManager] mainAudioCacheDirectory], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

- (void)finishWechatShortVideoCapture:(NSURL *)filePath
{
    filePath = [self _convert2Mp4:filePath];
    
    /* 创建内容 */
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.contentType = GJGCChatFriendContentTypeLimitVideo;
    chatContentModel.toId = self.taklInfo.toId;
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.sendStatus = GJGCChatFriendSendMessageStatusSending;
    chatContentModel.isFromSelf = YES;
    chatContentModel.videoUrl = filePath;
    chatContentModel.talkType = self.taklInfo.talkType;
    
    /* 从talkInfo中绑定更多信息给待发送内容 */
    [self setSendChatContentModelWithTalkInfo:chatContentModel];
    
    [self.dataSourceManager sendMesssage:chatContentModel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chatInputPanel:(GJGCChatInputPanel *)panel didFinishRecord:(GJCFAudioModel *)audioFile
{
    //检测是否解除关系，允许发语音
    if (self.inputPanel.disableActionType == GJGCChatInputBarActionTypeRecordAudio) {
        
        //再触发一次，让UI改变
        [self.inputPanel recordRightStartLimit];

        return;
    }
    
    /* 清除过早消息，减轻内存压力 */
    [self clearAllEarlyMessage];
    
    /* 创建内容 */
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.contentType = GJGCChatFriendContentTypeAudio;
    chatContentModel.audioModel = audioFile;
    chatContentModel.audioDuration = [GJGCChatFriendCellStyle formateAudioDuration:GJCFStringFromInt(audioFile.duration)];
    chatContentModel.toId = self.taklInfo.toId;
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.timeString = [GJGCChatSystemNotiCellStyle formateTime:GJCFDateToString([NSDate date])];
    chatContentModel.sendStatus = GJGCChatFriendSendMessageStatusSuccess;
    chatContentModel.isFromSelf = YES;
    chatContentModel.talkType = self.taklInfo.talkType;
    chatContentModel.headUrl = @"http://b.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=38ecb37c54fbb2fb347e50167a7a0c92/d01373f082025aafc50dc5eafaedab64034f1ad7.jpg";
    NSDate *sendTime = GJCFDateFromStringByFormat(@"2015-7-15 08:22:11", @"Y-M-d HH:mm:ss");
    chatContentModel.sendTime = [sendTime timeIntervalSince1970];
    
    /* 从talkInfo中绑定更多信息给待发送内容 */
    [self setSendChatContentModelWithTalkInfo:chatContentModel];
    
    [self.dataSourceManager sendMesssage:chatContentModel];
}

- (void)chatInputPanel:(GJGCChatInputPanel *)panel sendTextMessage:(NSString *)text
{
    /* 清除过早消息，减轻内存压力 */
    [self clearAllEarlyMessage];
    
    /* 创建内容 */
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.contentType = GJGCChatFriendContentTypeText;
    NSDictionary *parseTextDict = [GJGCChatFriendCellStyle formateSimpleTextMessage:text];
    chatContentModel.simpleTextMessage = [parseTextDict objectForKey:@"contentString"];
    chatContentModel.originTextMessage = text;
    chatContentModel.emojiInfoArray = [parseTextDict objectForKey:@"imageInfo"];
    chatContentModel.phoneNumberArray = [parseTextDict objectForKey:@"phone"];
    chatContentModel.toId = self.taklInfo.toId;
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.timeString = [GJGCChatSystemNotiCellStyle formateTime:GJCFDateToString([NSDate date])];
    chatContentModel.sendStatus = GJGCChatFriendSendMessageStatusSuccess;
    chatContentModel.isFromSelf = YES;
    chatContentModel.talkType = self.taklInfo.talkType;
    
    /* 从talkInfo中绑定更多信息给待发送内容 */
    [self setSendChatContentModelWithTalkInfo:chatContentModel];
    
    BOOL isSuccess = [self.dataSourceManager sendMesssage:chatContentModel];
    
    //速度太快，达到间隔限制
    if (!isSuccess) {
        
        [self showSendLimitTip];
    }
}

- (void)chatInputPanel:(GJGCChatInputPanel *)panel sendGIFMessage:(NSString *)gifCode
{
    /* 清除过早消息，减轻内存压力 */
    [self clearAllEarlyMessage];
    
    /* 创建内容 */
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.contentType = GJGCChatFriendContentTypeGif;
    chatContentModel.toId = self.taklInfo.toId;
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.sendStatus = GJGCChatFriendSendMessageStatusSending;
    chatContentModel.isFromSelf = YES;
    chatContentModel.gifLocalId = gifCode;
    chatContentModel.talkType = self.taklInfo.talkType;

    /* 从talkInfo中绑定更多信息给待发送内容 */
    [self setSendChatContentModelWithTalkInfo:chatContentModel];
    
    [self.dataSourceManager sendMesssage:chatContentModel];
}

#pragma mark - Video RecordDelegate

- (void)videoRecordViewController:(GJGCVideoPlayerViewController *)recordVC didFinishRecordWithResult:(NSURL *)recordPath
{
    [recordVC dismissViewControllerAnimated:YES completion:nil];

    /* 创建内容 */
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.contentType = GJGCChatFriendContentTypeLimitVideo;
    chatContentModel.toId = self.taklInfo.toId;
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.sendStatus = GJGCChatFriendSendMessageStatusSending;
    chatContentModel.isFromSelf = YES;
    chatContentModel.videoUrl = recordPath;
    chatContentModel.talkType = self.taklInfo.talkType;
    
    /* 从talkInfo中绑定更多信息给待发送内容 */
    [self setSendChatContentModelWithTalkInfo:chatContentModel];
    
    [self.dataSourceManager sendMesssage:chatContentModel];
}

#pragma mark - GJCUCaptureDelegate
- (void)captureViewController:(GJCUCaptureViewController *)captureViewController didFinishChooseMedia:(NSDictionary *)mediaInfo
{
    [self showCropingImageOnView:captureViewController.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *images = [NSMutableArray array];
        
        @autoreleasepool {
            
            UIImage *originImage = [mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
            
            NSLog(@"origin ImageSize:%@",NSStringFromCGSize(originImage.size));
            
            if (originImage.size.width > 1200 || originImage.size.height > 1200) {
                
                CGFloat max = originImage.size.width > originImage.size.height ? originImage.size.width : originImage.size.height;
                
                originImage = [originImage fixOrietationWithScale:1200/max];
                
                NSLog(@"origin crop size:%@",NSStringFromCGSize(originImage.size));
                
            }else{
                
                originImage = [originImage fixOrietationWithScale:1.0];
                
            }
            
            NSDictionary *originImageInfo = [self createOriginImageToCacheDiretory:originImage];
            [self createThumbFromCaptureOriginImage:originImage withOriginImagePath:originImageInfo[@"path"]];
            NSString *thumbImageName = [NSString stringWithFormat:@"%@-thumb",originImageInfo[@"file"]];
            
            NSDictionary *imageInfo = @{@"origin":originImageInfo[@"file"],@"thumb":thumbImageName,@"originWidth":@(originImage.size.width),@"originHeight":@(originImage.size.height)};
            
            [images addObject:imageInfo];
        }
        
        [self sendImages:images];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self removeCropingImageOnView:captureViewController.view];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    });

}

- (void)captureViewControllerAccessCamerouNotAuthorized:(GJCUCaptureViewController *)captureViewController
{
    
}

/**
 *  capture创建缩略图
 */
- (NSString *)createThumbFromCaptureOriginImage:(UIImage *)originImage withOriginImagePath:(NSString *)originImagePath
{
    // 创建一份缩略图，否则对话列表在未发送成功的时候显示原图太卡了
    UIImage *thumbImage = [[originImage copy] fixOrietationWithScale:0.48];
    
    NSLog(@"thumbImageSize:%@",NSStringFromCGSize(thumbImage.size));
    
    return [self createTumbWithImage:thumbImage withOriginImagePath:originImagePath];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self showCropingImageOnView:picker.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:@"public.image"]){
            
            NSMutableArray *images = [NSMutableArray array];
            
            @autoreleasepool {
                
                UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
                
                NSData *jpgEncode = UIImageJPEGRepresentation(originImage, 0.45);
                originImage = [UIImage imageWithData:jpgEncode];
                
                NSLog(@"origin ImageSize:%@",NSStringFromCGSize(originImage.size));
                
                if (originImage.size.width > 1200 || originImage.size.height > 1200) {
                    
                    CGFloat max = originImage.size.width > originImage.size.height ? originImage.size.width : originImage.size.height;
                    
                    originImage = [originImage fixOrietationWithScale:1200/max];
                    
                    NSLog(@"origin crop size:%@",NSStringFromCGSize(originImage.size));
                    
                }else{
                    
                    originImage = [originImage fixOrietationWithScale:1.0];

                }
                
                NSDictionary *originImageInfo = [self createOriginImageToCacheDiretory:originImage];
                [self createThumbFromOriginImage:originImage withOriginImagePath:originImageInfo[@"path"]];
                NSString *thumbImageName = [NSString stringWithFormat:@"%@-thumb",originImageInfo[@"file"]];
                
                NSDictionary *imageInfo = @{@"origin":originImageInfo[@"file"],@"thumb":thumbImageName,@"originWidth":@(originImage.size.width),@"originHeight":@(originImage.size.height)};
                
                [images addObject:imageInfo];
            }
            
            [self sendImages:images];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self removeCropingImageOnView:picker.view];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            });
            
        }
        
    });
}

#pragma mark - GJCFAssetsPickerDelegate
- (void)pickerViewController:(GJCFAssetsPickerViewController *)pickerViewController didReachLimitSelectedCount:(NSInteger)limitCount
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能选择%ld张图片",(long)limitCount] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)pickerViewControllerRequirePreviewButNoSelectedImage:(GJCFAssetsPickerViewController *)pickerViewController
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请选择要预览的图片"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)pickerViewControllerPhotoLibraryAccessDidNotAuthorized:(GJCFAssetsPickerViewController *)pickerViewController
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请在“设置-隐私-照片”选项中允许系统生活访问你的照片库"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)pickerViewController:(GJCFAssetsPickerViewController *)pickerViewController didFaildWithErrorMsg:(NSString *)errorMsg withErrorType:(GJAssetsPickerErrorType)errorType
{
    if (errorType == GJAssetsPickerErrorTypePhotoLibarayChooseZeroCountPhoto) {
        
        
    }
}

- (void)pickerViewController:(GJCFAssetsPickerViewController *)pickerViewController didFinishChooseMedia:(NSArray *)resultArray
{
    /* 显示正在处理 */
    [self showCropingImageOnView:pickerViewController.view];
    
    /* 不准再触摸点击了 */
    pickerViewController.view.userInteractionEnabled = NO;
    
    /* 不在主线程处理，否则没法添加“正在裁剪照片...”的效果 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *images = [NSMutableArray array];
        
        for (GJCFAsset *asset in resultArray) {
            
            @autoreleasepool {
                
                UIImage *originImage = asset.fullResolutionImage;
                if (originImage.size.width > 1200 || originImage.size.height > 1200) {
                    
                    CGFloat max = originImage.size.width > originImage.size.height ? originImage.size.width : originImage.size.height;
                    
                    originImage = [originImage fixOrietationWithScale:1200/max];
                    
                }else{
                    
                    originImage = [originImage fixOrietationWithScale:1.0];
                    
                }
                
                NSDictionary *originImageInfo = [self createOriginImageToCacheDiretory:originImage];
                [self createTumbWithImage:asset.aspectRatioThumbnail withOriginImagePath:originImageInfo[@"path"]];
                NSString *thumbImageName = [NSString stringWithFormat:@"%@-thumb",originImageInfo[@"file"]];
                
                NSDictionary *imageInfo = @{@"origin":originImageInfo[@"file"],@"thumb":thumbImageName,@"originWidth":@(originImage.size.width),@"originHeight":@(originImage.size.height)};
                
                [images addObject:imageInfo];
            }
            
        }
        

        [self sendImages:images];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self removeCropingImageOnView:pickerViewController.view];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    });

}

#pragma mark - 图片发送
- (void)sendImages:(NSArray *)images
{
    for (NSDictionary *imageInfo in images) {
        
        NSString *originPath = [imageInfo objectForKey:@"origin"];
        NSString *thumbPath = [imageInfo objectForKey:@"thumb"];
        NSInteger originWidth = [[imageInfo objectForKey:@"originWidth"] intValue];
        NSInteger originHeight = [[imageInfo objectForKey:@"originHeight"] intValue];

        /* 内容拼接 */
        GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
        chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
        chatContentModel.contentType = GJGCChatFriendContentTypeImage;
        chatContentModel.originImageWidth = originWidth;
        chatContentModel.originImageHeight = originHeight;
        chatContentModel.imageLocalCachePath = originPath;
        chatContentModel.thumbImageCachePath = thumbPath;
        chatContentModel.toId = self.taklInfo.toId;
        chatContentModel.toUserName = self.taklInfo.toUserName;
        chatContentModel.isFromSelf = YES;
        chatContentModel.talkType = self.taklInfo.talkType;
        
        /* 从talkInfo中绑定更多信息给待发送内容 */
        [self setSendChatContentModelWithTalkInfo:chatContentModel];
        
        [self.dataSourceManager sendMesssage:chatContentModel];
    }
}

#pragma mark - 绑定更多信息给待发送的内容
- (void)setSendChatContentModelWithTalkInfo:(GJGCChatFriendContentModel *)contentModel
{
    
}

#pragma mark - 图片处理UI方法

#define GJGCInputViewToastLabelTag 3344556611

- (void)showCropingImageOnView:(UIView *)destView
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        /* 添加一个等待Toast*/
        UILabel *toastLabel = (UILabel *)[destView viewWithTag:GJGCInputViewToastLabelTag];
        
        if (!toastLabel) {
            CGFloat toastWidth = 180;
            CGFloat toastHeight = 65;
            
            CGFloat originX = (destView.frame.size.width - toastWidth)  /2;
            CGFloat originY = (destView.frame.size.height - toastHeight)/2;
            
            toastLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, toastWidth, toastHeight)];
            toastLabel.layer.cornerRadius = 9.f;
            toastLabel.backgroundColor = [UIColor blackColor];
            toastLabel.layer.opacity = 0.7;
            toastLabel.layer.masksToBounds = YES;
            toastLabel.textColor = [UIColor whiteColor];
            toastLabel.textAlignment = NSTextAlignmentCenter;
            toastLabel.text = @"图片处理中...";
            
            [destView addSubview:toastLabel];
            
        }else{
            
            [destView addSubview:toastLabel];
        }
        
    });
}

- (void)removeCropingImageOnView:(UIView *)destView
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UILabel *toastLabel = (UILabel *)[destView viewWithTag:GJGCInputViewToastLabelTag];
        
        if (!toastLabel) {
            return;
        }
        
        if (![destView.subviews containsObject:toastLabel]) {
            return;
        }
        
        [toastLabel removeFromSuperview];
        toastLabel = nil;
        
    });
}

- (NSString *)createThumbFromOriginImage:(UIImage *)originImage withOriginImagePath:(NSString *)originImagePath
{
    // 创建一份缩略图，否则对话列表在未发送成功的时候显示原图太卡了
    UIImage *thumbImage = [[originImage copy] fixOrietationWithScale:0.16];
    
    NSLog(@"thumbImageSize:%@",NSStringFromCGSize(thumbImage.size));
    
   return [self createTumbWithImage:thumbImage withOriginImagePath:originImagePath];
}

- (NSString *)createTumbWithImage:(UIImage *)thumbImage withOriginImagePath:(NSString *)originImagePath
{
    NSString *thumbPath = [NSString stringWithFormat:@"%@-thumb",originImagePath];
    
    NSData *imageData = UIImageJPEGRepresentation(thumbImage, 0.8);
    
    BOOL saveThumbResult = GJCFFileWrite(imageData, thumbPath);
    
    NSLog(@"saveThumbResult:%d",saveThumbResult);

    return thumbPath;
}

- (NSDictionary *)createOriginImageToCacheDiretory:(UIImage *)originImage
{
    NSString *fileName = [NSString stringWithFormat:@"local_file_%@",GJCFStringCurrentTimeStamp];
    
    NSString *filePath = [[GJCFCachePathManager shareManager]mainImageCacheFilePath:fileName];
    
    NSData *imageData = UIImageJPEGRepresentation(originImage, 0.8);

   BOOL saveOriginResult = GJCFFileWrite(imageData, filePath);
    
    NSLog(@"saveOriginResult:%d",saveOriginResult);
    
    return @{@"file":fileName,@"path":filePath};
}

#pragma mark - 附件下载策略回调

- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(EMMessageBody *)messageBody
{
    NSString *msgId = message.messageId;
    
    if (messageBody.type ==  EMMessageBodyTypeImage) {
        
        NSInteger resultIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (resultIndex != NSNotFound) {
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:resultIndex inSection:0]]) {
                
                GJGCChatFriendImageMessageCell *imageCell = (GJGCChatFriendImageMessageCell *)[self.chatListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:resultIndex inSection:0]];
                
                if ([imageCell isKindOfClass:[GJGCChatFriendImageMessageCell class]]) {
                    
                    imageCell.downloadProgress = progress;
                    
                }
            }
            
        }
    }
}

- (void)downloadFileCompletionForMessage:(EMMessage *)message successState:(BOOL)isSuccess
{
    EMFileMessageBody *messageBody = (EMFileMessageBody*)message.body;
    
    NSString *msgId = message.messageId;

    //下载失败统一处理
    if (!isSuccess) {
        
        NSInteger resultIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (resultIndex != NSNotFound) {
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:resultIndex inSection:0]]) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:resultIndex inSection:0];
                if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                    
                    GJGCChatFriendBaseCell *messageCell = (GJGCChatFriendBaseCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                    
                    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelByMsgId:msgId];
                    contentModel.isDownloading = NO;
                    
                    [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:contentModel atIndex:indexPath.row];
                    
                    [messageCell faildDownloadAction];
                }
            }
        }

        return;
    }
    
    NSInteger rowIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];

    //下载成功处理
    switch (messageBody.type) {
        case EMMessageBodyTypeImage:
        {
            EMImageMessageBody *imageMessageBody = (EMImageMessageBody *)messageBody;
        
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                
                GJGCChatFriendImageMessageCell *imageCell = (GJGCChatFriendImageMessageCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                
                if ([imageCell isKindOfClass:[GJGCChatFriendImageMessageCell class]]) {
                    
                    [imageCell successDownloadWithImageData:[NSData dataWithContentsOfFile:imageMessageBody.thumbnailLocalPath]];
                    
                }
            }
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            EMVoiceMessageBody *voiceMessageBody = (EMVoiceMessageBody *)messageBody;
            
            if (rowIndex != NSNotFound) {
                
                GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:rowIndex];
                
                contentModel.isDownloading = NO;
                
                contentModel.audioModel.localStorePath = [voiceMessageBody localPath];
                contentModel.audioModel.duration = [voiceMessageBody duration];
                
                NSLog(@"audioModel:%@",contentModel.audioModel);
                
                /* 如果是当前正点击播放的cell */
                if ([msgId isEqualToString:self.playingAudioMsgId]) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
                    
                    [[GJGCMusicSharePlayer sharePlayer].audioPlayer playAudioFile:contentModel.audioModel];
                    contentModel.isPlayingAudio = YES;
                    contentModel.isRead = YES;
                    self.isLastPlayedMyAudio = contentModel.isFromSelf;
                    
                    [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:contentModel atIndex:rowIndex];
                    
                    if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                        
                        GJGCChatFriendAudioMessageCell *playingCell = (GJGCChatFriendAudioMessageCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                        
                        if ([playingCell isKindOfClass:[GJGCChatFriendAudioMessageCell class]]) {
                            
                            [playingCell playAudioAction];
                            
                        }
                    }
                }
            }
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            EMVideoMessageBody *voiceMessageBody = (EMVideoMessageBody *)messageBody;
            
            if (rowIndex != NSNotFound) {
                
                GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:rowIndex];
                
                contentModel.isDownloading = NO;
                
                contentModel.videoUrl = [NSURL fileURLWithPath:voiceMessageBody.localPath];
                
                NSLog(@"videoModel:%@",contentModel.videoUrl);
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
                
                contentModel.isPlayingVideo = YES;
                
                [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:contentModel atIndex:rowIndex];
                
                if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                    
                    GJGCChatFriendVideoCell *playingCell = (GJGCChatFriendVideoCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                    
                    if ([playingCell isKindOfClass:[GJGCChatFriendVideoCell class]]) {
                        
                        [playingCell playAction];
                        
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 发送消息速度太快限制

- (void)showSendLimitTip
{
    if (self.sendLimitTipLabel.gjcf_right == GJCFSystemScreenWidth) {
        return;
    }

    if (!self.sendLimitTipLabel) {
        self.sendLimitTipLabel = [[UILabel alloc]init];
        self.sendLimitTipLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.35];
        self.sendLimitTipLabel.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
        self.sendLimitTipLabel.textColor = [UIColor whiteColor];
        self.sendLimitTipLabel.textAlignment = NSTextAlignmentCenter;
        self.sendLimitTipLabel.text = @"您的发送速度太快了!";
        self.sendLimitTipLabel.layer.cornerRadius = 3.f;
        self.sendLimitTipLabel.layer.masksToBounds = YES;
        [self.sendLimitTipLabel sizeToFit];
        self.sendLimitTipLabel.gjcf_width += 2*8.f;
        self.sendLimitTipLabel.gjcf_height += 2*5.f;
        [self.view addSubview:self.sendLimitTipLabel];
    }
    self.sendLimitTipLabel.gjcf_bottom = self.inputPanel.gjcf_top;
    self.sendLimitTipLabel.gjcf_left = GJCFSystemScreenWidth;
    
    [UIView animateWithDuration:0.26 animations:^{
       
        self.sendLimitTipLabel.gjcf_right = GJCFSystemScreenWidth;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self hiddenSendLimitTip];
        
    });
}

- (void)hiddenSendLimitTip
{
    if (self.sendLimitTipLabel.gjcf_left == GJCFSystemScreenWidth) {
        return;
    }
    
    [UIView animateWithDuration:0.26 animations:^{
        
        self.sendLimitTipLabel.gjcf_left = GJCFSystemScreenWidth;
        
    }];
}

- (void)openTheVoice
{
    EMError *error = nil;
    EMCallSession *callSession = [[EMClient sharedClient].callManager makeVoiceCall:self.taklInfo.toId error:&error ];
    
    if (callSession && !error) {
        [[EMClient sharedClient].callManager removeDelegate:self];
        GJGCVoiceCallViewController *callController = [[GJGCVoiceCallViewController alloc] initWithSession:callSession isIncoming:NO];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:callController animated:NO completion:nil];
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (void)openTheVideo
{
    BOOL isopen = GJCFAppCanAccessCamera;
    
    if (!isopen) {
        NSLog(@"不能打开视频");
        return ;
    }
    
    EMError *error = nil;
    EMCallSession *callSession = [[EMClient sharedClient].callManager makeVideoCall:self.taklInfo.toId error:&error ];
    
    if (callSession && !error) {
        
        [[EMClient sharedClient].callManager removeDelegate:self];
        GJGCVideoCallViewController *callController = [[GJGCVideoCallViewController alloc] initWithSession:callSession isIncoming:NO];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:callController animated:NO completion:nil];
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

#pragma mark - MusicBarDelegate

- (void)didTappedMusicPlayerBar
{
    GJGCMusicPlayingViewController *musicPlay = [[GJGCMusicPlayingViewController alloc]init];
    [self.navigationController pushViewController:musicPlay animated:YES];
}

#pragma mark - Scroll event

- (void)dispatchScrollViewDidEndDecelerating
{
    if ([GJGCMusicSharePlayer sharePlayer].musicMsgId.length > 0) {
        
        NSInteger playingIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:self.playingAudioMsgId];
        
        NSIndexPath *playingIndexPath = [NSIndexPath indexPathForRow:playingIndex inSection:0];
        
        NSArray *visiableCellIndexs = [self.chatListTable indexPathsForVisibleRows];
        
        if ([visiableCellIndexs containsObject:playingIndexPath]) {
            [UIView animateWithDuration:0.26 animations:^{
                self.musicBar.alpha = 0;
            }];
        }else{
            [UIView animateWithDuration:0.26 animations:^{
                self.musicBar.alpha = 1;
            }];
        }
    }else{
        [UIView animateWithDuration:0.26 animations:^{
            self.musicBar.alpha = 0;
        }];
    }
}

@end
