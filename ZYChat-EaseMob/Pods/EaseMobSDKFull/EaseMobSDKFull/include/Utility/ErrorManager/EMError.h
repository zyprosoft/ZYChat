/*!
 @header EMError.h
 @abstract SDK错误信息定义文件
 @author EaseMob Inc.
 @version 1.0
 */
#import <Foundation/Foundation.h>
#import "EMErrorDefs.h"

/*!
 @class
 @brief SDK错误信息定义类
 @discussion
 */
@interface EMError : NSObject

/*!
 @property
 @brief 错误代码
 */
@property (nonatomic) EMErrorType errorCode;

/*!
 @property
 @brief 错误信息描述
 */
@property (nonatomic, copy) NSString *description;

/*!
 @method
 @brief 创建一个EMError实例对象
 @param errCode 错误代码
 @param description 错误描述信息
 @discussion
 @result 错误信息描述实例对象
 */
+ (EMError *)errorWithCode:(EMErrorType)errCode
           andDescription:(NSString *)description;

/*!
 @method
 @brief 通过NSError对象, 生成一个EMError对象
 @param error NSError对象
 @discussion
 @result 错误信息描述实例对象
 */
+ (EMError *)errorWithNSError:(NSError *)error;

@end
