//
//  GJGCChatSystemNotiCellDelegate.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-11.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GJGCChatBaseCell;
@protocol GJGCChatBaseCellDelegate <NSObject>

@optional


/* ============================= 系统通知代理方法 ========================= */

#pragma mark - 系统助手的cell事件代理

/**
 *  点击了角色名片
 *
 *  @param tapedCell 被点击的cell
 */
- (void)systemNotiBaseCellDidTapOnRoleView:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了同意申请按钮
 *
 *  @param tapedCell
 */
- (void)systemNotiBaseCellDidTapOnAcceptApplyButton:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了拒绝申请按钮
 *
 *  @param tapedCell
 */
- (void)systemNotiBaseCellDidTapOnRejectApplyButton:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了立即加入按钮
 *
 *  @param tapedCell 
 */
- (void)systemNotiBaseCellDidTapOnSystemActiveGuideButton:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了邀请好友入群
 *
 *  @param tapedCell 
 */
- (void)systemNotiBaseCellDidTapOnInviteFriendJoinGroup:(GJGCChatBaseCell *)tapedCell;

/**
 *  删除系统消息
 *
 *  @param tapedCell 
 */
- (void)systemNotiBaseCellDidChooseDelete:(GJGCChatBaseCell *)tapedCell;


#pragma mark - 好友对话的cell事件代理

/**
 *  点击了帖子
 *
 *  @param tapedCell 
 */
- (void)chatCellDidTapOnPost:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了语音的消息cell
 *
 *  @param tapedCell 
 */
- (void)audioMessageCellDidTap:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了图片消息cell
 *
 *  @param tapedCell 
 */
- (void)imageMessageCellDidTap:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了电话的cell
 *
 *  @param tapedCell
 *  @param phoneNumber
 */
- (void)textMessageCellDidTapOnPhoneNumber:(GJGCChatBaseCell *)tapedCell withPhoneNumber:(NSString *)phoneNumber;

/**
 *  点击了url的cell
 *
 *  @param tapedCell
 *  @param url       
 */
- (void)textMessageCellDidTapOnUrl:(GJGCChatBaseCell *)tapedCell withUrl:(NSString *)url;

/**
 *  点击了cell的删除事件
 *
 *  @param tapedCell 
 */
- (void)chatCellDidChooseDeleteMessage:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了重发事件
 *
 *  @param tapedCell 
 */
- (void)chatCellDidChooseReSendMessage:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击了头像
 *
 *  @param tapedCell 
 */
- (void)chatCellDidTapOnHeadView:(GJGCChatBaseCell *)tapedCell;

/**
 *  长按头像
 *
 *  @param tapedCell 
 */
- (void)chatCellDidLongPressOnHeadView:(GJGCChatBaseCell *)tapedCell;

/**
 *  收藏帖子
 *
 *  @param tapedCell
 */
- (void)chatCellDidChooseFavoritePost:(GJGCChatBaseCell *)tapedCell;

/**
 *  点击新人欢迎card
 */
- (void)chatCellDidTapOnWelcomeMemberCard:(GJGCChatBaseCell *)tappedCell;

/**
 *  点击漂流瓶
 *
 *  @param tappedCell 
 */
- (void)chatCellDidTapOnDriftBottleCard:(GJGCChatBaseCell *)tappedCell;

@end
