//
//  GJCFAudioRecordSettings.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAudioRecordSettings.h"

@implementation GJCFAudioRecordSettings

- (id)initWithSampleRate:(CGFloat)rate
             withFormate:(NSInteger)formateID
            withBitDepth:(NSInteger)bitDepth
            withChannels:(NSInteger)channels
            withPCMIsBig:(BOOL)isBig
          withPCMIsFloat:(BOOL)isFloat
             withQuality:(NSInteger)quality
{
    if (self = [super init]) {
        
        self.sampleRate = rate;
        self.Formate = formateID;
        self.LinearPCMBitDepth = bitDepth;
        self.numberOfChnnels = channels;
        self.LinearPCMIsBigEndian = isBig;
        self.LinearPCMIsFloat = isFloat;
        self.EncoderAudioQuality = quality;
    }
    return self;
}


+ (GJCFAudioRecordSettings *)defaultQualitySetting
{
    GJCFAudioRecordSettings *settings = [[self alloc]initWithSampleRate:8000.0f withFormate:kAudioFormatLinearPCM withBitDepth:16 withChannels:1 withPCMIsBig:NO withPCMIsFloat:NO withQuality:AVAudioQualityMedium];
    
    return settings;
}

+ (GJCFAudioRecordSettings *)lowQualitySetting
{
    GJCFAudioRecordSettings *settings = [[self alloc]initWithSampleRate:8000.0f withFormate:kAudioFormatLinearPCM withBitDepth:16 withChannels:1 withPCMIsBig:NO withPCMIsFloat:NO withQuality:AVAudioQualityLow];
    
    return settings;
}

+ (GJCFAudioRecordSettings *)highQualitySetting
{
    GJCFAudioRecordSettings *settings = [[self alloc]initWithSampleRate:8000.0f withFormate:kAudioFormatLinearPCM withBitDepth:16 withChannels:1 withPCMIsBig:NO withPCMIsFloat:NO withQuality:AVAudioQualityHigh];
    
    return settings;
}

+ (GJCFAudioRecordSettings *)MaxQualitySetting
{
    GJCFAudioRecordSettings *settings = [[self alloc]initWithSampleRate:8000.0f withFormate:kAudioFormatLinearPCM withBitDepth:16 withChannels:1 withPCMIsBig:NO withPCMIsFloat:NO withQuality:AVAudioQualityMax];
    
    return settings;
}

- (NSDictionary *)settingDict
{
    NSDictionary *aSettingDict = @{
                                   AVSampleRateKey: @(self.sampleRate),
                                   AVFormatIDKey:@(self.Formate),
                                   AVLinearPCMBitDepthKey:@(self.LinearPCMBitDepth),
                                   AVNumberOfChannelsKey:@(self.numberOfChnnels),
                                   AVLinearPCMIsBigEndianKey:@(self.LinearPCMIsBigEndian),
                                   AVLinearPCMIsFloatKey:@(self.LinearPCMIsFloat),
                                   AVEncoderAudioQualityKey:@(self.EncoderAudioQuality)
                                   
                                   };
    
    return aSettingDict;
}
@end
