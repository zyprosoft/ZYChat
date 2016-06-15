//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKVideoPlayerConfig.h"

@protocol VKVideoPlayerTrackProtocol <NSObject>
@property (nonatomic, assign) BOOL isPlayedToEnd;
@property (nonatomic, assign) BOOL isVideoLoadedBefore;
@property (nonatomic, strong) NSNumber* totalVideoDuration;
@property (nonatomic, strong) NSNumber* lastDurationWatchedInSeconds;

// video title
- (NSString*)title;

// video stream URL
- (NSURL*)streamURL;

- (BOOL)hasNext;
- (BOOL)hasPrevious;
@end


@interface VKVideoPlayerTrack : NSObject<
  VKVideoPlayerTrackProtocol
> {
  BOOL _isVideoLoadedBefore;
  NSNumber* _totalVideoDuration;
  NSNumber* _lastDurationWatchedInSeconds;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL hasNext;
@property (nonatomic, assign) BOOL hasPrevious;
@property (nonatomic, assign) BOOL isPlayedToEnd;
@property (nonatomic, strong) NSURL* streamURL;
@property (nonatomic, assign) BOOL isVideoLoadedBefore;
@property (nonatomic, strong) NSNumber* totalVideoDuration;
@property (nonatomic, strong) NSNumber* lastDurationWatchedInSeconds;

- (id)initWithStreamURL:(NSURL*)url;
@end
