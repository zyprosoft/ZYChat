//
//  GJGCPersonInformationViewController.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/22.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCInformationBaseViewController.h"
#import "GJGCMessageExtendModel.h"

@interface GJGCPersonInformationViewController : GJGCInformationBaseViewController

- (instancetype)initWithExtendUser:(GJGCMessageExtendUserModel *)aUser withUserId:(NSString *)userId;

@end
