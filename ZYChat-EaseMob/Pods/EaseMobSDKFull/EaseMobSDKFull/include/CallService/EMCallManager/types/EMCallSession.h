/*!
 @header EMCallSession.h
 @abstract 实时通话实例
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "EMCallServiceDefs.h"

@class OpenGLView20;
@interface EMCallSession : NSObject

/*!
 @class
 @brief 通话实例的id，唯一
 */
@property (strong, nonatomic, readonly) NSString *sessionId;

/*!
 @class
 @brief 通话对方的username
 */
@property (strong, nonatomic) NSString *sessionChatter;

/*!
 @class
 @brief 通话的类型
 */
@property (nonatomic, readonly) EMCallSessionType type;

/*!
 @class
 @brief 通话的状态
 */
@property (nonatomic, readonly) EMCallSessionStatus status;

/*!
 @class
 @brief 连接类型
 */
@property (nonatomic, readonly) EMCallConnectType connectType;

/*!
 @class
 @brief 视频时对方的图像显示区域
 */
@property (strong, nonatomic) OpenGLView20 *displayView;


- (instancetype)initWithSessionId:(NSString *)sessionId;

@end
