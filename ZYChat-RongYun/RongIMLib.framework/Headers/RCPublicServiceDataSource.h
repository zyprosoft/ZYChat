//
//  RCDetailUserInfoDataSource.h
//  RongIMLib
//
//  Created by litao on 15/8/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef RongIMLib_RCPublicServiceDataSource_h
#define RongIMLib_RCPublicServiceDataSource_h
#import "RCDetailUserInfo.h"

@protocol RCPublicServiceDataSource <NSObject>
- (void)getCurrentUserDetailInfoWithCompletion:(void(^)(RCDetailUserInfo* userInfo))completion;
- (void)isNeedAuthorizationForPublicServiceType:(RCPublicServiceType)publicServiceType publicServiceId:(NSString *)publicServiceId publicServiceName:(NSString *)publicServiceName withCompletion:(void(^)(BOOL needed))completion;
@end
#endif
