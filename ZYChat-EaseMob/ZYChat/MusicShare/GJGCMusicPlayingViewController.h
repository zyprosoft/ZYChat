//
//  GJGCMusicPlayerViewController.h
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCBaseViewController.h"
#import "GJGCChatFriendContentModel.h"

@interface GJGCMusicPlayingViewController : GJGCBaseViewController<GJCFAudioPlayerDelegate>

- (instancetype)initWithMusicContent:(GJGCChatFriendContentModel*)contentModel;

@end
