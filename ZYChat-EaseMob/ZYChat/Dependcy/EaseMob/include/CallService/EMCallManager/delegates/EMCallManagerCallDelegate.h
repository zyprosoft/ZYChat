/*!
 @header EMCallManagerCallDelegate.h
 @abstract 关于CallManager的异步回调协议
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "EMCallServiceDefs.h"

@class EMCallSession;
@class EMError;

/**
 *  本类主要处理实时通话时的一些回调操作
 */
@protocol EMCallManagerCallDelegate <NSObject>

@optional

/*!
 @method
 @brief 实时通话状态发生变化时的回调
 @param callSession 实时通话的实例
 @param reason   变化原因
 @param error    错误信息
 */
- (void)callSessionStatusChanged:(EMCallSession *)callSession
                    changeReason:(EMCallStatusChangedReason)reason
                           error:(EMError *)error;

@end
