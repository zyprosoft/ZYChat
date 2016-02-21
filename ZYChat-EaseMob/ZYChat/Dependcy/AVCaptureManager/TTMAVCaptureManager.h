//
//  AVCaptureManager.h
//  SlowMotionVideoRecorder
//  https://github.com/shu223/SlowMotionVideoRecorder
//
//  Created by shuichi on 12/17/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    TTMOutputModeVideoData,
    TTMOutputModeMovieFile,
} TTMOutputMode;


@protocol TTMAVCaptureManagerDelegate <NSObject>
- (void)didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
                                      error:(NSError *)error;
@end


@interface TTMAVCaptureManager : NSObject

@property (nonatomic, assign) id<TTMAVCaptureManagerDelegate> delegate;
@property (nonatomic, readonly) BOOL isRecording;

- (id)initWithPreviewView:(UIView *)previewView mode:(TTMOutputMode)mode;
- (void)toggleContentsGravity;
- (void)resetFormat;
- (void)switchFormatWithDesiredFPS:(CGFloat)desiredFPS;
- (void)startRecording;
- (void)stopRecording;
- (void)updateOrientationWithPreviewView:(UIView *)previewView;

@end
