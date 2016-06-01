//
//  GJGCChatDetailViewController.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-10-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCChatInputPanel.h"
#import "GJCFAudioPlayer.h"
#import "GJGCChatDetailDataSourceManager.h"
#import "GJGCChatBaseCellDelegate.h"
#import "GJCFFileDownloadManager.h"
#import "GJGCChatFriendTalkModel.h"
#import "GJGCRefreshHeaderView.h"
#import "GJGCRefreshFooterView.h"
#import "GJGCBaseViewController.h"

@interface GJGCChatDetailViewController : GJGCBaseViewController<UITableViewDataSource,UITableViewDelegate,GJGCChatBaseCellDelegate,GJGCChatDetailDataSourceManagerDelegate,GJGCChatInputPanelDelegate>

@property (nonatomic,strong)GJGCRefreshHeaderView *refreshHeadView;

@property (nonatomic,strong)GJGCRefreshFooterView *refreshFootView;

@property (nonatomic,strong)GJGCChatInputPanel *inputPanel;

@property (nonatomic,strong)GJCFAudioPlayer *audioPlayer;

@property (nonatomic,strong)GJGCChatDetailDataSourceManager *dataSourceManager;

@property (nonatomic,strong)UITableView *chatListTable;

@property (nonatomic,readonly)GJGCChatFriendTalkModel *talkInfo;

- (instancetype)initWithTalkInfo:(GJGCChatFriendTalkModel *)talkModel;

/**
 *  列表重新刷新数据,子类必须调用这个更新tableView
 */
- (void)reloadData;

/**
 *  主动停止下拉刷新,子类调用
 */
- (void)stopRefresh;

/**
 *  主动停止加载更多,子类调用
 */
- (void)stopLoadMore;

/**
 *  主动调用下拉刷新,子类调用
 */
- (void)startRefresh;

/**
 *  主动停止下拉刷新,子类调用
 */
- (void)startLoadMore;

/**
 *  触发下拉刷新,子类复写
 */
- (void)triggleRefreshing;

/**
 *  触发加载更多,子类复写
 */
- (void)triggleLoadingMore;

- (void)stopPlayCurrentAudio;

#pragma mark - 收起输入键盘

- (void)reserveChatInputPanelState;

#pragma mark - 文件下载管理

/* 复写下载图片 */
- (void)downloadImageFile:(GJGCChatContentBaseModel *)contentModel forIndexPath:(NSIndexPath *)indexPath;

/* 退出下载 */
- (void)cancelDownloadWithTaskIdentifier:(NSString *)taskIdentifier;

/**
 *  开始下载任务
 *
 *  @param task 
 */
- (void)addDownloadTask:(GJCFFileDownloadTask *)task;

/**
 *  完成下载
 *
 *  @param url      下载链接地址
 *  @param fileData 下载完成数据
 */
- (void)finishDownloadWithTask:(GJCFFileDownloadTask *)task withDownloadFileData:(NSData *)fileData;

/**
 *  文件下载进度
 *
 *  @param url      下载链接地址
 *  @param progress 下载进度
 */
- (void)downloadFileWithTask:(GJCFFileDownloadTask *)task progress:(CGFloat)progress;

/**
 *  文件下载失败
 *
 *  @param url 下载链接地址
 */
- (void)faildDownloadFileWithTask:(GJCFFileDownloadTask *)task;

/**
 *  初始化数据源
 */
- (void)initDataManager;

/**
 *  展示粒子特效
 *
 *  @param imageName
 */
- (void)playParticleEffectWithImageName:(NSString *)imageName;

/**
 *  开始粒子特效了
 *
 *  @param imageName
 */
- (void)didBeginPlayPartilceEffectWithImageName:(NSString *)imageName;

/**
 *  完成了粒子特效
 *
 *  @param imageName
 */
- (void)didFinishPlayParticleEffectImageWithName:(NSString *)imageName;


@end
