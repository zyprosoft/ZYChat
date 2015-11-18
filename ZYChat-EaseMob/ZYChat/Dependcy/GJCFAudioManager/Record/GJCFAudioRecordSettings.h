//
//  GJCFAudioRecordSettings.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GJCFAudioRecordSettings : NSObject

//采样率
@property (nonatomic,assign)CGFloat sampleRate;

/*
kAudioFormatLinearPCM               = 'lpcm',
kAudioFormatAC3                     = 'ac-3',
kAudioFormat60958AC3                = 'cac3',
kAudioFormatAppleIMA4               = 'ima4',
kAudioFormatMPEG4AAC                = 'aac ',
kAudioFormatMPEG4CELP               = 'celp',
kAudioFormatMPEG4HVXC               = 'hvxc',
kAudioFormatMPEG4TwinVQ             = 'twvq',
kAudioFormatMACE3                   = 'MAC3',
kAudioFormatMACE6                   = 'MAC6',
kAudioFormatULaw                    = 'ulaw',
kAudioFormatALaw                    = 'alaw',
kAudioFormatQDesign                 = 'QDMC',
kAudioFormatQDesign2                = 'QDM2',
kAudioFormatQUALCOMM                = 'Qclp',
kAudioFormatMPEGLayer1              = '.mp1',
kAudioFormatMPEGLayer2              = '.mp2',
kAudioFormatMPEGLayer3              = '.mp3',
kAudioFormatTimeCode                = 'time',
kAudioFormatMIDIStream              = 'midi',
kAudioFormatParameterValueStream    = 'apvs',
kAudioFormatAppleLossless           = 'alac',
kAudioFormatMPEG4AAC_HE             = 'aach',
kAudioFormatMPEG4AAC_LD             = 'aacl',
kAudioFormatMPEG4AAC_ELD            = 'aace',
kAudioFormatMPEG4AAC_ELD_SBR        = 'aacf',
kAudioFormatMPEG4AAC_ELD_V2         = 'aacg',
kAudioFormatMPEG4AAC_HE_V2          = 'aacp',
kAudioFormatMPEG4AAC_Spatial        = 'aacs',
kAudioFormatAMR                     = 'samr',
kAudioFormatAudible                 = 'AUDB',
kAudioFormatiLBC                    = 'ilbc',
kAudioFormatDVIIntelIMA             = 0x6D730011,
kAudioFormatMicrosoftGSM            = 0x6D730031,
kAudioFormatAES3                    = 'aes3'
*/
@property (nonatomic,assign)NSInteger Formate;

//采样位数 默认 16 /* value is an integer, one of: 8, 16, 24, 32 */
@property (nonatomic,assign)NSInteger LinearPCMBitDepth;

//通道的数目
@property (nonatomic,assign)NSInteger numberOfChnnels;

//大端还是小端 是内存的组织方式
@property (nonatomic,assign)BOOL  LinearPCMIsBigEndian;

//采样信号是整数还是浮点数
@property (nonatomic,assign)BOOL  LinearPCMIsFloat;

/* 返回目前的设置的字典 */
@property (nonatomic,readonly)NSDictionary *settingDict;

/*
AVAudioQualityMin    = 0,
AVAudioQualityLow    = 0x20,
AVAudioQualityMedium = 0x40,
AVAudioQualityHigh   = 0x60,
AVAudioQualityMax    = 0x7F
*/
//音频编码质量
@property (nonatomic,assign)NSInteger EncoderAudioQuality;


+ (GJCFAudioRecordSettings *)defaultQualitySetting;

+ (GJCFAudioRecordSettings *)lowQualitySetting;

+ (GJCFAudioRecordSettings *)highQualitySetting;

+ (GJCFAudioRecordSettings *)MaxQualitySetting;

@end
