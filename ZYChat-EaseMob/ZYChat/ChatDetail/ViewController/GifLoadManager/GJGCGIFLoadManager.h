//
//  GJGCGIFLoadManager.h
//  ZYChat
//
//  Created by ZYVincent on 15/6/18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCGIFLoadManager : NSObject

+ (BOOL)gifEmojiIsExistById:(NSString *)gifEmojiId;

+ (NSData *)getCachedGifDataById:(NSString *)gifEmojiId;

+ (NSString *)gifCachePathById:(NSString *)gifEmojiId;

@end
