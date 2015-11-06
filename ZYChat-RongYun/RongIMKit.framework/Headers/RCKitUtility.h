//
//  RCKitUtility.h
//  iOS-IMKit
//
//  Created by xugang on 7/7/14.
//  Copyright (c) 2014 Heq.Shinoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

@interface RCKitUtility : NSObject

+ (NSString *)ConvertMessageTime:(long long)secs;

+ (NSString *)ConvertChatMessageTime:(long long)secs;

+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (NSString *)formatMessage:(RCMessageContent *)messageContent;

+ (NSString *)localizedDescription:(RCMessageContent *)messageContent;

+ (NSDictionary *)getNotificationUserInfoDictionary:(RCMessage *)message;

+ (NSDictionary *)getNotificationUserInfoDictionary:(RCConversationType)conversationType fromUserId:(NSString *)fromUserId targetId:(NSString *)targetId messageContent:(RCMessageContent *)messageContent;
@end
