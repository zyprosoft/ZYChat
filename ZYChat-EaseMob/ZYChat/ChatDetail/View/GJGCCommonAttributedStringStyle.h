//
//  GJGCCommonAttributedStringStyle.h
//  ZYChat
//  公共样式
//  Created by ZYVincent QQ:1003081775 on 14/11/25.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCCommonAttributedStringStyle : NSObject

/**
 *  群style
 *
 *  @param content <#content description#>
 *
 *  @return <#return value description#>
 */
+ (NSAttributedString *)getGroupAttributedString:(NSString *)content;


/**
 *  群类型style
 *
 *  @param content <#content description#>
 *
 *  @return <#return value description#>
 */
+ (NSAttributedString *)getGroupTypeAttributedString:(NSString *)content;

/**
 *  老乡标识style
 *
 *  @param content <#content description#>
 *
 *  @return <#return value description#>
 */
+ (NSAttributedString *)getFolksTypeAttributedString:(NSString *)content;

@end
