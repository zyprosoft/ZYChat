//
//  GJCFEncodeAndDecode.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFAudioModel.h"

/*
 * iOS 支持自身的格式是Wav格式，
 * 我们将需要转成Wav格式的文件都认为是临时编码文件
 */
@interface GJCFEncodeAndDecode : NSObject

/* 将音频文件转为AMR格式，会为其创建AMR编码的临时文件 */
+ (BOOL)convertAudioFileToAMR:(GJCFAudioModel *)audioFile;

/* 将音频文件转为WAV格式 */
+ (BOOL)convertAudioFileToWAV:(GJCFAudioModel *)audioFile;

@end
