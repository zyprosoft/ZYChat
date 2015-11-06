//
//  RCContentView.h
//  RongIMKit
//
//  Created by xugang on 3/31/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  RCContentView
 */
@interface RCContentView : UIView
/**
 *  eventBlock
 */
@property(nonatomic, copy) void (^eventBlock)(CGRect frame);
/**
 *  registerFrameChangedEvent
 *
 *  @param eventBlock event block
 */
- (void)registerFrameChangedEvent:(void (^)(CGRect frame))eventBlock;

@end
