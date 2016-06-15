//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayer.h"
#import "VKVideoPlayerConfig.h"

@interface VKVideoPlayerViewController: UIViewController <
  VKVideoPlayerDelegate
>

@property (nonatomic, strong) VKVideoPlayer* player;
- (void)playVideoWithStreamURL:(NSURL*)streamURL;
- (void)setSubtitle:(VKVideoPlayerCaption*)subtitle;
@end
