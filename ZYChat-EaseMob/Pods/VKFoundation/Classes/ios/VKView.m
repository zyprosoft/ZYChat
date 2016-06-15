//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKView.h"

@implementation VKView
@synthesize view = _view;

- (void)initialize {
  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];

  self.backgroundColor = [UIColor clearColor];
  self.view.backgroundColor = self.backgroundColor;
  [self addSubview:self.view];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void) awakeFromNib {
  [super awakeFromNib];
  [self initialize];
}

@end
