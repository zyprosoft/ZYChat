//
//  UIView+GJCFViewAdaptor.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-24.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  为了避免组件库进入其他项目之后使用的同名属性被其他Category方法覆盖修改
 *
 *  我们增加gjcf_前缀确保始终进入正确的设置流程
 */

@interface UIView (GJCFViewFrameUitil)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat gjcf_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat gjcf_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat gjcf_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat gjcf_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat gjcf_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat gjcf_height;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint gjcf_origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize gjcf_size;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat gjcf_centerX;

/**
 *  右上角
 *  self.origin.x+self.size.width,self.origin.y
 */
@property (nonatomic) CGPoint gjcf_topRight;

/**
 *  左下角
 *
 *  self.origin.x,self.origin.y+self.size.height
 */
@property (nonatomic) CGPoint gjcf_bottomLeft;

/**
 *  右下角
 *
 *  self.origin.x+self.size.width,self.origin.y+self.size.height
 */
@property (nonatomic) CGPoint gjcf_bottomRight;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat gjcf_centerY;

/**
 *  Shortcut for right to superview
 *  Sets frame.origin.x = superview.width - rightToSuper -frame.size.width
 */
@property (nonatomic) CGFloat gjcf_rightToSuper;

/**
 *  shortcut for bottom to superview
 *  set frame.origin.y = superview.height - bottomToSuper - frame.size.height
 */
@property (nonatomic) CGFloat gjcf_bottomToSuper;


@end
