//
//  GJGCForwardEngine.h
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCContactsContentModel.h"

@interface GJGCForwardEngine : NSObject

+ (void)pushChatWithContactInfo:(GJGCContactsContentModel *)contactModel;

@end
