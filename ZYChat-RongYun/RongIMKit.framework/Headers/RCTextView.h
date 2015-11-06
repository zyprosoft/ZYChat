//
//  RCTextView.h
//  iOS-IMKit
//
//  Created by Liv on 14/10/30.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  此类为解决UIMenuController的显示问题
 */
@interface RCTextView : UITextView

/**
 *  disableActionMenu为No时只显示当前响应对象的动作菜单，为YES时，则不显示任何菜单
 */
@property(nonatomic, assign) BOOL disableActionMenu;

@end
