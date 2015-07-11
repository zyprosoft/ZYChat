//
//  GJGCChatContentEmojiParser.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-26.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCChatContentEmojiParser : NSObject

+ (NSDictionary *)parseContent:(NSString *)string;

+ (void)parseEmoji:(NSMutableString *)originString withEmojiTempString:(NSMutableString *)tempString withResultArray:(NSMutableArray *)resultArray;

@end
