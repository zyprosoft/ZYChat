//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerTrack.h"

@implementation VKVideoPlayerTrack

- (id)initWithStreamURL:(NSURL*)url {
  self = [super init];
  if (self) {
    self.streamURL = url;
  }
  return self;
}

@end
