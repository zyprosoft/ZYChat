//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKScrubber.h"
#import "VKFoundation.h"

#ifdef DEBUG
  static const int ddLogLevel = LOG_LEVEL_WARN;
#else
  static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface VKScrubber ()
@property (nonatomic, strong) UIImageView *scrubberGlow;
@end

@implementation VKScrubber

@synthesize delegate = _delegate;

- (void) initialize {

  [self setMaximumTrackImage:[[UIImage imageNamed:@"VKScrubber_max"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)]
      forState:UIControlStateNormal];
  [self setMinimumTrackImage:[[UIImage imageNamed:@"VKScrubber_min"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)]
      forState:UIControlStateNormal];
  [self setThumbImage:[UIImage imageNamed:@"VKScrubber_thumb"]
      forState:UIControlStateNormal];
  
  [self addTarget:self action:@selector(scrubbingBegin) forControlEvents:UIControlEventTouchDown];
  [self addTarget:self action:@selector(scrubbingEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
  [self addTarget:self action:@selector(scrubberValueChanged) forControlEvents:UIControlEventValueChanged];
  
  self.exclusiveTouch = YES;
}

- (void)scrubbingBegin {
  DDLogVerbose(@"SCRUBBER: Begin %f", self.value);
  [self.delegate scrubbingBegin];
}

- (void)scrubbingEnd {
  DDLogVerbose(@"SCRUBBER: End %f", self.value);
  [self.delegate scrubbingEnd];
}

- (void)scrubberValueChanged {
  DDLogVerbose(@"SCRUBBER: Change %f", self.value);
}

@end
