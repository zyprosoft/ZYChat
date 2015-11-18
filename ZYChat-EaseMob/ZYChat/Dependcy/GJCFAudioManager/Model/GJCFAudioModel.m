//
//  GJCFAudioModel.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAudioModel.h"
#import "GJCFAudioFileUitil.h"

@implementation GJCFAudioModel

- (id)init
{
    if (self = [super init]) {
        
        self.isUploadTempEncodeFile = YES;
        self.isNeedConvertEncodeToSave = YES;
        self.isDeleteWhileFinishConvertToLocalFormate = YES;
        self.shouldPlayWhileFinishDownload = NO;
        
        _uniqueIdentifier = [self currentTimeStamp];
        
        /* 设定默认文件后缀 */
        self.extensionName = @"wav";
        self.tempEncodeFileExtensionName = @"amr";
        
        self.mimeType = @"audio/amr";
    }
    return self;
}

- (NSString *)currentTimeStamp
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceReferenceDate];
    
    NSString *timeString = [NSString stringWithFormat:@"%lf",timeInterval];
    
    return timeString;
}

/* 删除临时编码文件 */
- (void)deleteTempEncodeFile
{
    if (self.tempEncodeFilePath && ![self.localStorePath isEqualToString:@""]) {
        
        [GJCFAudioFileUitil deleteTempEncodeFileWithPath:self.tempEncodeFilePath];
    }
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"文件Wav路径:%@ 远程路径:%@ 临时转码文件路径:%@",self.localStorePath,self.remotePath,self.tempEncodeFilePath];
}

/* 删除本地wav格式文件 */
- (void)deleteWavFile
{
    if (self.localStorePath && ![self.localStorePath isEqualToString:@""]) {
        
        [GJCFAudioFileUitil deleteTempEncodeFileWithPath:self.localStorePath];
        
        /* 将远程路径和本地wav文件的关系也删掉 */
        if (self.remotePath) {
            
            [GJCFAudioFileUitil deleteShipForRemoteUrl:self.remotePath];
        }
    }
}


@end
