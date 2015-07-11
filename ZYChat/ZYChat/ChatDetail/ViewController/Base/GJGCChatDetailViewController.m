//
//  GJGCChatDetailViewController.m
//  ZYChat
//
//  Created by ZYVincent on 14-10-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatDetailViewController.h"
#import "GJGCChatBaseCell.h"
#import "GJGCChatBaseCellDelegate.h"
#import "GJGCChatFriendBaseCell.h"
#import "GJGCParticleEffectLayer.h"


@interface GJGCChatDetailViewController ()<
                                            GJGCRefreshHeaderViewDelegate
                                          >

@property (nonatomic,strong)GJGCParticleEffectLayer *effectLayer;

@end

@implementation GJGCChatDetailViewController

- (instancetype)initWithTalkInfo:(GJGCChatFriendTalkModel *)talkModel
{
    if (self = [super init]) {
        
        _taklInfo = talkModel;
        
        [self initDataManager];
        
        /* 观察程序前后台切换 */
        [self observeApplicationState];
    }
    return self;
}

- (void)initDataManager
{
    
}

- (void)dealloc
{
    if (self.effectLayer) {
        [self.effectLayer removeFromSuperlayer];
        self.effectLayer = nil;
    }
    
    [self.inputPanel removeObserver:self forKeyPath:@"frame"];
    [self.chatListTable removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
    
    [self.refreshFootView setDelegate:nil];
    [self.refreshHeadView setDelegate:nil];
    [self.dataSourceManager setDelegate:nil];
    self.chatListTable.dataSource = nil;
    self.chatListTable.delegate = nil;
    self.dataSourceManager = nil;
    [GJCFNotificationCenter removeObserver:self];
    
    [[GJCFFileDownloadManager shareDownloadManager] clearTaskBlockForObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubViews];
    
    /* 初始化下载组件 */
    [self configFileDownloadManager];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /* 注销键盘 */
    [self.inputPanel inputBarRegsionFirstResponse];
    
    [self clearAllFirstResponse];
}

- (void)clearAllFirstResponse
{
    [self.inputPanel inputBarRegsionFirstResponse];
    [self cancelMenuVisiableCellFirstResponse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回时候更新草稿
- (void)leftButtonPressed:(id)sender
{
    [super leftButtonPressed:sender];
    
    if (self.taklInfo.talkType != GJGCChatFriendTalkSystemAssist) {
        
        [self.dataSourceManager updateLastMsgForRecentTalk];
        
    }else{
        
        [self.dataSourceManager updateLastSystemMessageForRecentTalk];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化设置
- (void)initSubViews
{
    CGFloat originY = GJCFSystemNavigationBarHeight + GJCFSystemOriginYDelta;
    
    /* 对话列表 */
    self.chatListTable = [[UITableView alloc]init];
    self.chatListTable.dataSource = self;
    self.chatListTable.delegate = self;
    self.chatListTable.backgroundColor = [GJGCChatInputPanelStyle mainBackgroundColor];
    self.chatListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatListTable.frame = (CGRect){0,0,GJCFSystemScreenWidth,GJCFSystemScreenHeight - originY - 50};
    [self.view addSubview:self.chatListTable];
    
    /* 滚动到最底部 */
    if (self.dataSourceManager.totalCount > 0) {
        [self.chatListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceManager.totalCount-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    if (GJCFSystemVersionIs7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    /* 输入面板 */
    self.inputPanel = [[GJGCChatInputPanel alloc]initWithPanelDelegate:self];
    self.inputPanel.frame = (CGRect){0,GJCFSystemScreenHeight-self.inputPanel.inputBarHeight-originY,GJCFSystemScreenWidth,self.inputPanel.inputBarHeight+216};
    
    GJCFWeakSelf weakSelf = self;
    [self.inputPanel configInputPanelKeyboardFrameChange:^(GJGCChatInputPanel *panel,CGRect keyboardBeginFrame, CGRect keyboardEndFrame, NSTimeInterval duration,BOOL isPanelReserve) {
        
        /* 不要影响其他不带输入面板的系统视图对话 */
        if (panel.hidden) {
            return ;
        }
        
        [UIView animateWithDuration:duration animations:^{
            
            weakSelf.chatListTable.gjcf_height = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight - originY - keyboardEndFrame.size.height;

            if (keyboardEndFrame.origin.y == GJCFSystemScreenHeight) {
                
                if (isPanelReserve) {
                    
                    weakSelf.inputPanel.gjcf_top = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight  - originY;
                    
                    weakSelf.chatListTable.gjcf_height = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight - originY;

                }else{
                    
                    weakSelf.inputPanel.gjcf_top = GJCFSystemScreenHeight - 216 - weakSelf.inputPanel.inputBarHeight - originY;
                    
                    weakSelf.chatListTable.gjcf_height = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight - originY - 216;

                }
                
            }else{
                
                weakSelf.inputPanel.gjcf_top = weakSelf.chatListTable.gjcf_bottom;
                
            }

        }];
        
      [weakSelf.chatListTable scrollRectToVisible:CGRectMake(0, weakSelf.chatListTable.contentSize.height - weakSelf.chatListTable.bounds.size.height, weakSelf.chatListTable.gjcf_width, weakSelf.chatListTable.gjcf_height) animated:NO];
        
    }];
    
    [self.inputPanel configInputPanelRecordStateChange:^(GJGCChatInputPanel *panel, BOOL isRecording) {
       
        if (isRecording) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [weakSelf stopPlayCurrentAudio];
                
                weakSelf.chatListTable.userInteractionEnabled = NO;
                
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.chatListTable.userInteractionEnabled = YES;

            });
        }
        
    }];
    
    [self.inputPanel configInputPanelInputTextViewHeightChangedBlock:^(GJGCChatInputPanel *panel, CGFloat changeDelta) {
       
        panel.gjcf_top = panel.gjcf_top - changeDelta;
        
        panel.gjcf_height = panel.gjcf_height + changeDelta;
        
        [UIView animateWithDuration:0.2 animations:^{

            weakSelf.chatListTable.gjcf_height = weakSelf.chatListTable.gjcf_height - changeDelta;

            [weakSelf.chatListTable scrollRectToVisible:CGRectMake(0, weakSelf.chatListTable.contentSize.height - weakSelf.chatListTable.bounds.size.height, weakSelf.chatListTable.gjcf_width, weakSelf.chatListTable.gjcf_height) animated:NO];

        }];
        
    }];
    
    /* 动作变化 */
    [self.inputPanel setActionChangeBlock:^(GJGCChatInputBar *inputBar, GJGCChatInputBarActionType toActionType) {
        [weakSelf inputBar:inputBar changeToAction:toActionType];
    }];
    [self.view addSubview:self.inputPanel];
    
    /* 顶部刷新 */
    self.refreshHeadView = [[GJGCRefreshHeaderView alloc]init];
    self.refreshHeadView.delegate = self;
    [self.refreshHeadView setupChatFooterStyle];
    [self.chatListTable addSubview:self.refreshHeadView];
    
    /* 拉取最新历史消息 */
    [self addOrRemoveLoadMore];
    
    /* 观察输入面板变化 */
    [self.inputPanel addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.chatListTable addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 属性变化观察
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"] && object == self.inputPanel) {
        
        CGRect newFrame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        
        CGFloat originY = GJCFSystemNavigationBarHeight + GJCFSystemOriginYDelta;
        
        //50.f 高度是输入条在底部的时候显示的高度，在录音状态下就是50
        if (newFrame.origin.y < GJCFSystemScreenHeight - 50.f - originY) {
            
            self.inputPanel.isFullState = YES;
            
        }else{
            
            self.inputPanel.isFullState = NO;
        }
    }
    
    if ([keyPath isEqualToString:@"panGestureRecognizer.state"] && object == self.chatListTable) {
        
        UIGestureRecognizerState state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:
            {
                [self makeVisiableGifCellPause];
            }
                break;
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
            {
                [self makeVisiableGifCellResume];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 输入动作变化

- (void)inputBar:(GJGCChatInputBar *)inputBar changeToAction:(GJGCChatInputBarActionType)actionType
{
    CGFloat originY = GJCFSystemNavigationBarHeight + GJCFSystemOriginYDelta;

    switch (actionType) {
        case GJGCChatInputBarActionTypeRecordAudio:
        {
            if (self.inputPanel.isFullState) {
                
                [UIView animateWithDuration:0.26 animations:^{
                    
                    self.inputPanel.gjcf_top = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - originY;
                    
                    self.chatListTable.gjcf_height = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - originY;

                }];

                [self.chatListTable scrollRectToVisible:CGRectMake(0, self.chatListTable.contentSize.height - self.chatListTable.bounds.size.height, self.chatListTable.gjcf_width, self.chatListTable.gjcf_height) animated:NO];
            }
        }
            break;
        case GJGCChatInputBarActionTypeChooseEmoji:
        case GJGCChatInputBarActionTypeExpandPanel:
        {
            if (!self.inputPanel.isFullState) {
                
                [UIView animateWithDuration:0.26 animations:^{
                    
                    self.inputPanel.gjcf_top = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - 216 - originY;
                   
                    self.chatListTable.gjcf_height = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - 216 - originY;

                }];
               

                [self.chatListTable scrollRectToVisible:CGRectMake(0, self.chatListTable.contentSize.height - self.chatListTable.bounds.size.height, self.chatListTable.gjcf_width, self.chatListTable.gjcf_height) animated:NO];
                
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 加载更多

- (void)addOrRemoveLoadMore
{
    /* 是否完成第一次历史数据加载 */
    if (!self.dataSourceManager.isFinishFirstHistoryLoad) {
        
        if (!self.refreshFootView) {
            
            /* 上拉刷新 */
            self.refreshFootView = [[GJGCRefreshFooterView alloc]init];
            [self.refreshFootView setupChatFooterStyle];
            self.refreshFootView.backgroundColor = [UIColor redColor];
            [self.chatListTable addSubview:self.refreshFootView];
            
        }
        
        [self.refreshFootView resetFrameWithTableView:self.chatListTable];
        
        return;
        
    }else{
        
        [self stopLoadMore];
        if (self.refreshFootView) {
            [self.refreshFootView removeFromSuperview];
            self.refreshFootView = nil;
        }
    }
    
}

- (void)reloadData
{
    [self cancelMenuVisiableCellFirstResponse];

    [self.chatListTable reloadData];
    [self stopRefresh];
    [self stopLoadMore];
    [self addOrRemoveLoadMore];
    
}

- (void)reloadDataStopRefreshNoAnimated
{
    [self cancelMenuVisiableCellFirstResponse];
    
    [self.chatListTable reloadData];
    [self stopRefreshNoAnimated];
    [self stopLoadMore];
    [self addOrRemoveLoadMore];

}
#pragma mark - 下拉刷新代理方法
- (void)refreshHeaderViewTriggerRefresh:(GJGCRefreshHeaderView *)headerView
{    
    [self triggleRefreshing];
}

#pragma mark - 下拉，加载开始和停止
/**
 *  主动停止下拉刷新,子类调用
 */
- (void)stopRefresh
{
    if (self.refreshHeadView) {
        [self.refreshHeadView stopLoadingForScrollView:self.chatListTable];
    }
}

/**
 *  主动停止下拉刷新，但是没有动画
 */
- (void)stopRefreshNoAnimated
{
    if (self.refreshHeadView) {
        [self.refreshHeadView stopLoadingForScrollView:self.chatListTable isAnimation:NO];
    }
}
/**
 *  主动停止加载更多,子类调用
 */
- (void)stopLoadMore
{
    if (self.refreshFootView) {
        [self.refreshFootView stopLoadingForScrollView:self.chatListTable];
    }
}

/**
 *  主动调用下拉刷新,子类调用
 */
- (void)startRefresh
{
    if (self.refreshHeadView) {
        [self.refreshHeadView startLoadingForScrollView:self.chatListTable];
    }
}

/**
 *  主动开始下拉刷新,子类调用
 */
- (void)startLoadMore
{
    [self addOrRemoveLoadMore];
    [self.refreshFootView resetFrameWithTableView:self.chatListTable];
    [self.refreshFootView startLoadingForScrollView:self.chatListTable];
}

- (void)stopPlayAudio
{
    
}

#pragma mark - 实际调用
- (void)triggleRefreshing
{
    /* 拉取历史消息 */
    [self.dataSourceManager trigglePullHistoryMsgForEarly];
}

- (void)triggleLoadingMore
{
    
}

- (void)stopPlayCurrentAudio
{
    
}

#pragma mark - 暂停Gif动画

- (void)makeVisiableGifCellPause
{
    [self.chatListTable.visibleCells makeObjectsPerformSelector:@selector(pause)];
}

- (void)makeVisiableGifCellResume
{
    [self.chatListTable.visibleCells makeObjectsPerformSelector:@selector(resume)];
}

#pragma mark - 取消cell 第一响应

- (void)cancelMenuVisiableCellFirstResponse
{
    UIMenuController *shareMenuViewController = [UIMenuController sharedMenuController];
    if (shareMenuViewController.isMenuVisible) {
        [shareMenuViewController setMenuVisible:NO animated:YES];
    }
}

#pragma mark - 恢复输入面板到初始状态

- (void)reserveChatInputPanelState
{
    /* 收起输入键盘 */
    if (self.inputPanel.isFullState) {
        
        CGFloat originY = GJCFSystemNavigationBarHeight + GJCFSystemOriginYDelta;
        
        self.inputPanel.gjcf_top = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - originY;
        
        self.chatListTable.gjcf_height = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - originY;
        
        [self.chatListTable scrollRectToVisible:CGRectMake(0, self.chatListTable.contentSize.height - self.chatListTable.bounds.size.height, self.chatListTable.gjcf_width, self.chatListTable.gjcf_height) animated:NO];
        
        [self.inputPanel reserveState];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    /* 取消cell第一响应 */
    [self cancelMenuVisiableCellFirstResponse];
    
    if ([self.inputPanel isInputTextFirstResponse]) {
        
        [self.inputPanel inputBarRegsionFirstResponse];
        
    }
    
    CGFloat originY = GJCFSystemNavigationBarHeight + GJCFSystemOriginYDelta;
    
    if (self.inputPanel.isFullState) {
        
        self.chatListTable.gjcf_height = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - originY;

        [UIView animateWithDuration:0.26 animations:^{
            
            self.inputPanel.gjcf_top = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - originY;
            
        }];
        
        [self.inputPanel reserveState];
    }
    
    if (self.dataSourceManager.isFinishFirstHistoryLoad) {
        
        if (self.dataSourceManager.isFinishLoadAllHistoryMsg == NO) {
            
            [self.refreshHeadView scrollViewWillBeginDragging:scrollView];

        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.dataSourceManager.isFinishFirstHistoryLoad) {
        
        if (self.dataSourceManager.isFinishLoadAllHistoryMsg == NO) {
            
            [self.refreshHeadView scrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.dataSourceManager.isFinishFirstHistoryLoad) {
        
        if (self.dataSourceManager.isFinishLoadAllHistoryMsg == NO) {
            
            [self.refreshHeadView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];

        }
    }
}

#pragma mark - GJCFFileDownloadManager config
- (void)configFileDownloadManager
{
    GJCFWeakSelf weakSelf = self;
    [[GJCFFileDownloadManager shareDownloadManager] setDownloadCompletionBlock:^(GJCFFileDownloadTask *task, NSData *fileData, BOOL isFinishCache) {
        
        [weakSelf finishDownloadWithTask:task withDownloadFileData:fileData];
        
    } forObserver:self];
    
    [[GJCFFileDownloadManager shareDownloadManager] setDownloadFaildBlock:^(GJCFFileDownloadTask *task, NSError *error) {
        
        [weakSelf faildDownloadFileWithTask:task];
        
    } forObserver:self];
    
    [[GJCFFileDownloadManager shareDownloadManager] setDownloadProgressBlock:^(GJCFFileDownloadTask *task, CGFloat progress) {
        
        [weakSelf downloadFileWithTask:task progress:progress];
        
    } forObserver:self];
}

- (void)addDownloadTask:(GJCFFileDownloadTask *)task
{
    [[GJCFFileDownloadManager shareDownloadManager] addTask:task];
}

- (void)finishDownloadWithTask:(GJCFFileDownloadTask *)task withDownloadFileData:(NSData *)fileData;
{
    
}

- (void)downloadFileWithTask:(GJCFFileDownloadTask *)task progress:(CGFloat)progress;
{
    
}

- (void)faildDownloadFileWithTask:(GJCFFileDownloadTask *)task;
{
    
}

- (void)cancelDownloadWithTaskIdentifier:(NSString *)taskIdentifier;
{
    [[GJCFFileDownloadManager shareDownloadManager]cancelTask:taskIdentifier];
}


#pragma mark - tableView Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceManager totalCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     * 对发消息过程中，滚动太快的时候会导致cellClass找不到，这种情况
     * 通常出现在两个人疯狂对发gif表情会出现，导致无法返回正确的cell而crash
     * 所以设定一个空的cell来替换，当滚动慢下来的时候，复用是没有问题的
     */
    static NSString *DefaultBaseCellIdentifier = @"DefaultBaseCellIdentifier";
    
    NSString *identifier = [self.dataSourceManager contentCellIdentifierAtIndex:indexPath.row];
    
    Class cellClass = [self.dataSourceManager contentCellAtIndex:indexPath.row];
    
    if (!cellClass) {
        
        GJGCChatBaseCell *baseCell = (GJGCChatBaseCell *)[tableView dequeueReusableCellWithIdentifier:DefaultBaseCellIdentifier];

        if (!baseCell) {
            
            baseCell = [[GJGCChatBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return baseCell;
    }
    
    GJGCChatBaseCell *baseCell = (GJGCChatBaseCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!baseCell) {
        
        baseCell = [(GJGCChatBaseCell *)[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        baseCell.delegate = self;
    }
    
    [baseCell setContentModel:[self.dataSourceManager contentModelAtIndex:indexPath.row]];
    
    if (tableView.isTracking) {
        
        [baseCell pause];
        
    }else{
        
        [baseCell resume];
    }
    
    [self downloadImageFile:[self.dataSourceManager contentModelAtIndex:indexPath.row] forIndexPath:indexPath];
    
    return baseCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSourceManager rowHeightAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)downloadImageFile:(GJGCChatContentBaseModel *)contentModel forIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - dataSouceManager Delegate

- (void)dataSourceManagerRequireTriggleLoadMore:(GJGCChatDetailDataSourceManager *)dataManager
{
    NSLog(@"聊天详情要求开始加载更多历史消息");
    
    GJCFAsyncMainQueue(^{
        
        [self startLoadMore];
        
    });
    
}

- (void)dataSourceManagerRequireFinishLoadMore:(GJGCChatDetailDataSourceManager *)dataManager
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BOOL isNeedScrollToBottom = NO;
        if (self.chatListTable.contentOffset.y >= self.chatListTable.contentSize.height - self.chatListTable.gjcf_height - self.refreshHeadView.gjcf_height) {
            isNeedScrollToBottom = YES;
        }
        
        [self reloadData];
        
        [self.dataSourceManager resetFirstAndLastMsgId];

        if (isNeedScrollToBottom) {
            
            [self.chatListTable scrollRectToVisible:CGRectMake(0, self.chatListTable.contentSize.height - self.chatListTable.bounds.size.height, self.chatListTable.gjcf_width, self.chatListTable.gjcf_height) animated:NO];
            
        }
        
    });

}

- (void)dataSourceManagerRequireFinishRefresh:(GJGCChatDetailDataSourceManager *)dataManager
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self reloadDataStopRefreshNoAnimated];
        
        if (self.dataSourceManager.lastFirstLocalMsgId) {
            
            NSInteger lastFirstMsgIndex = [self.dataSourceManager getContentModelIndexByLocalMsgId:self.dataSourceManager.lastFirstLocalMsgId];
            
            if (lastFirstMsgIndex >= 0 && lastFirstMsgIndex < self.dataSourceManager.totalCount) {
                
                // 判定上面是否还有更多新拉取的消息，普通聊天，第一条消息索引是1，助手消息第一条消息索引是0 说明上面没有更多数据了,这个应该在原来的位置就行了
                BOOL isNormalFriendChat = lastFirstMsgIndex != 1 && self.dataSourceManager.taklInfo.talkType != GJGCChatFriendTalkSystemAssist;
                BOOL isSystemAssistChat = lastFirstMsgIndex != 0 && self.dataSourceManager.taklInfo.talkType == GJGCChatFriendTalkSystemAssist;
                
                if (isNormalFriendChat || isSystemAssistChat) {
                    
                    NSIndexPath *moveToPath = [NSIndexPath indexPathForRow:lastFirstMsgIndex inSection:0];

                    [self.chatListTable scrollToRowAtIndexPath:moveToPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

                    /* 
                     *  28: 单行时间cell的高度
                     *  50: refreshHeadView的高度
                     */
                    [self.chatListTable setContentOffset:CGPointMake(0, self.chatListTable.contentOffset.y - 28 - 50) animated:NO];
                    
                }else{
                    
                    /* 没有了要停在时间cell上面，否则还是会顶上去 */
                    NSIndexPath *moveToPath = [NSIndexPath indexPathForRow:lastFirstMsgIndex-1 inSection:0];
                    
                    [self.chatListTable scrollToRowAtIndexPath:moveToPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    
                }
                
                [self.dataSourceManager resetFirstAndLastMsgId];

            }
            
        }
    });
}


- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager
{
    dispatch_async(dispatch_get_main_queue(),^{
        
        BOOL isNeedScrollToBottom = NO;
        if (self.chatListTable.contentOffset.y >= self.chatListTable.contentSize.height - self.chatListTable.gjcf_height - self.refreshHeadView.gjcf_height) {
            isNeedScrollToBottom = YES;
        }
        
        [self reloadData];
        
        if (isNeedScrollToBottom) {
            
            [self.chatListTable scrollRectToVisible:CGRectMake(0, self.chatListTable.contentSize.height - self.chatListTable.bounds.size.height, self.chatListTable.gjcf_width, self.chatListTable.gjcf_height) animated:NO];
            
        }
        
        [self setStrNavTitle:self.dataSourceManager.title];
    });
    
}

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager reloadAtIndex:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (index >= 0 && index < self.dataSourceManager.totalCount) {
            
            NSIndexPath *reloadPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.chatListTable reloadRowsAtIndexPaths:@[reloadPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    });
}

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager reloadForUpdateMsgStateAtIndex:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (index >= 0 && index < self.dataSourceManager.totalCount) {
            
            NSIndexPath *reloadPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            /* 鉴定是否可见 */
            if (![[self.chatListTable indexPathsForVisibleRows] containsObject:reloadPath]) {
                return ;
            }
            
            GJGCChatFriendBaseCell *chatCell = (GJGCChatFriendBaseCell *)[self.chatListTable cellForRowAtIndexPath:reloadPath];
            GJGCChatContentBaseModel *contentModel = [self.dataSourceManager contentModelAtIndex:index];
            
            if ([chatCell isKindOfClass:[GJGCChatFriendBaseCell class]]) {
                
                [chatCell setSendStatus:contentModel.sendStatus];
                [chatCell faildWithType:contentModel.faildType andReason:contentModel.faildReason];
                
            }
        }
        
    });
}

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager insertWithIndex:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (index >= 0 && index < self.dataSourceManager.totalCount) {
       
            [self cancelMenuVisiableCellFirstResponse];

            NSIndexPath *insertPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            [self.chatListTable insertRowsAtIndexPaths:@[insertPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    });
}

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager insertIndexPaths:(NSArray *)indexPaths
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (indexPaths.count > 0) {
            
            [self cancelMenuVisiableCellFirstResponse];
            
            [self.chatListTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    });
}

#pragma mark - 观察进入后台和进入前台的处理
- (void)observeApplicationState
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)becomeActive:(NSNotification*)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self reloadData];
        
    });
}

#pragma mark - 展示粒子特效

- (void)playParticleEffectWithImageName:(NSString *)imageName
{
    if (GJCFStringIsNull(imageName)) {
        return;
    }
    
    if (self.effectLayer) {
        [self.effectLayer removeFromSuperlayer];
        self.effectLayer = nil;
    }
    
    self.effectLayer = [[GJGCParticleEffectLayer alloc]initWithImageName:imageName];
    self.effectLayer.delayHideTime = 2;
    [self.view.layer insertSublayer:self.effectLayer below:self.inputPanel.layer];
    
    [self didBeginPlayPartilceEffectWithImageName:imageName];
    
    [self performSelector:@selector(removeParticleEffectWithImageName:) withObject:imageName afterDelay:4.5];
}

- (void)didBeginPlayPartilceEffectWithImageName:(NSString *)imageName
{
    
}

- (void)removeParticleEffectWithImageName:(NSString *)imageName
{
    [self.effectLayer removeFromSuperlayer];
    
    [self didFinishPlayParticleEffectImageWithName:imageName];
}

- (void)didFinishPlayParticleEffectImageWithName:(NSString *)imageName
{
    
}

@end
