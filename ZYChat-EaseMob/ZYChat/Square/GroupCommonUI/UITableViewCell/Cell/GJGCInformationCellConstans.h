//
//  GJGCInformationCellConstans.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  资料cell类型
 */
typedef NS_ENUM(NSUInteger, GJGCInformationContentType) {
    /**
     *  基本内容cell
     */
    GJGCInformationContentTypeBaseTextContent,
    /**
     *  等级cell
     */
    GJGCInformationContentTypeLevelType,
    /**
     *  个人加入的最近三个群组
     */
    GJGCInformationContentTypeGroupShow,
    /**
     *  群成员三个
     */
    GJGCInformationContentTypeMemberShow,
    /**
     *  文本内容带右侧icon
     */
    GJGCInformationContentTypeBaseTextAndIcon,
    /**
     *  个人相册展示
     */
    GJGCInformationContentTypePersonPhotoBox,
    /**
     *  群组相册展示
     */
    GJGCInformationContentTypeGroupPhotoBox,
    /**
     *  动态展示
     */
    GJGCInformationContentTypeFeedList,
    /**
     *  群组头像信息
     */
    GJGCInformationContentTypeGroupHeadInfo,
};

@interface GJGCInformationCellConstans : NSObject

+ (NSString *)identifierForContentType:(GJGCInformationContentType)contentType;

+ (Class)classForContentType:(GJGCInformationContentType)contentType;

@end
