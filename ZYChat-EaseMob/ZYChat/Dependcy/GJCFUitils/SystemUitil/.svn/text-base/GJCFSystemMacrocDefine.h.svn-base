//
//  GJCFSystemMacrocDefine.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-16.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

/**
 *  文件描述
 *
 *  这个文件封装了大部分系统相关的功能宏定义
 */

#import "GJCFSystemUitil.h"

/**
 *  去除performSelector警告
 *
 *  @param code 需要屏蔽警告的代码
 *
 *  @return
 */
#define GJCFSystemRemovePerformSelectorLeakWarning(code)                    \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")                                         \

/**
 *  当前App的版本号
 */
#define GJCFSystemAppVersion [GJCFSystemUitil appVersion]

/**
 *  当前App的版本号 float型
 */
#define GJCFSystemAppFloatVersion [GJCFSystemUitil appFloatVersion]

/**
 *  当前App的版本号 字符串型
 */
#define GJCFSystemAppStringVersion [GJCFSystemUitil appStringVersion]

/**
 *  当前App的bundleIdentifier
 */
#define GJCFSystemAppBundleIdentifier [GJCFSystemUitil appBundleIdentifier]

/**
 *  屏幕绝对画布
 */
#define GJCFSystemScreenBounds [GJCFSystemUitil screenBounds]

/**
 *  获取系统版本号
 */
#define GJCFSystemVersion [GJCFSystemUitil currentSystemVersion]

/**
 *  当前屏幕缩放倍数
 */
#define GJCFScreenScale [GJCFSystemUitil currentScreenScale]

/**
 *  系统是否超过5.0
 */
#define GJCFSystemIsOver5 [GJCFSystemUitil isSystemVersionOver:5.0]

/**
 *  系统是否超过6.0
 */
#define GJCFSystemIsOver6 [GJCFSystemUitil isSystemVersionOver:6.0]

/**
 *  系统是否超过7.0
 */
#define GJCFSystemIsOver7 [GJCFSystemUitil isSystemVersionOver:7.0]

/**
 *  系统是否超过8.0
 */
#define GJCFSystemIsOver8 [GJCFSystemUitil isSystemVersionOver:8.0]

/**
 *  获取屏幕大小
 */
#define GJCFSystemScreenSize [GJCFSystemUitil deviceScreenSize]

/**
 *  获取屏幕宽度
 */
#define GJCFSystemScreenWidth [GJCFSystemUitil deviceScreenSize].width

/**
 *  获取屏幕高度
 */
#define GJCFSystemScreenHeight [GJCFSystemUitil deviceScreenSize].height

/**
 *  是否iPhone4
 */
#define GJCFSystemiPhone4 [GJCFSystemUitil iPhone4Device]

/**
 *  是否iPhone5
 */
#define GJCFSystemiPhone5 [GJCFSystemUitil iPhone5Device]

/**
 *  是否iPhone6
 */
#define GJCFSystemiPhone6 [GJCFSystemUitil iPhone6Device]

/**
 *  是否iPhone6 plus
 */
#define GJCFSystemiPhone6Plus [GJCFSystemUitil iPhone6PlusDevice]

/**
 *  是否iPad
 */
#define GJCFSystemiPad [GJCFSystemUitil iPadDevice]

/**
 *  系统UINavigationBar高度
 */
#define GJCFSystemNavigationBarHeight [GJCFSystemUitil naivationBarHeight]

/**
 *  Y轴增量
 */
#define GJCFSystemOriginYDelta 20.f

/**
 *  AppDelegate
 */
#define GJCFApplicationDelegate [UIApplication shareApplication].delegate

/**
 *  创建对象弱引用
 */
#define GJCFWeakObject(anObject)  __weak __typeof(anObject)

/**
 *  创建对象强引用
 */
#define GJCFStrongObject(anObject) __strong __typeof(anObject) 

/**
 *  创建self弱引用
 */
#define GJCFWeakSelf GJCFWeakObject(self)

/**
 *  创建self强引用
 */
#define GJCFStrongSelf GJCFStrongObject(GJCFWeakSelf)

/**
 *  系统通知中心
 */
#define GJCFNotificationCenter [GJCFSystemUitil defaultCenter]

/**
 *  系统通知中心发noti名字的通知
 */
#define GJCFNotificationPost(noti) [GJCFSystemUitil postNoti:noti]

/**
 *  系统通知中心发noti名字的通知，携带参数对象object
 */
#define GJCFNotificationPostObj(noti,object) [GJCFSystemUitil postNoti:noti withObject:object]

/**
 *  系统通知中心发noti名字的通知，携带参数对象object ,携带用户自定义信息userInfo
 */
#define GJCFNotificationPostObjUserInfo(noti,object,userInfo) [GJCFSystemUitil postNoti:noti withObject:object withUserInfo:userInfo]

/**
 *  获取mainBundle
 */
#define GJCFMainBundle [NSBundle mainBundle]

/**
 *  获取mainBundle内名字为fileName的文件的路径
 */
#define GJCFMainBundlePath(fileName) [GJCFSystemUitil mainBundlePath:fileName]

/**
 *  获取路径为bundlePath的指定bundle中文件名为fileName的文件路径
 */
#define GJCFBundlePath(bundlePath,fileName) [GJCFSystemUitil bundle:bundlePath file:fileName]


/**
 *  运行时给一个对象添加一个成员，添加的associateKey必须是一个静态常量字符串 static NSString * const associateKey = @"";
 */
#define GJCFAssociateOriginWithObject(originObj,associateObj,associateKey) [GJCFSystemUitil originObject:originObj associateObject:associateObj byKey:associateKey]

/**
 *  通过key获取运行时加入的成员
 */
#define GJCFGetAssociateObject(originObj,associateKey) [GJCFSystemUitil associateObjectFromOrigin:originObj byKey:associateKey]

/**
 *  移除辅助成员
 */
#define GJCFAssociateRemove(originObj) [GJCFSystemUitil associateRemoveFromOrigin:originObj]

/**
 *  照相机是否可用
 */
#define GJCFCameraIsAvailable [GJCFSystemUitil cameraAvailable]

/**
 *  前置摄像头是否可用
 */
#define GJCFFrontCameraAvailable [GJCFSystemUitil frontCameraAvailable]

/**
 *  照相机闪光灯是否可用
 */
#define GJCFCameraFlashAvailable [GJCFSystemUitil cameraFlashAvailable]

/**
 *  是否支持发短信
 */
#define GJCFSystemCanSendSMS [GJCFSystemUitil canSendSMS]

/**
 *  是否支持打电话
 */
#define GJCFSystemCanMakePhoneCall [GJCFSystemUitil canMakePhoneCall]

/**
 *  当前是否有网络链接
 */
#define GJCFNetworkIsAvailable [GJCFSystemUitil networkAvailable]

/**
 *  App是否有权限访问照片库
 */
#define GJCFAppCanAccessPhotoLibrary [GJCFSystemUitil isAppPhotoLibraryAccessAuthorized]

/**
 *  App是否有权限访问相机
 */
#define GJCFAppCanAccessCamera [GJCFSystemUitil isAppCameraAccessAuthorized]

/**
 *  获取屏幕Y轴起始点
 */
#define GJCFAppSelfViewFrameOrangeY [GJCFSystemUitil getSelfViewFrameOrangeY]

/**
 *  系统是否 >=7.0 <7.1
 */
#define GJCFSystemVersionIs7 [GJCFSystemUitil isSystemVersionIs7]
