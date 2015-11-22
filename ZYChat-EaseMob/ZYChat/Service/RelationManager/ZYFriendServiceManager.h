//
//  ZYFriendServiceManager.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserModel.h"
#import "ZYDataCenter.h"

@interface ZYFriendServiceManager : NSObject

- (void)registUser:(ZYUserModel *)aUser withSuccess:(void (^)(ZYUserModel *resultUser))success withFaild:(void (^)(NSError *error))faild;

- (void)loginUser:(ZYUserModel *)aUser;

- (void)allUsrListWithSuccess:(ZYServiceManagerListModelResultSuccessBlock)success withFaild:(ZYServiceManagerRequestFaildBlock)faild;

- (void)friendList;

- (void)friendApplyList;

- (void)approveFriendApply:(ZYUserModel *)friendUser;

@end
