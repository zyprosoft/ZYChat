/*!
 @header OpenGLView20.h
 @abstract CallManager的视频显示页面
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>
#import <errno.h>
#import <CoreMedia/CoreMedia.h>
#import "IOpenGLView.h"

@interface OpenGLView20 : UIView<IOpenGLView>
{
	/** 
	 OpenGL绘图上下文
	 */
    EAGLContext             *_glContext; 
	
	/** 
	 帧缓冲区
	 */
    GLuint                  _framebuffer; 
	
	/** 
	 渲染缓冲区
	 */
    GLuint                  _renderBuffer; 
	
	/** 
	 着色器句柄
	 */
    GLuint                  _program;  
	
	/** 
	 YUV纹理数组
	 */
    GLuint                  _textureYUV[3]; 
	
	/** 
	 视频宽度
	 */
    GLuint                  _videoW;  
	
	/** 
	 视频高度
	 */
    GLuint                  _videoH;
    
    //屏幕分辨率
    GLsizei                 _screenScale;
    
#ifdef DEBUG
    struct timeval      _time;
    NSInteger           _frameRate;
#endif
}

/*!
 @method
 @brief 发给对方的视频分辨率，目前只支持AVCaptureSessionPreset352x288和AVCaptureSessionPreset640x480。
        默认为AVCaptureSessionPreset640x480。
 */
@property (strong, nonatomic) NSString *sessionPreset;

/*!
 @method
 @brief   摄像头输出设置
 */
@property (strong, nonatomic, readonly) NSDictionary *outputSettings;

/*!
 @method
 @brief   摄像头帧率设置
 */
@property (nonatomic, readonly) CMTime videoMinFrameDuration;

@end
