//
//  GJGCChatContentEmojiParser.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-26.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCChatContentEmojiParser : NSObject

+ (NSDictionary *)parseContent:(NSString *)string;

+ (NSDictionary *)parseRecentContent:(NSString *)string;

+ (void)parseEmoji:(NSMutableString *)originString withEmojiTempString:(NSMutableString *)tempString withResultArray:(NSMutableArray *)resultArray;

@end
