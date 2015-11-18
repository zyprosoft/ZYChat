//
//  GJCUCaptureViewController.m
//  GJCoreUserInterface
//
//  Created by ZYVincent on 15-1-23.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJCUCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GJCUFlashModeView.h"

@interface GJCUCaptureViewController ()<UIGestureRecognizerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *session;
    
    /* 预览 */
    UIView *previewView;
    
    UIImageView *previewPhotoView;
    
    /* 顶部工具栏 */
    UIView *topBlackBackView;
    
    /* 闪光灯设置 */
    GJCUFlashModeView *modeView;
    
    /* 前后摄像头切换 */
    UIButton *camerouSwitchButton;
    
    /* 拍照按钮 */
    UIButton *takePhotoButton;
    
    /* 重拍按钮 */
    UIButton *reTakePhotoButton;
    
    /* 取消按钮 */
    UIButton *cancelButton;
    
    /* 使用照片按钮 */
    UIButton *useCurrentPhotoButton;
    
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureVideoDataOutput *videoDataOutput;
    
    dispatch_queue_t videoDataOutputQueue;
    AVCaptureStillImageOutput *stillImageOutput;
    
    UIView *flashView;
    
    BOOL isUsingFrontFacingCamera;
    
    CGFloat beginGestureScale;
    CGFloat effectiveScale;
    
    /* 当前照出来的照片 */
    NSMutableDictionary *currentMediaInfo;
}

- (void)setupAVCapture;

- (void)teardownAVCapture;

@end



#pragma mark-

// used for KVO observation of the @"capturingStillImage" property to perform flash bulb animation
static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";

static const NSString *GJCUFlashModeViewModeChangeContext = @"GJCUFlashModeViewModeChangeContext";

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

static void ReleaseCVPixelBuffer(void *pixel, const void *data, size_t size);
static void ReleaseCVPixelBuffer(void *pixel, const void *data, size_t size)
{
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)pixel;
    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
    CVPixelBufferRelease( pixelBuffer );
}

// create a CGImage with provided pixel buffer, pixel buffer must be uncompressed kCVPixelFormatType_32ARGB or kCVPixelFormatType_32BGRA
static OSStatus CreateCGImageFromCVPixelBuffer(CVPixelBufferRef pixelBuffer, CGImageRef *imageOut);
static OSStatus CreateCGImageFromCVPixelBuffer(CVPixelBufferRef pixelBuffer, CGImageRef *imageOut)
{
    OSStatus err = noErr;
    OSType sourcePixelFormat;
    size_t width, height, sourceRowBytes;
    void *sourceBaseAddr = NULL;
    CGBitmapInfo bitmapInfo;
    CGColorSpaceRef colorspace = NULL;
    CGDataProviderRef provider = NULL;
    CGImageRef image = NULL;
    
    sourcePixelFormat = CVPixelBufferGetPixelFormatType( pixelBuffer );
    if ( kCVPixelFormatType_32ARGB == sourcePixelFormat )
        bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipFirst;
    else if ( kCVPixelFormatType_32BGRA == sourcePixelFormat )
        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    else
        return -95014; // only uncompressed pixel formats
    
    sourceRowBytes = CVPixelBufferGetBytesPerRow( pixelBuffer );
    width = CVPixelBufferGetWidth( pixelBuffer );
    height = CVPixelBufferGetHeight( pixelBuffer );
    
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    sourceBaseAddr = CVPixelBufferGetBaseAddress( pixelBuffer );
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    CVPixelBufferRetain( pixelBuffer );
    provider = CGDataProviderCreateWithData( (void *)pixelBuffer, sourceBaseAddr, sourceRowBytes * height, ReleaseCVPixelBuffer);
    image = CGImageCreate(width, height, 8, 32, sourceRowBytes, colorspace, bitmapInfo, provider, NULL, true, kCGRenderingIntentDefault);
    
bail:
    if ( err && image ) {
        CGImageRelease( image );
        image = NULL;
    }
    if ( provider ) CGDataProviderRelease( provider );
    if ( colorspace ) CGColorSpaceRelease( colorspace );
    *imageOut = image;
    return err;
}

// utility used by newSquareOverlayedImageForFeatures for
static CGContextRef CreateCGBitmapContextForSize(CGSize size);
static CGContextRef CreateCGBitmapContextForSize(CGSize size)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow = (size.width * 4);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate (NULL,
                                     size.width,
                                     size.height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    CGContextSetAllowsAntialiasing(context, NO);
    CGColorSpaceRelease( colorSpace );
    return context;
}

#pragma mark-

@interface UIImage (RotationMethods)
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end

@implementation UIImage (RotationMethods)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end

#pragma mark-

@implementation GJCUCaptureViewController

- (void)setupAVCapture
{
    NSError *error = nil;
    
    session = [AVCaptureSession new];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [session setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    // Select a video device, make an input
    AVCaptureDevice *currentDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:currentDevice error:&error];
    
    if (error) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    isUsingFrontFacingCamera = NO;
    if ( [session canAddInput:deviceInput] )
        [session addInput:deviceInput];
    
    // Make a still image output
    stillImageOutput = [AVCaptureStillImageOutput new];
    [stillImageOutput addObserver:self forKeyPath:@"isCapturingStillImage" options:NSKeyValueObservingOptionNew context:(__bridge void *)AVCaptureStillImageIsCapturingStillImageContext];
    if ( [session canAddOutput:stillImageOutput] )
        [session addOutput:stillImageOutput];
    
    // Make a video data output
    videoDataOutput = [AVCaptureVideoDataOutput new];
    
    // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
    
    // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
    // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
    // see the header doc for setSampleBufferDelegate:queue: for more information
    videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ( [session canAddOutput:videoDataOutput] )
        [session addOutput:videoDataOutput];
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
    
    effectiveScale = 1.0;
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [previewView layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:previewLayer];
    [session startRunning];
    
    
    /* 对焦模式 */
    NSError *foucsModeError = nil;
    if ([currentDevice lockForConfiguration:&foucsModeError]) {
        
        // smooth autofocus for videos
        if ([currentDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            [currentDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        
        [currentDevice setSubjectAreaChangeMonitoringEnabled:YES];
        
        [currentDevice unlockForConfiguration];
        
    } else if (foucsModeError) {
        NSLog(@"error locking device for video device configuration (%@)", foucsModeError);
    }
    
    /* 设置闪光灯模式 */
    if ([currentDevice hasFlash]) {
        
        // setup photo device configuration
        NSError *error = nil;
        if ([currentDevice lockForConfiguration:&error]) {
            
            if ([currentDevice isFlashModeSupported:AVCaptureFlashModeAuto])
                [currentDevice setFlashMode:AVCaptureFlashModeAuto];
            
            [currentDevice unlockForConfiguration];
            
        } else if (error) {
            NSLog(@"error locking device for photo device configuration (%@)", error);
        }
    }
    
    /* 观察闪关灯模式变化 */
    [modeView addObserver:self forKeyPath:@"currentMode" options:NSKeyValueObservingOptionNew context:(__bridge void *)GJCUFlashModeViewModeChangeContext];
}

// clean up capture setup
- (void)teardownAVCapture
{
    if (videoDataOutputQueue)
        videoDataOutputQueue = nil;
    [stillImageOutput removeObserver:self forKeyPath:@"isCapturingStillImage"];
    [modeView removeObserver:self forKeyPath:@"currentMode"];
    [previewLayer removeFromSuperlayer];
}

// perform a flash bulb animation using KVO to monitor the value of the capturingStillImage property of the AVCaptureStillImageOutput class
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == (__bridge void *)AVCaptureStillImageIsCapturingStillImageContext ) {
        BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        if ( isCapturingStillImage ) {
            // do flash bulb like animation
            flashView = [[UIView alloc] initWithFrame:[previewView frame]];
            [flashView setBackgroundColor:[UIColor whiteColor]];
            [flashView setAlpha:0.f];
            [[[self view] window] addSubview:flashView];
            
            [UIView animateWithDuration:.4f
                             animations:^{
                                 [flashView setAlpha:1.f];
                             }
             ];
        }
        else {
            [UIView animateWithDuration:.4f
                             animations:^{
                                 [flashView setAlpha:0.f];
                             }
                             completion:^(BOOL finished){
                                 [flashView removeFromSuperview];
                                 flashView = nil;
                             }
             ];
        }
    }
    
    /* 闪光灯模式变化 */
    if ( context == (__bridge void *)GJCUFlashModeViewModeChangeContext) {
        
        AVCaptureFlashMode flashMode = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        AVCaptureDevicePosition desiredPosition;
        if (isUsingFrontFacingCamera)
            desiredPosition = AVCaptureDevicePositionFront;
        else
            desiredPosition = AVCaptureDevicePositionBack;
        
        for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            
            if (d.position == desiredPosition && [d isFlashModeSupported:flashMode]) {
                
                BOOL lock = [d lockForConfiguration:nil];
                
                if (lock) {
                    
                    [d setFlashMode:flashMode];
                    
                    [d unlockForConfiguration];
                    
                }
            }
        }
        
      }
}

// utility routing used during image capture to set up capture orientation
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

// utility routine to display error aleart if takePicture fails
- (void)displayErrorOnMainQueue:(NSError *)error withMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%d)", message, (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}

// main action method to take a still image -- if face detection has been turned on and a face has been detected
// the square overlay will be composited on top of the captured image and saved to the camera roll
- (void)takePicture:(id)sender
{
    
    // Find out the current orientation and tell the still image output.
    AVCaptureConnection *stillImageConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:effectiveScale];
    
    // set the appropriate pixel format / image type output setting depending on if we'll need an uncompressed image for
    // the possiblity of drawing the red square over top or if we're just writing a jpeg to the camera roll which is the trival case
    [stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG
                                                                        forKey:AVVideoCodecKey]];
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                      
                                                      /* 显示结果 */
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [self finishTakePhotoShowBottomBar];
                                                          
                                                          [session stopRunning];
                                                          
                                                      });
                                                      
                                                      if (imageDataSampleBuffer) {
                                                          
                                                          // trivial simple JPEG case
                                                          NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                          CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                                                                      imageDataSampleBuffer,
                                                                                                                      kCMAttachmentMode_ShouldPropagate);
                                                          
                                                          UIImage *currentPhoto = [UIImage imageWithData:jpegData];
                                                          [currentMediaInfo removeAllObjects];
                                                          [currentMediaInfo setObject:currentPhoto forKey:UIImagePickerControllerOriginalImage];
                                                          [currentMediaInfo setObject:(__bridge NSDictionary *)attachments forKey:@"attachments"];
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              
                                                              previewPhotoView.image = currentPhoto;
                                                              
                                                          });
                                                          
                                                          
                                                          /* 是否需要保存的相册 */
                                                          if (self.isNeedAutoSaveToAlbum) {
                                                              
                                                              ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                                              [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
                                                                  if (error) {
                                                                      [self displayErrorOnMainQueue:error withMessage:@"Save to camera roll failed"];
                                                                  }
                                                              }];
                                                          }
                                                          
                                                          if (attachments)
                                                              CFRelease(attachments);
                                                          
                                                      }
            
                                                    }
     ];
}

- (void)dealloc
{
    [self teardownAVCapture];
}

// use front/back camera
- (void)switchCameras:(id)sender
{
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;
    
    /* 翻转 */
    if (isUsingFrontFacingCamera) {
        
        GJCFAnimationLeftFlipView(previewView, 0.5,^{
            
            [self switchCamerouWithPosition:desiredPosition];
            
        },nil);
        
    }else{
        GJCFAnimationRightFlipView(previewView, 0.5,^{
            
            [self switchCamerouWithPosition:desiredPosition];

        },nil);
    }
    
}

- (void)switchCamerouWithPosition:(AVCaptureDevicePosition)desiredPosition
{
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [[previewLayer session] beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in [[previewLayer session] inputs]) {
                [[previewLayer session] removeInput:oldInput];
            }
            [[previewLayer session] addInput:input];
            [[previewLayer session] commitConfiguration];
            break;
        }
    }
    
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
    
    if (isUsingFrontFacingCamera) {
        
        modeView.hidden = YES;
        
    }else{
        
        modeView.hidden = NO;
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /* 初始化视图 */
    [self setupSubViews];
    
    [self setupAVCapture];
}

#pragma mark 设置所有自定义视图

- (void)setupSubViews
{
    currentMediaInfo = [[NSMutableDictionary alloc]init];
    
    NSString *bunldePath = GJCFMainBundlePath(@"GJCUCaptureResourceBundle.bundle");
    NSString *switchCamerouIconPath = GJCFBundlePath(bunldePath,@"相机-icon-@2x.png");
    NSString *takePhotoIconNormalPath = GJCFBundlePath(bunldePath, @"拍照-icon@2x.png");
    NSString *takePhotoIconHighlightPath = GJCFBundlePath(bunldePath, @"拍照-icon-点击@2x.png");

    /* 预览视图 */
    previewView = [[UIView alloc]init];
    previewView.gjcf_width = GJCFSystemScreenWidth;
    previewView.gjcf_height = GJCFSystemScreenHeight;
    [self.view addSubview:previewView];

    /* 预览照片 */
    previewPhotoView = [[UIImageView alloc]init];
    previewPhotoView.gjcf_size = previewView.gjcf_size;
    previewPhotoView.backgroundColor = [UIColor clearColor];
    previewPhotoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:previewPhotoView];
    previewPhotoView.hidden = YES;
    
    /* 变焦手势 */
    UIPinchGestureRecognizer *pinR = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
    pinR.delegate = self;
    [previewView addGestureRecognizer:pinR];
    
    /* 顶部黑色工具条 */
    topBlackBackView = [[UIView alloc]init];
    topBlackBackView.gjcf_width = GJCFSystemScreenWidth;
    topBlackBackView.gjcf_height = 40.f;
    topBlackBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:topBlackBackView];
    
    /* 工具栏 */
    modeView = [[GJCUFlashModeView alloc]initWithFrame:CGRectZero];
    modeView.gjcf_top = 0;
    modeView.gjcf_left = 10.f;
    [topBlackBackView addSubview:modeView];
    
    /* 前后摄像头切换 */
    camerouSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    camerouSwitchButton.gjcf_width = 28;
    camerouSwitchButton.gjcf_height = 21;
    camerouSwitchButton.gjcf_right = GJCFSystemScreenWidth - 10;
    camerouSwitchButton.backgroundColor = [UIColor clearColor];
    camerouSwitchButton.gjcf_centerY = topBlackBackView.gjcf_height/2;
    [camerouSwitchButton setBackgroundImage:GJCFQuickImageByFilePath(switchCamerouIconPath) forState:UIControlStateNormal];
    [camerouSwitchButton addTarget:self action:@selector(switchCameras:) forControlEvents:UIControlEventTouchUpInside];
    [topBlackBackView addSubview:camerouSwitchButton];
    
    /* 底部工具栏 */
    UIView *bottomBlackBackView = [[UIView alloc]init];
    bottomBlackBackView.gjcf_width = GJCFSystemScreenWidth;
    bottomBlackBackView.gjcf_height = 61 + 8;
    bottomBlackBackView.gjcf_top = GJCFSystemScreenHeight - bottomBlackBackView.gjcf_height;
    bottomBlackBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:bottomBlackBackView];
    
    /* 取消按钮 */
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.gjcf_left = 15;
    cancelButton.gjcf_width = 40;
    cancelButton.gjcf_height = 25;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.gjcf_centerY = bottomBlackBackView.gjcf_height/2;
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBlackBackView addSubview:cancelButton];
    
    /* 拍照按钮 */
    takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoButton.gjcf_width = 61;
    takePhotoButton.gjcf_height = 61;
    takePhotoButton.backgroundColor = [UIColor clearColor];
    takePhotoButton.gjcf_centerX = GJCFSystemScreenWidth/2;
    takePhotoButton.gjcf_centerY = bottomBlackBackView.gjcf_height/2;
    [takePhotoButton setBackgroundImage:GJCFQuickImageByFilePath(takePhotoIconNormalPath) forState:UIControlStateNormal];
    [takePhotoButton setBackgroundImage:GJCFQuickImageByFilePath(takePhotoIconHighlightPath) forState:UIControlStateHighlighted];
    [takePhotoButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBlackBackView addSubview:takePhotoButton];
    
    /* 重拍按钮 */
    reTakePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reTakePhotoButton.frame = cancelButton.frame;
    [reTakePhotoButton setTitle:@"重拍" forState:UIControlStateNormal];
    reTakePhotoButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [reTakePhotoButton addTarget:self action:@selector(reTakePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBlackBackView addSubview:reTakePhotoButton];
    
    /* 使用照片 */
    useCurrentPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useCurrentPhotoButton.gjcf_size = CGSizeMake(80, 40);
    useCurrentPhotoButton.gjcf_centerY = reTakePhotoButton.gjcf_centerY;
    useCurrentPhotoButton.gjcf_right = GJCFSystemScreenWidth - 15.f;
    useCurrentPhotoButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [useCurrentPhotoButton setTitle:@"使用照片" forState:UIControlStateNormal];
    [useCurrentPhotoButton addTarget:self action:@selector(finishTakeAndUseCurrentPhoto) forControlEvents:UIControlEventTouchUpInside];
    [bottomBlackBackView addSubview:useCurrentPhotoButton];
    
    reTakePhotoButton.hidden = YES;
    useCurrentPhotoButton.hidden = YES;
    
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishTakeAndUseCurrentPhoto
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(captureViewController:didFinishChooseMedia:)]) {
        [self.delegate captureViewController:self didFinishChooseMedia:currentMediaInfo];
    }
}

/**
 *  拍照完成后底部工具栏显示
 */
- (void)finishTakePhotoShowBottomBar
{
    cancelButton.hidden = YES;
    takePhotoButton.hidden = YES;
    topBlackBackView.hidden = YES;
    
    previewPhotoView.hidden = NO;
    reTakePhotoButton.hidden = NO;
    useCurrentPhotoButton.hidden = NO;
}

- (void)prePareTakingPhotoShowBottomBar
{
    cancelButton.hidden = NO;
    takePhotoButton.hidden = NO;
    topBlackBackView.hidden = NO;
    
    reTakePhotoButton.hidden = YES;
    useCurrentPhotoButton.hidden = YES;
    previewPhotoView.hidden = YES;
}

- (void)reTakePhotoAction
{
    [self prePareTakingPhotoShowBottomBar];
    [session startRunning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self prefersStatusBarHidden];
        
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        beginGestureScale = effectiveScale;
    }
    return YES;
}

// scale image depending on users pinch gesture
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:previewView];
        CGPoint convertedLocation = [previewLayer convertPoint:location fromLayer:previewLayer.superlayer];
        if ( ! [previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        effectiveScale = beginGestureScale * recognizer.scale;
        if (effectiveScale < 1.0)
            effectiveScale = 1.0;
        CGFloat maxScaleAndCropFactor = [[stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        if (effectiveScale > maxScaleAndCropFactor)
            effectiveScale = maxScaleAndCropFactor;
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [previewLayer setAffineTransform:CGAffineTransformMakeScale(effectiveScale, effectiveScale)];
        [CATransaction commit];
    }
}

@end