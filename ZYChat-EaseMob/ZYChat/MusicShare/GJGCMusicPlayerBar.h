//
//  GJGCMusicPlayerBar.h
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCFAudioPlayer.h"
#import "GJGCMusicSharePlayer.h"

@protocol GJGCMusicPlayerBarDelegate <NSObject>

- (void)didTappedMusicPlayerBar;

@end

@interface GJGCMusicPlayerBar : UIView<GJCFAudioPlayerDelegate>

@property (nonatomic,weak)id<GJGCMusicPlayerBarDelegate> delegate;

+ (GJGCMusicPlayerBar *)currentMusicBar;

- (void)startMove;

@end
