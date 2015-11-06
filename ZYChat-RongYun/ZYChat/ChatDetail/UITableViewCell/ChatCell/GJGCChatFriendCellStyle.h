//
//  GJGCChatFirendCellStyle.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCChatFriendCellStyle : NSObject

+ (NSString *)imageTag;

+ (NSDictionary *)formateSimpleTextMessage:(NSString *)messageText;

+ (NSAttributedString *)formateAudioDuration:(NSString *)duration;

/* 灰度消息提醒 */
+ (NSAttributedString *)formateMinMessage:(NSString *)msg;

+ (NSAttributedString *)formateGroupChatSenderName:(NSString *)senderName;

+ (NSAttributedString *)formatePostTitle:(NSString *)postTitle;

/* 群新人欢迎card 样式 */

/**
 *  标题样式
 */
+ (NSAttributedString *)formateTitleString:(NSString *)title;

/* 年轻女性名字标签风格 */
+ (NSAttributedString *)formateYoungWomenNameString:(NSString *)name;

/* 名字标签风格 */
+ (NSAttributedString *)formateNameString:(NSString *)name;

/* 男年龄标签 */
+ (NSAttributedString *)formateManAge:(NSString *)manAge;

/* 女年龄标签 */
+ (NSAttributedString *)formateWomenAge:(NSString *)womenAge;

/* 星座标签 */
+ (NSAttributedString *)formateStarName:(NSString *)starName;

/* 群主召唤card样式 */

+ (NSAttributedString *)formateGroupCallTitle:(NSString *)title;

+ (NSAttributedString *)formateGroupCallContent:(NSString *)content;

/* 接受群主召唤card样式 */

+ (NSAttributedString *)formateAcceptGroupCallContent:(NSString *)content;

/* 漂流瓶样式 */

+ (NSAttributedString *)formateDriftBottleContent:(NSString *)content;

@end
