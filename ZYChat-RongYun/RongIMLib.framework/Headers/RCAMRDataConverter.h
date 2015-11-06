/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCAmrDataConverter.h
//  Created by Heq.Shinoda on 14-6-17.

#ifndef __RCAmrDataConverter
#define __RCAmrDataConverter

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "interf_dec.h"
#include "interf_enc.h"

/**
 *  AMR和WAV转换类
 */
@interface RCAMRDataConverter : NSObject

/**
 *  RCAmrDataConverter instance
 *
 *  @return instance
 */
+ (RCAMRDataConverter *)sharedAMRDataConverter;
/**
 *  AMR转换成WAVE格式的音频.
 *
 *  @param data AMR格式数据
 *
 *  @return WAVE格式数据
 */
- (NSData *)dcodeAMRToWAVE:(NSData *)data;
/**
 *  WAVE转换成AMR格式音频
 *
 *  @param data           WAVE格式数据 注意声音的采样率  AVNumberOfChannelsKey=1 AVLinearPCMBitDepthKey=16
 *  @param nChannels      默认传入1。
 *  @param nBitsPerSample 默认传入16。
 *
 *  @return AMR格式数据
 */
- (NSData *)ecodeWAVEToAMR:(NSData *)data channel:(int)nChannels nBitsPerSample:(int)nBitsPerSample;
@end

#endif