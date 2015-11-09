//
//  ZYUserCenter.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYUserModel.h"

@interface ZYUserCenter : NSObject

+ (ZYUserCenter *)shareCenter;

- (void)registUser:(ZYUserModel *)aUser withResult:(void (^)(BOOL state))resultBlock;

- (void)loginUser:(ZYUserModel *)aUser withResult:(void(^)(BOOL state))resultBlock;

- (void)loginTestUser;

- (ZYUserModel *)currentLoginUser;

- (void)createUserTable;

- (void)createUser;

@end
