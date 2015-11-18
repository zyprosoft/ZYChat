/*!
 @header EaseMob.h
 @abstract 客户端基本类
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

#import "EaseMobHeaders.h"

/*!
 @class
 @brief 该类声明了EMChatManager和EMDeviceManager
 @discussion SDK集成进工程后, 最先使用的类, 所有的类对象, 均是通过这个单实例来获取, 示例代码如下:
            [EaseMob sharedInstance]
 */
@interface EaseMob : NSObject<UIApplicationDelegate>

/*!
 @property
 @brief 聊天管理器, 获取该对象后, 可以做登录、聊天、加好友等操作
 */
@property (nonatomic, readonly, strong) id<IChatManager> chatManager;

/*!
 @property
 @brief 设备管理器, 获取该对象后, 可以操作硬件相关的接口(照片、音频、地理位置信息等)
 */
@property (nonatomic, readonly, strong) id<IDeviceManager> deviceManager;

/*!
 @property
 @brief EaseMob SDK版本号
 */
@property (nonatomic, readonly, strong) NSString *sdkVersion;

/*!
 @method
 @brief 获取单实例
 @discussion
 @result EaseMob实例对象
*/
+ (EaseMob *)sharedInstance;

/*!
 @method
 @brief 初始化SDK
 @discussion 失败返回EMError,成功返回nil
 @result 初始化是否成功
 */
- (EMError *)registerSDKWithAppKey:(NSString *)anAppKey EM_DEPRECATED_IOS(2_0_0, 2_0_2, "Use -registerSDKWithAppKey:apnsCertName:"); // Deprecated;

/*!
 @method
 @brief 初始化SDK
 @discussion 失败返回EMError,成功返回nil
 @param anAppKey        申请应用时的appkey
 @param anAPNSCertName  需要使用的APNS证书名字(需要与后台上传时的APNS证书名字相同, 客户端打包时的证书, 需要与服务器后台的证书一一对应)
 @result 初始化是否成功
 */
- (EMError *)registerSDKWithAppKey:(NSString *)anAppKey
                      apnsCertName:(NSString *)anAPNSCertName;

/*!
 @method
 @brief 初始化SDK
 @discussion 失败返回EMError,成功返回nil
 @param anAppKey        申请应用时的appkey
 @param anAPNSCertName  需要使用的APNS证书名字(需要与后台上传时的APNS证书名字相同, 客户端打包时的证书, 需要与服务器后台的证书一一对应)
 @param anOtherConfig   其他初始化配置。目前支持自定义 1、是否打印Console Log（对应key为kSDKConfigEnableConsoleLogger）
 @result 初始化是否成功
 */
- (EMError *)registerSDKWithAppKey:(NSString *)anAppKey
                      apnsCertName:(NSString *)anAPNSCertName
                       otherConfig:(NSDictionary *)anOtherConfig;

/*!
 @method
 @brief App切换到后台时, 开启后台运行模式, 在后台时, 仍可接收消息
 @discussion 要使SDK在后台仍然能正常运行, 有两种方式可以实现:
    1. 在工程的Capabilities中, 设置Background Modes, 勾选 Voice Over IP, 无需调用此方法, 也可保持App在后台运行(但开启此项时, 如果应用未使用到VOIP, 上传到App Store会有被拒绝的风险)
    2. 在工程的Capabilities中, 设置Background Modes, 勾选 Audio And Airplay, 然后调用此方法, 即可保持App在后台一直运行.
 */
- (void)enableBackgroundReceiveMessage EM_DEPRECATED_IOS(2_0_0, 2_0_7, "目前已不使用该方法, 请在 applicationDidEnterBackground 和 applicationWillEnterForeground 方法中通知添加 SDK 的回调即可");

//开启 exception监听，并将exception写入到日志
//（跟友盟有冲突，如果使用了友盟，调用了该方法，有可能会导致 umeng的 crashReport不能正常工作）
//建议只在 Debug 状态时，打开该开关
- (void)enableUncaughtExceptionHandler;

@end

#import "EaseMob+CallService.h"

