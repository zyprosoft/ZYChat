//
//  GJGCChatDetailDataSourceManager.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatBaseConstans.h"
#import "GJGCChatBaseCell.h"
#import "GJGCChatSystemNotiModel.h"
#import "GJGCChatSystemNotiConstans.h"
#import "GJGCChatFriendConstans.h"
#import "GJGCChatFriendContentModel.h"
#import "GJGCChatContentBaseModel.h"
#import "GJGCChatAuthorizAskCell.h"
#import "GJGCChatSystemNotiCellStyle.h"
#import "GJGCChatFriendCellStyle.h"
#import "GJGCChatFriendContentModel.h"
#import "GJGCChatFriendTalkModel.h"

@class GJGCChatDetailDataSourceManager;

@protocol GJGCChatDetailDataSourceManagerDelegate <NSObject>

@optional

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager;

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager reloadAtIndex:(NSInteger)index;

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager reloadForUpdateMsgStateAtIndex:(NSInteger)index;

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager insertWithIndex:(NSInteger)index;

- (void)dataSourceManagerRequireTriggleLoadMore:(GJGCChatDetailDataSourceManager *)dataManager;

- (void)dataSourceManagerRequireFinishLoadMore:(GJGCChatDetailDataSourceManager *)dataManager;

- (void)dataSourceManagerRequireFinishRefresh:(GJGCChatDetailDataSourceManager *)dataManager;

- (void)dataSourceManagerRequireDeleteMessages:(GJGCChatDetailDataSourceManager *)dataManager deletePaths:(NSArray *)paths;

- (void)dataSourceManagerRequireUpdateListTable:(GJGCChatDetailDataSourceManager *)dataManager insertIndexPaths:(NSArray *)indexPaths;

- (void)dataSourceManagerRequireChangeAudioRecordEnableState:(GJGCChatDetailDataSourceManager *)dataManager state:(BOOL)enable;

- (void)dataSourceManagerRequireAutoPlayNextAudioAtIndex:(NSInteger)index;

@end

@interface GJGCChatDetailDataSourceManager : NSObject

@property (nonatomic,readonly)NSString *uniqueIdentifier;

@property (nonatomic,weak)id<GJGCChatDetailDataSourceManagerDelegate> delegate;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSMutableArray *chatListArray;

@property (nonatomic,strong)NSMutableArray *timeShowSubArray;

@property (nonatomic,readonly)GJGCChatFriendTalkModel *taklInfo;

@property (nonatomic,assign)BOOL isFinishFirstHistoryLoad;

@property (nonatomic,assign)BOOL isFinishLoadAllHistoryMsg;

/**
 *  当前第一条消息得msgId
 */
@property (nonatomic,copy)NSString *lastFirstLocalMsgId;

- (instancetype)initWithTalk:(GJGCChatFriendTalkModel *)talk withDelegate:(id<GJGCChatDetailDataSourceManagerDelegate>)aDelegate;

- (NSInteger)totalCount;

- (NSInteger)chatContentTotalCount;

- (Class)contentCellAtIndex:(NSInteger)index;

- (NSString *)contentCellIdentifierAtIndex:(NSInteger)index;

- (GJGCChatContentBaseModel *)contentModelAtIndex:(NSInteger)index;

- (NSArray *)heightForContentModel:(GJGCChatContentBaseModel *)contentModel;

- (CGFloat)rowHeightAtIndex:(NSInteger)index;

/**
 *  更新语音播放状态为已读,子类需要实现
 *
 *  @param localMsgId
 */
- (void)updateAudioFinishRead:(NSString *)localMsgId;

/**
 *  更新数据源对象，并且会影响数据源高度
 *
 *  @param contentModel
 *  @param index
 */
- (NSNumber *)updateContentModel:(GJGCChatContentBaseModel *)contentModel atIndex:(NSInteger)index;

/**
 *  更新数据库中对应得消息高度
 *
 *  @param contentModel
 */
- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel;


/**
 *  更新数据源对象的某些值，但是并不影响数据源高度
 *
 *  @param contentModel
 *  @param index
 */
- (void)updateContentModelValuesNotEffectRowHeight:(GJGCChatContentBaseModel *)contentModel atIndex:(NSInteger)index;

- (NSNumber *)addChatContentModel:(GJGCChatContentBaseModel *)contentModel;

- (void)removeChatContentModelAtIndex:(NSInteger)index;

- (void)resortAllChatContentBySendTime;

- (void)resortAllSystemNotiContentBySendTime;

- (void)resetFirstAndLastMsgId;

- (void)readLastMessagesFromDB;

- (void)updateAllMsgTimeShowString;

- (void)updateTheNewMsgTimeString:(GJGCChatContentBaseModel *)contentModel;

- (NSString *)updateMsgContentTimeStringAtDeleteIndex:(NSInteger)index;

- (void)removeContentModelByIdentifier:(NSString *)identifier;

- (void)removeTimeSubByIdentifier:(NSString *)identifier;

- (NSInteger)getContentModelIndexByLocalMsgId:(NSString *)msgId;

- (GJGCChatContentBaseModel *)contentModelByMsgId:(NSString *)msgId;

- (NSArray *)deleteMessageAtIndex:(NSInteger)index;

- (void)updateAudioUrl:(NSString *)audioUrl withLocalMsg:(NSString *)localMsgId toId:(NSString *)toId;

- (void)updateImageUrl:(NSString *)imageUrl withLocalMsg:(NSString *)localMsgId toId:(NSString *)toId;

- (void)trigglePullHistoryMsg;

- (void)trigglePullHistoryMsgForEarly;

/**
 *  重新发送所有正在发送状态的消息
 */
- (void)reTryAllSendingStateMsg;

- (void)reTryAllSendingStateMsgDetailAction;

/**
 *  发收到消息的通知
 *
 *  @param array <#array description#>
 */
- (void)pushAddMoreMsg:(NSArray *)array;

/**
 *  更新会话最后一条消息
 *
 *  @param contentModel 
 */
- (void)updateLastMsg:(GJGCChatFriendContentModel *)contentModel;

/**
 *  为对应会话更新最后一条消息
 */
- (void)updateLastMsgForRecentTalk;

/**
 *  系统消息更新最后一条会话
 */
- (void)updateLastSystemMessageForRecentTalk;

#pragma mark - 将数据添加到数据监听进程中，要求UI刷新

- (void)insertNewMessageWithStartIndex:(NSInteger)startIndex Count:(NSInteger)count;

/**
 *  清除过早历史消息
 */
- (void)clearOverEarlyMessage;

/**
 *  重新尝试取历史消息，当历史消息和本地区间消息有交集了
 *
 *  @return
 */
- (NSArray *)reTryGetLocalMessageWhileHistoryMessageIsSubMessagesOfLocalMessages;


/**
 *  模拟发送一条消息
 *
 *  @param messageContent
 */
- (void)mockSendAnMesssage:(GJGCChatFriendContentModel *)messageContent;


@end
