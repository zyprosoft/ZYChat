//
//  ZYUserCenter.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserModel.h"
#import "GJGCMessageExtendUserModel.h"

#define ZYUserCenterLoginSuccessNoti @"ZYUserCenterLoginSuccessNoti"

#define ZYUserCenterLoginEaseMobSuccessNoti @"ZYUserCenterLoginEaseMobSuccessNoti"

typedef void (^ZYUserCenterRequestSuccessBlock)(NSString *message);

typedef void (^ZYUserCenterRequestFaildBlock)(NSError *error);

@interface ZYUserCenter : NSObject

+ (ZYUserCenter *)shareCenter;

- (void)registUserWithMobile:(NSString *)mobile
                withPassword:(NSString *)password
                 withSuccess:(ZYUserCenterRequestSuccessBlock)success
                   withFaild:(ZYUserCenterRequestFaildBlock)faild;

- (void)LoginUserWithMobile:(NSString *)mobile
                withPassword:(NSString *)password
                 withSuccess:(ZYUserCenterRequestSuccessBlock)success
                   withFaild:(ZYUserCenterRequestFaildBlock)faild;

- (void)LogoutWithSuccess:(ZYUserCenterRequestSuccessBlock)success
               withFaild:(ZYUserCenterRequestFaildBlock)faild;

- (GJGCMessageExtendUserModel *)extendUserInfo;

- (BOOL)isLogin;

- (ZYUserModel *)currentLoginUser;

- (NSString *)getLastUserPassword;

- (void)createUserTable;

- (void)updateNickname:(NSString *)nickname;

- (void)updateAvatar:(NSString *)imageUrl;

- (void)autoLogin;

- (void)createUser;

- (void)updateUsers;

- (void)deleteUser;

- (void)queryUser;

@end
