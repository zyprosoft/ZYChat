//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKSlider.h"

#define THUMB_SIZE 15
#define EFFECTIVE_THUMB_SIZE 36

@implementation VKSlider

- (void)initialize {}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self initialize];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
  CGRect bounds = self.bounds;
  bounds = CGRectInset(bounds, -10, -10);
  return CGRectContainsPoint(bounds, point);
}

- (BOOL)beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
  CGRect bounds = self.bounds;
  float thumbPercent = (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);
  float thumbPos = THUMB_SIZE + (thumbPercent * (bounds.size.width - (2 * THUMB_SIZE)));
  CGPoint touchPoint = [touch locationInView:self];
  return (touchPoint.x >= (thumbPos - EFFECTIVE_THUMB_SIZE) && touchPoint.x <= (thumbPos + EFFECTIVE_THUMB_SIZE));
}


@end
