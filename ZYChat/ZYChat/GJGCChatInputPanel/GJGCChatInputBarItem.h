//
//  GJGCCommonInputBarControlItem.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJGCChatInputBarItem;

/**
 *  按钮状态变化
 *
 *  @param item          被点击的按钮
 *  @param changeToState 改变到的状态
 */
typedef void (^GJGCChatInputBarControlItemStateChangeEventBlock) (GJGCChatInputBarItem *item, BOOL changeToState);

/**
 *  权限block
 *
 *  @param item
 */
typedef BOOL (^GJGCChatInputBarControlItemAuthorizedBlock) (GJGCChatInputBarItem *item);

@interface GJGCChatInputBarItem : UIView

/**
 *  是否选中
 */
@property (nonatomic,assign,getter=isSelected)BOOL selected;


- (instancetype)initWithSelectedIcon:(UIImage *)selectedIcon withNormalIcon:(UIImage *)normalIcon;

/**
 *  设置状态变化观察
 *
 *  @param eventBlock 需要设置的block
 */
- (void)configStateChangeEventBlock:(GJGCChatInputBarControlItemStateChangeEventBlock)eventBlock;

/**
 *  监视是否可以调用
 *
 *  @param authorizeBlock
 */
- (void)configAuthorizeBlock:(GJGCChatInputBarControlItemAuthorizedBlock)authorizBlock;

@end
