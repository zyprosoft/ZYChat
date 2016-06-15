//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#define VKSharedAirplay [VKVideoPlayerAirPlay sharedInstance]

#import "VKVideoPlayerExternalMonitor.h"
#import "VKVideoPlayerConfig.h"


//typedef enum {
//  VKAirplayStateDisconnected,
//  VKAirplayStateConnected,
//  VKAirplayStateActive
//} VKAirplayState;


@interface VKVideoPlayerAirPlay : VKVideoPlayerExternalMonitor

//@property (nonatomic, assign) VKAirplayState state;
//@property (nonatomic, strong) VKVideoPlayerView* playerView;
//@property (nonatomic, strong) UIWindow* window;
//@property (nonatomic, weak) VKVideoPlayerController* videoPlayerController;

//@property (nonatomic, readonly) BOOL isConnected;

+ (instancetype)sharedInstance;

@end
