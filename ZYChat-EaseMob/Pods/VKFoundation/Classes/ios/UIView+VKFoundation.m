//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "UIView+VKFoundation.h"
#import "VKFoundation.h"

@implementation UIView (AlphaAnimation)

- (void)fadeHide {
  self.alpha = 1;
  [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.alpha = 0;
                   }
                   completion:nil];
}

- (void)fadeShow {
  if (self.alpha == 1.0) return;
  self.alpha = 0;
  [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.alpha = 1;
                   }
                   completion:nil];
}

- (void)fadeDisplayInView:(UIView *)v {
  self.alpha = 0;
  if (self.superview != v) {
    [v addSubview:self];
  }
  [self fadeShow];
  [self performSelector:@selector(fadeHide) withObject:nil afterDelay:10];
}

- (void)fadeToggleInView:(UIView *)v {
  if (self.superview != v) {
    [v addSubview:self];
  }
  BOOL isOpaque = self.alpha == 1.0;
  if (isOpaque) {
    [self fadeHide];
  } else {
    [self fadeShow];
  }
}

@end


@implementation UIView (InterfaceBuilderHelper)

- (UIView*)replaceSubView:(UIView*)oldView withView:(UIView*)newView {
  newView.frame = oldView.frame;
  [oldView removeFromSuperview];
  [self addSubview:newView];
  return newView;
}

- (void)replaceWithSubview:(UIView*)newView {
  newView.frame = self.frame;
  [self.superview insertSubview:newView aboveSubview:self];
  [self removeFromSuperview];
}

@end

@implementation UIView (AlterFrame)

- (void)setFrameWidth:(CGFloat)newWidth {
  CGRect f = self.frame;
  f.size.width = newWidth;
  self.frame = f;
}

- (void)setFrameHeight:(CGFloat)newHeight {
  CGRect f = self.frame;
  f.size.height = newHeight;
  self.frame = f;
}

- (void)setFrameOriginX:(CGFloat)newX {
  CGRect f = self.frame;
  f.origin.x = newX;
  self.frame = f;
}

- (void)setFrameOriginY:(CGFloat)newY {
  CGRect f = self.frame;
  f.origin.y = newY;
  self.frame = f;
}

@end

@implementation UIView (Borders)

- (void)addBorders:(UIViewBorderOptions)options {
  [self addBorders:options color:THEMECOLOR(@"colorBorder1")];
}

- (void)addBorders:(UIViewBorderOptions)options color:(UIColor*)color {

  CGFloat borderWidth = 1.0f;
  
  if ((options & UIViewBorderOptionTop)) {
    UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), borderWidth)];
    border.backgroundColor = color;
    border.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:border];
  }

  if ((options & UIViewBorderOptionRight)) {
    UIView* border = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - borderWidth, 0, borderWidth, CGRectGetHeight(self.frame))];
    border.backgroundColor = color;
    border.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:border];
  }

  if ((options & UIViewBorderOptionBottom)) {
    UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - borderWidth, CGRectGetWidth(self.frame), borderWidth)];
    border.backgroundColor = color;
    border.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:border];
  }

  if ((options & UIViewBorderOptionLeft)) {
    UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, borderWidth, CGRectGetHeight(self.frame))];
    border.backgroundColor = color;
    border.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:border];
  }

}

@end