//
//  GJCFFileUploadTask+GJCFAudioUpload.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-18.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFFileUploadTask.h"
#import "GJCFAudioModel.h"

@protocol GJCFAudioUploadTaskDelegate <NSObject>

@required

/* 将任务返回的结果绑定成为一个文件model，怎么绑定通过这个协议让使用者自己实现 */
- (GJCFAudioModel *)uploadTask:(GJCFFileUploadTask *)task formateReturnResult:(NSDictionary *)resultDict;

@end

@interface GJCFFileUploadTask (GJCFAudioUpload)

+ (GJCFFileUploadTask *)taskWithAudioFile:(GJCFAudioModel*)audioFile withObserver:(NSObject*)observer withTaskIdentifier:(NSString **)taskIdentifier;

@end
