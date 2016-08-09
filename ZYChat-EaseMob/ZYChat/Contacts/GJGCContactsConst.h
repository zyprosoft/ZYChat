//
//  GJGCContactsConst.h
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GJGCContactsContentType) {
    GJGCContactsContentTypeHeader,
    GJGCContactsContentTypeName,
    GJGCContactsContentTypeUser,
};

@interface GJGCContactsConst : NSObject

+ (Class)cellClassForContentType:(GJGCContactsContentType)contentType;

+ (NSString *)cellIdentifierForContentType:(GJGCContactsContentType)contentType;

@end
