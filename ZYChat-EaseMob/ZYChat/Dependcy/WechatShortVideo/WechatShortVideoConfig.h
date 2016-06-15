//
//  WechatShortVideoConfig.h
//  WechatShortVideo
//
//  Created by AliThink on 15/8/18.
//  Copyright (c) 2015年 AliThink. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2015 AliThink
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//utils
#define WeALColor(r, g, b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define WeALAColor(r, g, b, a)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define PATH_OF_DOCUMENT         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#ifndef WechatShortVideo_WechatShortVideoConfig_h
#define WechatShortVideo_WechatShortVideoConfig_h

#import "CALayer+AddUIColor.h"
#import <UIKit/UIKit.h>

//Video file time length limitation (Maximum Seconds)
#define VIDEO_MAX_TIME       8.0
//Video file time length limitation (Minimum Seconds)
#define VIDEO_VALID_MINTIME  0.8
//Video filename
static NSString *VIDEO_DEFAULTNAME = @"videoReadyToUpload.mov";

//Tip Strings pressed on the record area
#define OPERATE_RECORD_TIP  @"↑上移取消"
//Tip Strings pressed on the cancel area
#define OPERATE_CANCEL_TIP  @"松手取消"

//Save btn title
#define SAVE_BTN_TITLE      @"发送"
//Retake btn title
#define RETAKE_BTN_TITLE    @"重录"
//Record btn title
#define RECORD_BTN_TITLE    @"按住拍"

//Tip color normal
#define NORMAL_TIPCOLOR     WeALColor(42, 200, 0)
//Tip color warning
#define WARNING_TIPCOLOR    WeALColor(216, 0, 40)

#endif


