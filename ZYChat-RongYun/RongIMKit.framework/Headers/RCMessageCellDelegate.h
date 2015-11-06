//
//  RCMessageCellDelegate.h
//  RongIMKit
//
//  Created by xugang on 3/14/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#ifndef RongIMKit_RCMessageCellDelegate_h
#define RongIMKit_RCMessageCellDelegate_h
#import "RCMessageModel.h"

/**
 *  消息Cell事件回调
 */
@protocol RCMessageCellDelegate <NSObject>

@optional
;
/**
 *  点击消息内容
 *
 *  @param model 数据
 */
- (void)didTapMessageCell:(RCMessageModel *)model;

/**
 *  点击消息内容中的链接，此事件不会再触发didTapMessageCell
 *
 *  @param url   Url String
 *  @param model 数据
 */
- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model;

/**
 *  点击消息内容中的电话号码，此事件不会再触发didTapMessageCell
 *
 *  @param phoneNumber Phone number
 *  @param model       数据
 */
- (void)didTapPhoneNumberInMessageCell:(NSString *) phoneNumber model:(RCMessageModel *)model;

/**
 *  点击头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didTapCellPortrait:(NSString *)userId;

/**
 *  长按头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didLongPressCellPortrait:(NSString *)userId;

/**
 *  长按消息内容
 *
 *  @param model 数据
 *  @param view 视图
 */
- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view;

/**
 * 点击消息发送失败视图事件
 *
 *  @param model 消息数据模型
 */
- (void)didTapmessageFailedStatusViewForResend:(RCMessageModel *)model;
@end

/**
 *  公众账号消息Cell事件回调
 */
@protocol RCPublicServiceMessageCellDelegate <NSObject>

@optional
;
/**
 *  点击公众账号消息内容
 *
 *  @param model 数据
 */
- (void)didTapPublicServiceMessageCell:(RCMessageModel *)model;

/**
 *  点击公众账号消息内容中的链接，此事件不会再触发didTapPublicServiceMessageCell
 *
 *  @param url   Url String
 *  @param model 数据
 */
- (void)didTapUrlInPublicServiceMessageCell:(NSString *)url model:(RCMessageModel *)model;

/**
 *  点击公众账号消息内容中的电话号码，此事件不会再触发didTapPublicServiceMessageCell
 *
 *  @param phoneNumber Phone number
 *  @param model       数据
 */
- (void)didTapPhoneNumberInPublicServiceMessageCell:(NSString *) phoneNumber model:(RCMessageModel *)model;

/**
 *  长按公众账号消息内容
 *
 *  @param model 数据
 *  @param view  视图
 */
- (void)didLongTouchPublicServiceMessageCell:(RCMessageModel *)model inView:(UIView *)view;

/**
 * 点击公众账号消息发送失败视图事件
 *
 *  @param model 消息数据模型
 */
- (void)didTapPublicServiceMessageFailedStatusViewForResend:(RCMessageModel *)model;
@end
#endif
