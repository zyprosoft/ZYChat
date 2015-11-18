//
//  GJCFFileUploadTask+GJCFAudioUpload.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-18.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFFileUploadTask+GJCFAudioUpload.h"

@implementation GJCFFileUploadTask (GJCFAudioUpload)

+ (GJCFFileUploadTask *)taskWithAudioFile:(GJCFAudioModel*)audioFile withObserver:(NSObject*)observer withTaskIdentifier:(NSString *__autoreleasing *)taskIdentifier
{
    GJCFFileUploadTask *task = [GJCFFileUploadTask taskWithFilePath:audioFile.tempEncodeFilePath withFileName:@"image.amr" withFormName:@"image" taskObserver:nil getTaskUniqueIdentifier:taskIdentifier];
    
    //自定义请求的Header
    NSString* timeStamp = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSinceReferenceDate]];
    /*  这里还需要一个userId,需要外部给设置了 */
    NSDictionary *customRequestHeader = @{@"ClientTimeStamp":timeStamp,@"interface":@"UploadImages"};
    task.customRequestHeader = customRequestHeader;
    
    //自定义请求参数
    NSString* jsonArgs = [NSString stringWithFormat:@"{\"imageCount\":\"1\",\"nowatermark\":\"1\"}"];
    task.customRequestParams = @{@"jsonArgs": jsonArgs};
    
    //设置原始的文件对象
    task.userInfo = @{@"audioFile": audioFile};

    return task;
}

@end
