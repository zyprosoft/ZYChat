//
//  GJGCRecentChatStyle.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCRecentChatStyle : NSObject

+ (NSAttributedString *)formateName:(NSString *)name;

+ (NSAttributedString *)formateTime:(long long)time;

+ (NSAttributedString *)formateContent:(NSString *)content;

@end
