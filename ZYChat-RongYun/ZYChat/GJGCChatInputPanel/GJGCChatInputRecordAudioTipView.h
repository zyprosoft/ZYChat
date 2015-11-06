//
//  GJGCChatInputRecordAudioTipView.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-29.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCChatInputRecordAudioTipView : UIView

@property (nonatomic,strong)UIImage *voiceMicImage;

@property (nonatomic,strong)UIImage *voiceSoundMeterImage;

@property (nonatomic,strong)UIImage *voiceCancelImage;

@property (nonatomic,assign)BOOL isTooShortRecordDuration;

@property (nonatomic,assign)BOOL isTooLongRecordDuration;

@property (nonatomic,assign)CGFloat soundMeter;

@property (nonatomic,assign)CGFloat leftMargin;

@property (nonatomic,assign)CGFloat innerMargin;

@property (nonatomic,assign)BOOL willCancel;

@property (nonatomic,strong)NSString *minRecordTimeErrorTitle;

@property (nonatomic,strong)NSString *maxRecordTimeErrorTitle;

@property (nonatomic,strong)NSString *upToCancelRecordTitle;

@property (nonatomic,strong)NSString *releaseToCancelRecordTitle;



@end
