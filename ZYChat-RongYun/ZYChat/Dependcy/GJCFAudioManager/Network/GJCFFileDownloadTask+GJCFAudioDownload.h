//
//  GJCFFileDownloadTask+GJCFAudioDownload.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-18.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFFileDownloadTask.h"
#import "GJCFAudioModel.h"


@interface GJCFFileDownloadTask (GJCFAudioDownload)

+ (GJCFFileDownloadTask *)taskWithAudioFile:(GJCFAudioModel*)audioFile withObserver:(NSObject*)observer getTaskIdentifier:(NSString **)taskIdentifier;

@end
