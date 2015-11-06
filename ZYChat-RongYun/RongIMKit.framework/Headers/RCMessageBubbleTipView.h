//
//  RCMessageBubbleTipView.h
//  RCIM
//
//  Created by xugang on 14-6-20.
//  Copyright (c) 2014年 xugang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Bubble tip 位置
 */
typedef NS_ENUM(NSInteger, RCMessageBubbleTipViewAlignment) {
    /**
     *  左上
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_TOP_LEFT,
    /**
     *  右上
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_TOP_RIGHT,
    /**
     *  中上
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_TOP_CENTER,
    /**
     *  左中
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_CENTER_LEFT,
    /**
     *  右中
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_CENTER_RIGHT,
    /**
     *  左下
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_BOTTOM_LEFT,
    /**
     *  右下
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_BOTTOM_RIGHT,
    /**
     *  中下
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_BOTTOM_CENTER,
    /**
     *  正中
     */
    RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_CENTER
};

/**
 *  RCMessageBubbleTipView
 */
@interface RCMessageBubbleTipView : UIView
/**
 *  bubbleTipText
 */
@property(nonatomic, copy) NSString *bubbleTipText;

#pragma mark - Customization
/**
 *  RCMessageBubbleTipViewAlignment
 */
@property(nonatomic, assign) RCMessageBubbleTipViewAlignment bubbleTipAlignment;
/**
 *  bubbleTipTextColor
 */
@property(nonatomic, strong) UIColor *bubbleTipTextColor;
/**
 *  bubbleTipTextShadowOffset
 */
@property(nonatomic, assign) CGSize bubbleTipTextShadowOffset;
/**
 *  bubbleTipTextShadowColor
 */
@property(nonatomic, strong) UIColor *bubbleTipTextShadowColor;
/**
 *  bubbleTipTextFont
 */
@property(nonatomic, strong) UIFont *bubbleTipTextFont;
/**
 *  bubbleTipBackgroundColor
 */
@property(nonatomic, strong) UIColor *bubbleTipBackgroundColor;
/**
 *  bubbleTipBackgroundColor
 */
@property(nonatomic, strong) UIColor *bubbleTipOverlayColor;
/**
 *  bubbleTipPositionAdjustment
 */
@property(nonatomic, assign) CGPoint bubbleTipPositionAdjustment;
/**
 *  frameToPositionInRelationWith
 */
@property(nonatomic, assign) CGRect frameToPositionInRelationWith;
/**
 *  initWithParentView
 *
 *  @param parentView parentView
 *  @param alignment  alignment
 *
 *  @return return RCMessageBubbleTipView
 */
- (instancetype)initWithParentView:(UIView *)parentView alignment:(RCMessageBubbleTipViewAlignment)alignment;
/**
 *  setBubbleTipNumber
 *
 *  @param msgCount msgCount
 */
- (void)setBubbleTipNumber:(int)msgCount;

@end
