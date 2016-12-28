//
//  GJGCRecentChatStyle.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/18.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCRecentChatStyle : NSObject

+ (NSAttributedString *)formateName:(NSString *)name;

+ (NSAttributedString *)formateTime:(long long)time;

+ (void)formateContent:(NSString *)content;

@end
