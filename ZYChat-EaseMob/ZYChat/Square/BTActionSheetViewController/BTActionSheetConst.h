//
//  BTActionSheetConst.h
//  ZYChat
//
//  Created by ZYVincent on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, BTActionSheetContentType) {
    BTActionSheetContentTypeSimpleText,
    BTActionSheetContentTypeNameAndDetail,
};

@interface BTActionSheetConst : NSObject

+ (Class)cellClassForContentType:(BTActionSheetContentType)contentType;

+ (NSString *)cellIdentifierForContentType:(BTActionSheetContentType)contentType;

@end
