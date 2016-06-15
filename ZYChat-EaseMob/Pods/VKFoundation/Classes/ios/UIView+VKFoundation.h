//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

@interface UIView (AlphaAnimation)
- (void)fadeHide;
- (void)fadeShow;
- (void)fadeDisplayInView:(UIView *)v;
- (void)fadeToggleInView:(UIView *)v;
@end

@interface UIView (InterfaceBuilderHelper)
- (UIView*)replaceSubView:(UIView*)oldView withView:(UIView*)newView;
- (void)replaceWithSubview:(UIView*)newView;
@end

@interface UIView (AlterFrame)
- (void)setFrameWidth:(CGFloat)newWidth;
- (void)setFrameHeight:(CGFloat)newHeight;
- (void)setFrameOriginX:(CGFloat)newX;
- (void)setFrameOriginY:(CGFloat)newY;
@end

typedef enum {
  UIViewBorderOptionNone                   = 0,
  UIViewBorderOptionTop                    = 1 << 0,
  UIViewBorderOptionRight                  = 1 << 1,
  UIViewBorderOptionBottom                 = 1 << 2,
  UIViewBorderOptionLeft                   = 1 << 3
} UIViewBorderOptions;

@interface UIView (Borders)
- (void)addBorders:(UIViewBorderOptions)options;
- (void)addBorders:(UIViewBorderOptions)options color:(UIColor*)color;
@end