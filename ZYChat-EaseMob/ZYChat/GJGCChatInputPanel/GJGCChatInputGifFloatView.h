//
//  GJGCChatInputGifFloatView.h
//  ZYChat
//
//  Created by ZYVincent on 15/6/3.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  浮层位置
 */
typedef NS_ENUM(NSUInteger, GJGCChatInputGifFloatViewPosition) {
    /**
     *  浮层居左
     */
    GJGCChatInputGifFloatViewPositionLeft,
    /**
     *  浮层居中
     */
    GJGCChatInputGifFloatViewPositionCenter,
    /**
     *  浮层居右
     */
    GJGCChatInputGifFloatViewPositionRight,
};

@interface GJGCChatInputGifFloatView : UIView

- (instancetype)initWithPosition:(GJGCChatInputGifFloatViewPosition)position withGifName:(NSString *)gifName;

- (void)showWithPosition:(GJGCChatInputGifFloatViewPosition)position withGifName:(NSString *)gifName;

@end
