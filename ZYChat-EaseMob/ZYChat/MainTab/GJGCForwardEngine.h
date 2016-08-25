//
//  GJGCForwardEngine.h
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCContactsContentModel.h"
#import "BTTabBarRootController.h"

@interface GJGCForwardEngine : NSObject

+ (BTTabBarRootController *)tabBarVC;

+ (void)pushChatWithContactInfo:(GJGCContactsContentModel *)contactModel;

@end
