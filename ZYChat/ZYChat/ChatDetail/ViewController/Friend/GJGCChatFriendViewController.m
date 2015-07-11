//
//  GJGCChatFriendViewController.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendViewController.h"
#import "GJCFAudioPlayer.h"
#import "GJGCChatFriendAudioMessageCell.h"
#import "GJGCChatFriendImageMessageCell.h"
#import "GJCUImageBrowserNavigationViewController.h"
#import "UIImage+GJFixOrientation.h"
#import "GJGCChatContentEmojiParser.h"
//#import "GJGCPersonInformationViewController.h"
#import "GJCUCaptureViewController.h"
#import "GJCFUitils.h"
#import "GJGCGIFLoadManager.h"
#import "GJGCChatFriendGifCell.h"
#import "GJGCDrfitBottleDetailViewController.h"
#import "GJGCChatFriendDriftBottleCell.h"
#import "GJCFAssetsPickerViewControllerDelegate.h"
#import "GJGCWebViewController.h"
#import "GJCFAssetsPickerViewController.h"


#define GJGCActionSheetCallPhoneNumberTag 132134

#define GJGCActionSheetShowMyFavoritePost 132135

static NSString * const GJGCActionSheetAssociateKey = @"GJIMSimpleCellActionSheetAssociateKey";

@interface GJGCChatFriendViewController ()<
                                            GJCFAudioPlayerDelegate,
                                            UIImagePickerControllerDelegate,
                                            UINavigationControllerDelegate,
                                            GJCFAssetsPickerViewControllerDelegate,
                                            GJCUCaptureViewControllerDelegate>

@property (nonatomic,strong)GJCFAudioPlayer *audioPlayer;

@property (nonatomic,strong)NSString *playingAudioMsgId;

@property (nonatomic,assign)NSInteger lastPlayedAudioMsgIndex;

@property (nonatomic,assign)BOOL isLastPlayedMyAudio;

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
    
    /* 语音播放工具 */
    self.audioPlayer = [[GJCFAudioPlayer alloc]init];
    self.audioPlayer.delegate = self;
    
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

    
}

#pragma mark - 应用程序事件
- (void)observeApplicationResignActive:(NSNotification *)noti
{
    [self stopPlayCurrentAudio];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.audioPlayer.isPlaying) {
        [self stopPlayCurrentAudio];
    }
    [self.inputPanel removeKeyboardObserve];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.inputPanel startKeyboardObserve];
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
    
}

#pragma mark - 文件下载处理

- (void)finishDownloadWithTask:(GJCFFileDownloadTask *)task withDownloadFileData:(NSData *)fileData
{
    [super finishDownloadWithTask:task withDownloadFileData:fileData];
    
    NSDictionary *userInfo = task.userInfo;
    
    NSString *taskType = userInfo[@"type"];
    
    NSString *msgId = userInfo[@"msgId"];
    
    if ([taskType isEqualToString:@"audio"]) {
        
        NSInteger rowIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (rowIndex != NSNotFound) {
            
            GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:rowIndex];
            
            contentModel.isDownloading = NO;
            
            contentModel.audioModel.localStorePath = [[GJCFCachePathManager shareManager]mainAudioCacheFilePathForUrl:task.downloadUrl];
            
            NSLog(@"audioModel:%@",contentModel.audioModel);
            
            /* 编码转换 */
            BOOL convertResult =  [GJCFEncodeAndDecode convertAudioFileToWAV:contentModel.audioModel];
            
            if (convertResult) {
                
                /* 删掉临时编码文件 */
                if (contentModel.audioModel.isDeleteWhileFinishConvertToLocalFormate) {
                    [contentModel.audioModel deleteTempEncodeFile];
                }
                
                /* 如果是当前正点击播放的cell */
                if ([msgId isEqualToString:self.playingAudioMsgId]) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
                    
                    [self.audioPlayer playAudioFile:contentModel.audioModel];
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
        
    }
    
    if ([taskType isEqualToString:@"image"]) {
        
        NSInteger rowIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (rowIndex != NSNotFound) {
            
            /*  更新高度 */
            GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:rowIndex];
            [self.dataSourceManager updateContentModel:contentModel atIndex:rowIndex];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                
                GJGCChatFriendImageMessageCell *imageCell = (GJGCChatFriendImageMessageCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                
                if ([imageCell isKindOfClass:[GJGCChatFriendImageMessageCell class]]) {
                    
                    [imageCell successDownloadWithImageData:fileData];
                    
                }
                
            }
            
        }
    }
    
    
    //gif文件下载处理
    if ([taskType isEqualToString:@"gif"]) {
        
        NSInteger rowIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (rowIndex != NSNotFound) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                
                GJGCChatFriendGifCell  *imageCell = (GJGCChatFriendGifCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                
                if ([imageCell isKindOfClass:[GJGCChatFriendGifCell class]]) {
                    
                    [imageCell successDownloadGifFile:fileData];
                    
                }
                
            }
            
        }
        
    }
    
}

- (void)downloadFileWithTask:(GJCFFileDownloadTask *)task progress:(CGFloat)progress
{
    [super downloadFileWithTask:task progress:progress];
    
    NSDictionary *userInfo = task.userInfo;
    
    NSString *taskType = userInfo[@"type"];
    
    NSString *msgId = userInfo[@"msgId"];
    
    if ([taskType isEqualToString:@"image"]) {
        
        NSInteger resultIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (resultIndex != NSNotFound) {
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:resultIndex inSection:0]]) {
                
                GJGCChatFriendImageMessageCell *gifCell = (GJGCChatFriendImageMessageCell *)[self.chatListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:resultIndex inSection:0]];
                
                if ([gifCell isKindOfClass:[GJGCChatFriendImageMessageCell class]]) {
                    
                    gifCell.downloadProgress = progress;
                    
                }
            }
            
        }
    }
    
    //gif文件下载处理
    if ([taskType isEqualToString:@"gif"]) {
        
        NSInteger resultIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (resultIndex != NSNotFound) {
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:resultIndex inSection:0]]) {
                
                GJGCChatFriendGifCell *gifCell = (GJGCChatFriendGifCell *)[self.chatListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:resultIndex inSection:0]];
                
                if ([gifCell isKindOfClass:[GJGCChatFriendGifCell class]]) {
                    
                    gifCell.downloadProgress = progress;
                    
                }
            }
            
        }
        
    }
}

- (void)faildDownloadFileWithTask:(GJCFFileDownloadTask *)task
{
    [super faildDownloadFileWithTask:task];
    
    NSDictionary *userInfo = task.userInfo;
    
    NSString *taskType = userInfo[@"type"];
    
    NSString *msgId = userInfo[@"msgId"];
    
    if ([taskType isEqualToString:@"audio"]) {
        
        NSInteger resultIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (resultIndex != NSNotFound) {
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:resultIndex inSection:0]]) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:resultIndex inSection:0];
                if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                    
                    GJGCChatFriendAudioMessageCell *imageCell = (GJGCChatFriendAudioMessageCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                    
                    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelByMsgId:msgId];
                    contentModel.isDownloading = NO;
                    [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:contentModel atIndex:indexPath.row];
                    
                    if ([imageCell isKindOfClass:[GJGCChatFriendAudioMessageCell class]]) {
                        
                        [imageCell faildDownloadAction];
                        
                    }
                }
            }
        }
        
    }
    
    if ([taskType isEqualToString:@"image"]) {
        
        NSInteger resultIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (resultIndex != NSNotFound) {
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:resultIndex inSection:0]]) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:resultIndex inSection:0];
                if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                    
                    GJGCChatFriendImageMessageCell *imageCell = (GJGCChatFriendImageMessageCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                    
                    if ([imageCell isKindOfClass:[GJGCChatFriendImageMessageCell class]]) {
                        
                        [imageCell faildState];
                        
                    }
                }
            }
            
        }
    }
    
    //gif文件下载处理
    if ([taskType isEqualToString:@"gif"]) {
        
        NSInteger resultIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:msgId];
        
        if (resultIndex != NSNotFound) {
            
            if ([[self.chatListTable indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:resultIndex inSection:0]]) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:resultIndex inSection:0];
                if ([[self.chatListTable indexPathsForVisibleRows] containsObject:indexPath]) {
                    
                    GJGCChatFriendGifCell *gifCell = (GJGCChatFriendGifCell *)[self.chatListTable cellForRowAtIndexPath:indexPath];
                    
                    if ([gifCell isKindOfClass:[GJGCChatFriendGifCell class]]) {
                        
                        [gifCell faildDownloadGifFile];
                        
                    }
                }
            }
            
        }
    }
}

#pragma mark - GJGCChatBaseCellDelegate

- (void)audioMessageCellDidTap:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *indexPath = [self.chatListTable indexPathForCell:tapedCell];
    
    // 如果点击的是自己，那么停止了就不往下走了。如果
    GJGCChatContentBaseModel *contentModel = [self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    if ( self.playingAudioMsgId && [self.playingAudioMsgId isEqualToString:contentModel.localMsgId] && self.audioPlayer.isPlaying) {
        
        [self stopPlayCurrentAudio];
        
        self.playingAudioMsgId = nil;
        
        return;
    }
    
    [self stopPlayCurrentAudio];
    self.playingAudioMsgId = contentModel.localMsgId;
    
    [self startPlayCurrentAudio];
}

- (void)imageMessageCellDidTap:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *indexPath = [self.chatListTable indexPathForCell:tapedCell];
    
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:indexPath.row];
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSInteger currentImageIndex = 0;
    
    for (int i = 0; i < [self.dataSourceManager totalCount]; i++) {
        
        GJGCChatFriendContentModel *itemModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:i];
        if (itemModel.contentType == GJGCChatFriendContentTypeImage) {
            
            [imageUrls addObject:itemModel.imageMessageUrl];

            if ([itemModel.imageMessageUrl isEqualToString:contentModel.imageMessageUrl]) {
                
                currentImageIndex = imageUrls.count - 1;
                
            }
        }
        
    }
    
    /* 进入大图浏览模式 */
    GJCUImageBrowserNavigationViewController *imageBrowser = [[GJCUImageBrowserNavigationViewController alloc]initWithImageUrls:imageUrls];
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
    GJGCWebViewController *webView = [[GJGCWebViewController alloc]init];
    [self.navigationController pushViewController:webView animated:YES];
    [webView setUrl:url];
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
}

- (void)chatCellDidTapOnHeadView:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];

//    GJGCPersonInformationViewController *personVC = [[GJGCPersonInformationViewController alloc]initWithUserId:[contentModel.senderId longLongValue] reportType:GJGCReportTypePerson];
//    [[GJGCUIStackManager share]pushViewController:personVC animated:YES];
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
    
    NSString *taskIdentifier = nil;
    GJCFFileDownloadTask *downloadTask = [GJCFFileDownloadTask taskWithDownloadUrl:contentModel.audioModel.remotePath withCachePath:contentModel.audioModel.tempEncodeFilePath withObserver:self getTaskIdentifer:&taskIdentifier];
    contentModel.downloadTaskIdentifier = taskIdentifier;
    downloadTask.userInfo = @{@"type":@"audio",@"msgId":contentModel.localMsgId};
    
    [self addDownloadTask:downloadTask];
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
        
        [self.audioPlayer playAudioFile:contentModel.audioModel];
        contentModel.isPlayingAudio = YES;
        contentModel.isRead = YES;
        self.isLastPlayedMyAudio = contentModel.isFromSelf;
        [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:contentModel atIndex:playingIndex];
        
        GJGCChatFriendAudioMessageCell *playingCell = (GJGCChatFriendAudioMessageCell *)[self.chatListTable cellForRowAtIndexPath:playingIndexPath];
        [playingCell playAudioAction];
        
        return;
        
    }

    /* 加载下载转圈等待特效 */
    GJGCChatFriendContentModel *friendContentModel = (GJGCChatFriendContentModel *)contentModel;
    friendContentModel.isDownloading = YES;
    [self.dataSourceManager updateContentModelValuesNotEffectRowHeight:friendContentModel atIndex:playingIndex];
    
    GJGCChatFriendAudioMessageCell *playingCell = (GJGCChatFriendAudioMessageCell *)[self.chatListTable cellForRowAtIndexPath:playingIndexPath];
    [playingCell startDownloadAction];
    
    [self downloadAndPlayAudioAtRowIndex:playingIndexPath];
    
}

- (void)stopPlayCurrentAudio
{
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
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
    
    //漂流瓶图片下载
    if (imageContentModel.contentType == GJGCChatFriendContentTypeDriftBottle) {
        
//        [self downloadDriftBottleImageFile:imageContentModel forIndexPath:indexPath];
        
        return;
    }
    
    //普通图片下载
    if (imageContentModel.contentType == GJGCChatFriendContentTypeImage || imageContentModel.contentType == GJGCChatFriendContentTypePost) {
        
        if (GJCFFileIsExist(imageContentModel.imageLocalCachePath)) {
            return;
        }
        
        CGSize imageSize = CGSizeMake(80, 140);
        CGSize thumbSize = [GJGCImageResizeHelper getCutImageSizeWithScreenScale:imageSize maxSize:CGSizeMake(160, 160)];
        NSString *thumbImageUrl = @"";
        
        if (![[GJCFCachePathManager shareManager] mainImageCacheFileIsExistForUrl:thumbImageUrl] && !GJCFStringIsNull(thumbImageUrl)) {
            
            NSLog(@"image url:%@",thumbImageUrl);

            imageContentModel.imageLocalCachePath = [[GJCFCachePathManager shareManager] mainImageCacheFilePathForUrl:thumbImageUrl];
            NSLog(@"image local path:%@",imageContentModel.imageLocalCachePath);
            
            NSString *taskIdentifier = nil;
            GJCFFileDownloadTask *downloadTask = [GJCFFileDownloadTask taskWithDownloadUrl:thumbImageUrl withCachePath:imageContentModel.imageLocalCachePath withObserver:self getTaskIdentifer:&taskIdentifier];
            imageContentModel.downloadTaskIdentifier = taskIdentifier;
            
            downloadTask.userInfo = @{@"type":@"image",@"msgId":contentModel.localMsgId};
            
            [self addDownloadTask:downloadTask];
        }
        
    }
    
}

- (void)downloadDriftBottleImageFile:(GJGCChatFriendContentModel *)imageContentModel forIndexPath:(NSIndexPath *)indexPath
{
    if (GJCFFileIsExist(imageContentModel.imageLocalCachePath)) {
        return;
    }

    CGSize imageSize = CGSizeMake(80, 234);
    
    CGFloat contentInnerMargin = 12.f;
    CGFloat bubbleToBordMargin = 56;
    CGFloat maxContentImageWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 2*contentInnerMargin;

    CGSize thumbSize = [GJGCImageResizeHelper getCutImageSizeWithScreenScale:imageSize maxSize:CGSizeMake(maxContentImageWidth, maxContentImageWidth)];
    NSString *thumbImageUrl = @"";
    
    if (![[GJCFCachePathManager shareManager] mainImageCacheFileIsExistForUrl:thumbImageUrl] && !GJCFStringIsNull(thumbImageUrl)) {
        
        NSLog(@"image url:%@",thumbImageUrl);
        
        imageContentModel.imageLocalCachePath = [[GJCFCachePathManager shareManager] mainImageCacheFilePathForUrl:thumbImageUrl];
        NSLog(@"image local path:%@",imageContentModel.imageLocalCachePath);
        
        NSString *taskIdentifier = nil;
        GJCFFileDownloadTask *downloadTask = [GJCFFileDownloadTask taskWithDownloadUrl:thumbImageUrl withCachePath:imageContentModel.imageLocalCachePath withObserver:self getTaskIdentifer:&taskIdentifier];
        imageContentModel.downloadTaskIdentifier = taskIdentifier;
        
        downloadTask.userInfo = @{@"type":@"image",@"msgId":imageContentModel.localMsgId};
        
        [self addDownloadTask:downloadTask];
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
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请在“设置-隐私-相机”选项中允许系统生活访问你的相机"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
        default:
            break;
    }
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
    
    [self.dataSourceManager mockSendAnMesssage:chatContentModel];
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
    NSDate *sendTime = GJCFDateFromStringByFormat(@"2015-7-15 08:22:11", @"Y-M-d HH:mm:ss");
    chatContentModel.sendTime = [sendTime timeIntervalSince1970];
    chatContentModel.headUrl = @"http://b.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=38ecb37c54fbb2fb347e50167a7a0c92/d01373f082025aafc50dc5eafaedab64034f1ad7.jpg";
    
    /* 从talkInfo中绑定更多信息给待发送内容 */
    [self setSendChatContentModelWithTalkInfo:chatContentModel];
    
    [self.dataSourceManager mockSendAnMesssage:chatContentModel];

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
    NSDate *sendTime = GJCFDateFromStringByFormat(@"2015-7-15 08:22:11", @"Y-M-d HH:mm:ss");
    chatContentModel.sendTime = [sendTime timeIntervalSince1970];
    chatContentModel.timeString = [GJGCChatSystemNotiCellStyle formateTime:GJCFDateToString(sendTime)];
    chatContentModel.sendStatus = GJGCChatFriendSendMessageStatusSuccess;
    chatContentModel.isFromSelf = YES;
    chatContentModel.gifLocalId = gifCode;
    chatContentModel.talkType = self.taklInfo.talkType;
    chatContentModel.headUrl = @"http://b.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=38ecb37c54fbb2fb347e50167a7a0c92/d01373f082025aafc50dc5eafaedab64034f1ad7.jpg";

    
    /* 从talkInfo中绑定更多信息给待发送内容 */
    [self setSendChatContentModelWithTalkInfo:chatContentModel];
    
    [self.dataSourceManager mockSendAnMesssage:chatContentModel];
    
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

@end
