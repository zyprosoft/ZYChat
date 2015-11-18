/*!
 @header EMNetworkMonitorDefs.h
 @abstract 网络状况定义
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#ifndef EMNetworkMonitorDefs_h
#define EMNetworkMonitorDefs_h

typedef NS_ENUM(NSUInteger, EMConnectionState) {
    eEMConnectionConnected,   //连接成功
    eEMConnectionDisconnected,//未连接
};

/*!
 @enum
 @brief 网络状态
 @constant eConnectionType_None 没有网络连接
 @constant eConnectionType_WWAN 使用蜂窝网络
 @constant eConnectionType_WIFI 使用WIFI网络
 @constant eConnectionType_2G   使用2G网络
 @constant eConnectionType_3G   使用3G网络
 @constant eConnectionType_4G   使用4G网络
 */
typedef NS_ENUM(NSInteger, EMConnectionType) {
    eConnectionType_None = 0,
    eConnectionType_WWAN,
    eConnectionType_WIFI,
    eConnectionType_2G,
    eConnectionType_3G,
    eConnectionType_4G,
};

/*!
 @enum
 @brief 网络类型
 @constant eConnectionName_Internet 网络连接
 @constant eConnectionName_LocalWIFI 本地wifi
 @constant eConnectionName_Default 网络连接
 */
typedef NS_ENUM(NSInteger, EMConnectionName) {
    eConnectionName_Internet = 0,
    eConnectionName_LocalWIFI,
    eConnectionName_Default = eConnectionName_Internet
};

#endif
