//
//  GJGCInfoBaseListConst.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  列表内容类型
 */
typedef NS_ENUM(NSUInteger, GJGCInfoBaseListContentType){
    /**
     *  角色展示
     */
    GJGCInfoBaseListContentTypeUserRole,
    /**
     *  群角色展示
     */
    GJGCInfoBaseListContentTypeGroupRole,
};

@interface GJGCInfoBaseListConst : NSObject

+ (Class)cellClassForContentType:(GJGCInfoBaseListContentType)contentType;

+ (NSString *)cellIdentifierForContentType:(GJGCInfoBaseListContentType)contentType;

@end
