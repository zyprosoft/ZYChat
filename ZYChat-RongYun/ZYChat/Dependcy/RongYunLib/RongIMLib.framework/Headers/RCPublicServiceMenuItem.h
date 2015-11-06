/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCPublicServiceMenuItem.h
//  Created by litao on 15/4/14.

#import <Foundation/Foundation.h>
#import "RCStatusDefine.h"

/**
 * 公众服务账号菜单条目类
 */
@interface RCPublicServiceMenuItem : NSObject

/**
 * 菜单Id
 */
@property(nonatomic, strong) NSString *id;
/**
 * 菜单标题
 */
@property(nonatomic, strong) NSString *name;
/**
 * 菜单链接
 */
@property(nonatomic, strong) NSString *url;
/**
 * 菜单类型
 */
@property(nonatomic) RCPublicServiceMenuItemType type;
/**
 * 子菜单，类型RCPublicServiceMenuItem
 */
@property(nonatomic, strong) NSArray *subMenuItems;
/**
 * 根据JSON Array创建菜单项Array
 * @param  jsonArray   存储菜单项属性字典的Array
 * @return 返回菜单项Array
 */
+ (NSArray *)menuItemsFromJsonArray:(NSArray *)jsonArray;
@end
