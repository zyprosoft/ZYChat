//
//  RCEmojiView.h
//  RCIM
//
//  Created by Heq.Shinoda on 14-5-29.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCEmojiPageControl;
@class RCEmojiBoardView;
/**
 *  RCEmojiViewDelegate
 */
@protocol RCEmojiViewDelegate <NSObject>
@optional
/**
 *  didTouchEmojiView
 *
 *  @param emojiView emojiView
 *  @param string    string
 */
- (void)didTouchEmojiView:(RCEmojiBoardView *)emojiView touchedEmoji:(NSString *)string;
/**
 *  didSendButtonEvent
 *
 *  @param emojiView  emojiView
 *  @param sendButton send button
 */
- (void)didSendButtonEvent:(RCEmojiBoardView *)emojiView sendButton:(UIButton *)sendButton;
@end
/**
 *  RCEmojiBoardView
 */
@interface RCEmojiBoardView : UIView <UIScrollViewDelegate> {
    /**
     *  RCEmojiPageControl
     */
    RCEmojiPageControl *pageCtrl;
    /**
     *  currentIndex
     */
    NSInteger currentIndex;
}
/**
 *  emojiBackgroundView
 */
@property(nonatomic, strong) UIScrollView *emojiBackgroundView;
/**
 *  emojiLabel
 */
@property(nonatomic, strong) UILabel *emojiLabel;
/**
 *  RCEmojiViewDelegate
 */
@property(nonatomic, assign) id<RCEmojiViewDelegate> delegate;
/**
 *  loadLabelView
 */
- (void)loadLabelView;
@end
