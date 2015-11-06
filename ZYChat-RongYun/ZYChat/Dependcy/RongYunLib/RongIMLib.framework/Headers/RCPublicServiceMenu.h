/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCPublicServiceMenu.h
//  Created by litao on 15/4/14.

/* Menu -> MenuItem
 *
 *         MenuItem  -> MenuItem
 *                      MenuItem
 *
 *         MenuItem  -> MenuItem
 *                      MenuItem
 *                      MenuItem
 */
#import <Foundation/Foundation.h>
#import "RCPublicServiceMenuItem.h"

/**
 * 公众服务账号菜单类
 */
@interface RCPublicServiceMenu : NSObject

/**
 * 菜单项Array
 * 类型为RCPublicServiceMenuItem
 */
@property(nonatomic, strong) NSArray *menuItems;
/**
 * 根据JSON 字典初始化Menu
 * @param  jsonDictionary    存储菜单属性的字典
 */
- (void)decodeWithJsonDictionaryArray:(NSArray *)jsonDictionary;
@end
