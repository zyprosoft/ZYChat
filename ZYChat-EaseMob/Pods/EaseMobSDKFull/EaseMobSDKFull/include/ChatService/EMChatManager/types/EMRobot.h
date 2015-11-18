//
//  EMRobot.h
//  EaseMobClientSDK
//
//  Created by EaseMob on 15/6/29.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMRobot : NSObject

+ (instancetype) robotWithDictionary:(NSDictionary*)dic;

/*!
 @property
 @brief robot的username
 */
@property (copy, nonatomic, readonly)NSString *username;

/*!
 @property
 @brief robot的nickname
 */
@property (copy, nonatomic, readonly)NSString *nickname;

/*!
 @property
 @brief robot的activated,robot是否可用
 */
@property (assign, nonatomic, readonly)BOOL activated;


@end
