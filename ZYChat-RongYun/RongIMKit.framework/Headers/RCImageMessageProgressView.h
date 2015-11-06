//
//  RCNumberProgressView.h
//  RCIM
//
//  Created by xugang on 6/5/14.
//  Copyright (c) 2014 Heq.Shinoda. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  RCImageMessageProgressView
 */
@interface RCImageMessageProgressView : UIView

/**
 *  进度显示Label
 */
@property(nonatomic, assign) UILabel *label;

/**
 *  进度指示
 */
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;
/**
 *  updateProgress
 *
 *  @param progress persent
 */
- (void)updateProgress:(NSInteger)progress;
/**
 *  startAnimating
 */
- (void)startAnimating;
/**
 *  stopAnimating
 */
- (void)stopAnimating;
@end
