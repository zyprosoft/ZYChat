//
//  IOpenGLView.h
//  EaseMobClientSDK
//
//  Created by dhc on 15/5/5.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOpenGLView <NSObject>

/*!
 @method
 @brief  将数据画到屏幕上
 @param data      数据
 @param width     宽度
 @param height    高度
 */
- (void)displayYUV420pData:(char *)data width:(GLuint)width height:(GLuint)height;

/*!
 @method
 @brief  设置视频显示区域大小
 @param width     宽度
 @param height    高度
 */
- (void)setVideoSize:(GLuint)width height:(GLuint)height;

/*!
 @method
 @brief  清除画面
 */
- (void)clearFrame;

@end
