/*!
 @header ICallManager.h
 @abstract 此接口提供了实时通话的基本操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "ICallManagerBase.h"
#import "ICallManagerCall.h"

@protocol ICallManager <ICallManagerBase, ICallManagerCall>

@required

@end
