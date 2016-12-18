//
//  GJGCCallDataManager.m
//  ZYChat
//
//  Created by bob on 16/8/25.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCCallDataManager.h"
#import "GJGCVoiceCallViewController.h"
#import "GJGCVideoCallViewController.h"
#import "GJGCForwardEngine.h"

@interface GJGCCallDataManager ()<EMCallManagerDelegate>

@end

@implementation GJGCCallDataManager

+ (GJGCCallDataManager *)sharedManager
{
    static GJGCCallDataManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[GJGCCallDataManager alloc]init];
    });
    return sharedManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    }
    return self;
}

#pragma mark - EMCallManagerDelegate
/*!
 *  用户A拨打用户B，用户B会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)didReceiveCallIncoming:(EMCallSession *)aSession
{
    NSLog(@"收到Call请求");
    
    if (aSession.type == EMCallTypeVoice) {
        GJGCVoiceCallViewController *callController = [[GJGCVoiceCallViewController alloc] initWithSession:aSession isIncoming:YES];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [[GJGCForwardEngine tabBarVC] presentViewController:callController animated:NO completion:nil];
    }
    
    if (aSession.type == EMCallTypeVideo) {
        GJGCVideoCallViewController *callController = [[GJGCVideoCallViewController alloc] initWithSession:aSession isIncoming:YES];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [[GJGCForwardEngine tabBarVC] presentViewController:callController animated:NO completion:nil];
    }
    

}

/*!
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)didReceiveCallConnected:(EMCallSession *)aSession
{
    NSLog(@"建立Call请求");
}

/*!
 *  用户A和用户B正在通话中，用户A中断或者继续数据流传输时，用户B会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aType     改变类型
 *
 */
- (void)didReceiveCallUpdated:(EMCallSession *)aSession
                         type:(EMCallStreamControlType)aType
{
    NSLog(@"Call中断");
}

@end
