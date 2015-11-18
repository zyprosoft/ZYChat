/*!
 @header EaseMob+CallService.h
 @abstract EaseMob的实时通话功能扩展
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import "EaseMob.h"

// defs headers
#import "EMCallServiceDefs.h"

//manager
#import "ICallManager.h"

//delegate
#import "EMCallManagerDelegate.h"

//type
#import "EMCallSession.h"
#import "OpenGLView20.h"

@protocol ICallManager;

/*!
 @category EaseMob(CallService)
 @discussion 该Category为EaseMob类提供了实时通话的能力.
 */
@interface EaseMob (CallService)

/*!
 @property
 @brief 由EaseMob类提供的ICallManager属性
 */
@property (strong, readonly, nonatomic) id<ICallManager> callManager;

@end
