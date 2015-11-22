//
//  GJGCCreateGroupConst.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  分割线风格
 */
typedef NS_ENUM(NSUInteger, GJGCCreateGroupCellSeprateLineStyle){
    /**
     *  顶部没底部没
     */
    GJGCCreateGroupCellSeprateLineStyleTopNoneBottomNone,
    /**
     *  顶部没，底部有
     */
    GJGCCreateGroupCellSeprateLineStyleTopNoneBottomShow,
    /**
     *  顶部有，底部没
     */
    GJGCCreateGroupCellSeprateLineStyleTopShowBottomNone,
    /**
     *  顶部有，底部有
     */
    GJGCCreateGroupCellSeprateLineStyleTopShowBottomShow,
};

/**
 *  创建群组表单内容
 */
typedef NS_ENUM(NSUInteger, GJGCCreateGroupContentType) {
    /**
     *  群名字
     */
    GJGCCreateGroupContentTypeSubject,
    /**
     *  群简介
     */
    GJGCCreateGroupContentTypeDescription,
    /**
     *  群位置
     */
    GJGCCreateGroupContentTypeLocation,
    /**
     *  群标签
     */
    GJGCCreateGroupContentTypeLabels,
    /**
     *  群地址
     */
    GJGCCreateGroupContentTypeAddress,
    /**
     *  群头像
     */
    GJGCCreateGroupContentTypeHeadThumb,
    /**
     *  群人数选择
     */
    GJGCCreateGroupContentTypeMemberCount,
    /**
     *  群组类型
     */
    GJGCCreateGroupContentTypeGroupType,
    /**
     *  公司组织
     */
    GJGCCreateGroupContentTypeCompany,
};

@interface GJGCCreateGroupConst : NSObject

+ (Class)cellClassForContentType:(GJGCCreateGroupContentType)contentType;

+ (NSString *)cellIdentifierForContentType:(GJGCCreateGroupContentType)contentType;

+ (NSString *)levelForGroupMemberCount:(NSInteger )groupMemberCount;

@end
