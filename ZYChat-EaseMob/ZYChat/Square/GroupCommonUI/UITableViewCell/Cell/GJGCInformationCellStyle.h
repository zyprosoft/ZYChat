//
//  GJGCInformationCellStyle.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatSystemNotiCellStyle.h"

@interface GJGCInformationCellStyle : NSObject


/* 相册里面得标签 */
+ (NSAttributedString *)formatePersonPhotoBoxName:(NSString *)name;

+ (NSAttributedString *)formatePersonPhotoBoxDistanceOrTime:(NSString *)distanceOrTime;

+ (NSAttributedString *)formatePersonPhotoBoxWomenAge:(NSString *)age;

+ (NSAttributedString *)formatePersonPhotoBoxManAge:(NSString *)age;

+ (NSAttributedString *)formatePersonPhotoBoxStarNameOrHelloCount:(NSString *)starNameOrHelloCount;

+ (NSAttributedString *)formateGroupPhotoBoxName:(NSString *)name;

+ (NSAttributedString *)formateGroupPhotoBoxDistance:(NSString *)distance;

/* 基础 text cell */

+ (NSAttributedString *)formateBaseTextTag:(NSString *)tag;

+ (NSAttributedString *)formateBaseTextContent:(NSString *)content;

/* 简介，需要有换行距离 */
+ (NSAttributedString *)formateSummaryText:(NSString *)summary;

/* 动态内容 */
+ (NSAttributedString *)formateFeedContent:(NSString *)content;

/* 字符串加省略号 */
+ (NSAttributedString *)formateNameTrailMode:(NSString *)name;

@end
