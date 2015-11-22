//
//  ZYDataCenterInterface.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZYDataCenterServerHost @"http://localhost/happy_fun/index.php"

//#define ZYDataCenterServerHost @"http://192.168.1.18/happy_fun/index.php"

/**
 *  请求类型
 */
typedef NS_ENUM(NSUInteger, ZYDataCenterRequestType) {
    /**
     *  未知
     */
    ZYDataCenterRequestTypeUnknow = 0,
    /**
     *  注册
     */
    ZYDataCenterRequestTypeRegist,
    /**
     *  登录
     */
    ZYDataCenterRequestTypeLogin,
    /**
     *  所有用户
     */
    ZYDataCenterRequestTypeAllUserList,
    /**
     *  好友申请列表
     */
    ZYDataCenterRequestTypeFriendApplyList,
    /**
     *  申请加好友
     */
    ZYDataCenterRequestTypeApplyAddFriend,
    /**
     *  关系变更
     */
    ZYDataCenterRequestTypeRelationUpdate,
    /**
     *  删除好友
     */
    ZYDataCenterRequestTypeDeleteFriend,
    /**
     *  我的好友列表
     */
    ZYDataCenterRequestTypeMyFriendList,
};

@interface ZYDataCenterInterface : NSObject

+ (NSString *)urlWithRequestType:(ZYDataCenterRequestType)requestType;

@end
