//
//  GJGCGIFLoadManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/6/18.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCGIFLoadManager : NSObject

+ (BOOL)gifEmojiIsExistById:(NSString *)gifEmojiId;

+ (NSData *)getCachedGifDataById:(NSString *)gifEmojiId;

+ (NSString *)gifCachePathById:(NSString *)gifEmojiId;

+ (NSString *)gifNameById:(NSString *)gifEmojiId;

@end
