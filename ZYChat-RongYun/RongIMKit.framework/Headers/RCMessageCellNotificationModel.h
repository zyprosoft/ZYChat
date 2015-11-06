//
//  RCMessageCellNotificationModel.h
//  RongIMKit
//
//  Created by xugang on 15/1/29.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RCMessageCellNotificationModel
#define __RCMessageCellNotificationModel
#import <UIKit/UIKit.h>

// Status for sending message.
UIKIT_EXTERN NSString *const CONVERSATION_CELL_STATUS_SEND_BEGIN;
UIKIT_EXTERN NSString *const CONVERSATION_CELL_STATUS_SEND_FAILED;
UIKIT_EXTERN NSString *const CONVERSATION_CELL_STATUS_SEND_SUCCESS;
UIKIT_EXTERN NSString *const CONVERSATION_CELL_STATUS_SEND_PROGRESS;
UIKIT_EXTERN NSString *const CONVERSATION_CELL_DATA_IMAGE_KEY_UPDATE;
UIKIT_EXTERN NSString *const CONVERSATION_CELL_STATUS_SEND_HASREAD;

#import <Foundation/Foundation.h>

/**
 *  用于向cell发送通知的数据模型
 */
@interface RCMessageCellNotificationModel : NSObject
/**
 *  messageId
 */
@property(nonatomic) long messageId;
/**
 *  actionName
 */
@property(strong, nonatomic) NSString *actionName;
/**
 *  progress
 */
@property(nonatomic) NSInteger progress;

@end
#endif