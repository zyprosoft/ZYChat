//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerLayerView.h"

@implementation VKVideoPlayerLayerView

+ (Class)layerClass {
  return [AVPlayerLayer class];
}

//- (AVPlayer*)player {
//  return [(AVPlayerLayer *)[self layer] player];
//}

- (void)setPlayer:(AVPlayer *)player {
  [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
