/*!
 @header IChatManagerLogin.h
 @abstract 为ChatManager提供基础登陆操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "IChatManagerBase.h"

/*!
 @protocol
 @brief 本协议包括：登录、退出、修改密码等方法
 @discussion 所有不带Block回调的异步方法, 需要监听回调时, 需要先将要接受回调的对象注册到delegate中, 示例代码如下:
    [[[EaseMob sharedInstance] chatManager] addDelegate:self delegateQueue:dispatch_get_main_queue()]
 */
@protocol IChatManagerLogin <IChatManagerBase>

#pragma mark - properties

/*!
 @property
 @brief 当前登录的用户信息
 */
@property (nonatomic, strong, readonly) NSDictionary *loginInfo;

/*!
 @property
 @brief 当前是否已有登录的用户
 */
@property (nonatomic, readonly) BOOL isLoggedIn;

/*!
 @property
 @brief 是否连上聊天服务器
 */
@property (nonatomic, readonly) BOOL isConnected;


#pragma mark - database
/*!
 @method
 @brief 将数据库数据导入新的数据库，旧版sdk数据库采用CoreData,从2.1.0版本开始，换成Sqlite
 @discussion 同步方法，登录成功之后调用
 @result     错误信息
 */
- (EMError *)importDataToNewDatabase;

/*!
 @method
 @brief  调用sdk登录接口，登陆成功之后，sdk内部会默认调用一次该函数
         从数据库获取信息，包括自己相关的群组，被屏蔽的群组的id数组，会话，消息
 @discussion 登录成功之后调用
 @result     错误信息
 */
- (EMError *)loadDataFromDatabase;

#pragma mark - register

/*!
 @method
 @brief 在聊天服务器上创建账号
 @discussion
 @param username 用户名
 @param password 密码
 @param pError   错误信息
 @result 是否注册成功
 */
- (BOOL)registerNewAccount:(NSString *)username
                  password:(NSString *)password
                     error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 在聊天服务器上创建账号
 @discussion 在注册过程中, EMChatManagerLoginDelegate中的didRegisterNewAccount:password:error:回调会被触发
 @param username 用户名
 @param password 密码
 @result
 */
- (void)asyncRegisterNewAccount:(NSString *)username
                      password:(NSString *)password;

/*!
 @method
 @brief 异步方法, 在聊天服务器上创建账号
 @discussion
 @param username 用户名
 @param password 密码
 @param completion 回调
 @param aQueue 回调时的线程
 @result
 */
- (void)asyncRegisterNewAccount:(NSString *)username
                      password:(NSString *)password
                withCompletion:(void (^)(NSString *username,
                                         NSString *password,
                                         EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

#pragma mark - login

/*!
 @method
 @brief 使用用户名密码登录聊天服务器
 @discussion 如果登陆失败, 返回nil
 @param username 用户名
 @param password 密码
 @param pError   错误信息
 @result 登录后返回的用户信息
 */
- (NSDictionary *)loginWithUsername:(NSString *)username
                          password:(NSString *)password
                             error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 使用用户名密码登录聊天服务器
 @discussion 在登陆过程中, EMChatManagerLoginDelegate中的didLoginWithInfo:error:回调会被触发
 @param username 用户名
 @param password 密码
 @result
 */
- (void)asyncLoginWithUsername:(NSString *)username
                     password:(NSString *)password;

/*!
 @method
 @brief 异步方法, 使用用户名密码登录聊天服务器
 @discussion
 @param username 用户名
 @param password 密码
 @param completion 回调
 @param aQueue 回调时的线程
 @result
 */
- (void)asyncLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                   completion:(void (^)(NSDictionary *loginInfo, EMError *error))completion
                      onQueue:(dispatch_queue_t)aQueue;

#pragma mark - logoff

/*!
 @method
 @brief 注销当前登录用户
 @discussion 当接收到【didLoginFromOtherDevice】和【didRemovedFromServer】的回调时，调用此方法，isUnbind传NO
 @param isUnbind 是否解除device token
 @param pError 错误信息
 @result 返回注销信息
 */
- (NSDictionary *)logoffWithUnbindDeviceToken:(BOOL)isUnbind
                                        error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 注销当前登录用户
 @discussion 当接收到【didLoginFromOtherDevice】和【didRemovedFromServer】的回调时，调用此方法，isUnbind传NO
 @result 完成后【didLogoffWithError:】回调会被触发.
 */
- (void)asyncLogoffWithUnbindDeviceToken:(BOOL)isUnbind;

/*!
 @method
 @brief 异步方法, 注销当前登录用户
 @discussion 当接收到【didLoginFromOtherDevice】和【didRemovedFromServer】的回调时，调用此方法，isUnbind传NO
 @param completion 回调
 @param aQueue     回调时的线程
 @result
 */
- (void)asyncLogoffWithUnbindDeviceToken:(BOOL)isUnbind
                              completion:(void (^)(NSDictionary *info, EMError *error))completion
                                 onQueue:(dispatch_queue_t)aQueue;

@optional

#pragma mark - EM_DEPRECATED_IOS

/*!
 @method
 @brief 注销当前登录用户
 @param pError 错误信息
 @result 返回注销信息
 */
- (NSDictionary *)logoffWithError:(EMError **)pError EM_DEPRECATED_IOS(2_0_6, 2_1_1, "Use - logoffWithUnbindDeviceToken:error:");

/*!
 @method
 @brief 异步方法, 注销当前登录用户
 @discussion 在注销过程中, EMChatManagerLoginDelegate中的didLogoffWithError:回调会被触发.
 @result
 */
- (void)asyncLogoff EM_DEPRECATED_IOS(2_0_6, 2_1_1, "Use - asyncLogoffWithUnbindDeviceToken:");

/*!
 @method
 @brief 异步方法, 注销当前登录用户
 @discussion
 @param completion 回调
 @param aQueue     回调时的线程
 @result
 */
- (void)asyncLogoffWithCompletion:(void (^)(NSDictionary *info, EMError *error))completion
                          onQueue:(dispatch_queue_t)aQueue EM_DEPRECATED_IOS(2_0_6, 2_1_1, "Use - asyncLogoffWithUnbindDeviceToken:completion:onQueue:");

@end
