/*!
 @header EMCursorResult.h
 @abstract 分批获取的结果
 @author EaseMob Inc.
 @version 1.00 2015/05/26 Creation (1.00)
 */

#import <Foundation/Foundation.h>

@interface EMCursorResult : NSObject

/*!
 @property
 @brief 结果
 */
@property (nonatomic, strong) NSArray *list;

/*!
 @property
 @brief 获取更多结果的cursor
 */
@property (nonatomic, copy) NSString *cursor;

+ (instancetype)cursorResultWithList:(NSArray *)list andCursor:(NSString *)cusror;
@end
