//
//  GJCFCoreTextImageScriptParser.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-12.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFCoreTextImageAttributedStringStyle.h"

@class GJCFCoreTextImageScriptParser;

@protocol GJCFCoreTextImageScriptParserDelegate <NSObject>

@required

//要求图片标签必须实现的代理协议来解析成合法的格式,解析返回的是图片字符串对象的数组
- (GJCFCoreTextImageAttributedStringStyle *)formateImageScript:(NSString *)imageScript;

@end


@interface GJCFCoreTextImageScriptParser : NSObject

@end
