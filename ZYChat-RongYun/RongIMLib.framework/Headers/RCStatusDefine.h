/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCCommonDefine.h
//  Created by Heq.Shinoda on 14-4-21.

#import <Foundation/Foundation.h>

#ifndef __RCStatusDefine
#define __RCStatusDefine

/**
 *  @enum 融云连接业务的返回码。
 */
typedef NS_ENUM(NSInteger, RCConnectErrorCode) {
    /**
     * 连接过程中，获取路由导航数据失败。
     */
    RC_NET_NAVI_ERROR = 30000,
    /**
     * 当前连接已经被释放，可能需要做重连处理。
     */
    RC_NET_CHANNEL_INVALID = 30001,
    /**
     * 当前连接不可用，可能需要做重连处理。
     */
    RC_NET_UNAVAILABLE = 30002,
    /**
     * 当前请求响应超时。
     */
    RC_MSG_RESP_TIMEOUT = 30003,
    /**
     * 连接过程中，当前HTTP发送失败。
     */
    RC_HTTP_SEND_FAIL = 30004,
    /**
     * 连接过程中，当前HTTP请求超时。
     */
    RC_HTTP_REQ_TIMEOUT = 30005,
    /**
     * 连接过程中，当前HTTP接收失败。
     */
    RC_HTTP_RECV_FAIL = 30006,
    /**
     * 连接过程中，当前HTTP返回错误码。
     */
    RC_NAVI_RESOURCE_ERROR = 30007,
    /**
     * 连接过程中，当前HTTP返回错误码。
     */
    RC_NODE_NOT_FOUND = 30008,
    /**
     * 连接过程中，当前HTTP返回错误码。
     */
    RC_DOMAIN_NOT_RESOLVE = 30009,
    /**
     * 创建Socket连接失败。
     */
    RC_SOCKET_NOT_CREATED = 30010,
    /**
     * Socket主动断开，或者被动被服务器断开。
     */
    RC_SOCKET_DISCONNECTED = 30011,
    /**
     * PING操作失败。
     */
    RC_PING_SEND_FAIL = 30012,
    /**
     * PING操作没有得到返回响应。
     */
    RC_PONG_RECV_FAIL = 30013,
    /**
     * 信令发送失败。
     */
    RC_MSG_SEND_FAIL = 30014,
    /**
     * 由服务器返回，connect 响应超时。
     */
    RC_CONN_ACK_TIMEOUT = 31000,
    /**
     * 由服务器返回，信令版本号错误。
     */
    RC_CONN_PROTO_VERSION_ERROR = 31001,
    /**
     * 由服务器返回，App ID被拒绝。
     */
    RC_CONN_ID_REJECT = 31002,
    /**
     * 由服务器返回，服务不可用。
     */
    RC_CONN_SERVER_UNAVAILABLE = 31003,
    /**
     * 由服务器返回，Token不正确，App需要重新向App服务器请求Token。
     */
    RC_CONN_TOKEN_INCORRECT = 31004,
    /**
     * 由服务器返回，未授权。
     */
    RC_CONN_NOT_AUTHRORIZED = 31005,
    /**
     * 由服务器返回，重定向。
     */
    RC_CONN_REDIRECTED = 31006,
    /**
     * 由服务器返回，包名不正确。
     */
    RC_CONN_PACKAGE_NAME_INVALID = 31007,
    /**
     * 由服务器返回，应用被封禁。
     */
    RC_CONN_APP_BLOCKED_OR_DELETED = 31008,
    /**
     * 由服务器返回，用户被封禁。
     */
    RC_CONN_USER_BLOCKED = 31009,
    /**
     * 由服务器返回，重复登陆。
     */
    RC_DISCONN_KICK = 31010,
    /**
     * 信令返回数据不完整。
     */
    RC_QUERY_ACK_NO_DATA = 32001,
    /**
     * 数据传输失败。
     */
    RC_MSG_DATA_INCOMPLETE = 32002,
    /**
     * 本地调用传入参数错误。
     */
    RC_INVALID_ARGUMENT = -1000

};
/**
 @enum 网络连接状态码
 */
typedef NS_ENUM(NSInteger, RCConnectionStatus) {
    /**
     * 未知状态。
     */
    ConnectionStatus_UNKNOWN = -1, //"Unknown error."

    /**
     * 连接成功。
     */
    ConnectionStatus_Connected = 0,

    /**
     * 网络不可用。
     */
    ConnectionStatus_NETWORK_UNAVAILABLE = 1, //"Network is unavailable."

    /**
     * 设备处于飞行模式。
     */
    ConnectionStatus_AIRPLANE_MODE = 2, //"Switch to airplane mode."

    /**
     * 设备处于 2G（GPRS、EDGE）低速网络下。
     */
    ConnectionStatus_Cellular_2G = 3, // "Switch to 2G cellular network."

    /**
     * 设备处于 3G 或 4G（LTE）高速网络下。
     */
    ConnectionStatus_Cellular_3G_4G = 4, //"Switch to 3G or 4G cellular network."

    /**
     * 设备网络切换到 WIFI 网络。
     */
    ConnectionStatus_WIFI = 5, //"Switch to WIFI network."

    /**
     * 用户账户在其他设备登录，本机会被踢掉线。
     */
    ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT = 6, //"Login on the other device, and be kicked offline."

    /**
     * 用户账户在 Web 端登录。
     */
    ConnectionStatus_LOGIN_ON_WEB = 7, //"Login on web client."

    /**
     * 服务器异常或无法连接。
     */
    ConnectionStatus_SERVER_INVALID = 8,

    /**
     * 验证异常(可能由于user验证、版本验证、auth验证)。
     */
    ConnectionStatus_VALIDATE_INVALID = 9,
    /**
     *  开始发起连接
     */
    ConnectionStatus_Connecting = 10,
    /**
     *  连接失败和未连接
     */
    ConnectionStatus_Unconnected = 11,

    /**
     *   注销
     */
    ConnectionStatus_SignUp = 12,
    
    /**
     *   Token无效，可能是token错误，token过期或者后台刷新了密钥等原因
     */
    ConnectionStatus_TOKEN_INCORRECT = 31004,
    
    /**
     *  服务器断开连接
     */
    ConnectionStatus_DISCONN_EXCEPTION = 31011
};

/*!
 @enum RCConversationType 会话类型
 */
typedef NS_ENUM(NSUInteger, RCConversationType) {
    /**
     * 私聊
     */
    ConversationType_PRIVATE = 1,
    /**
     * 讨论组
     */
    ConversationType_DISCUSSION,
    /**
     * 群组
     */
    ConversationType_GROUP,
    /**
     * 聊天室
     */
    ConversationType_CHATROOM,
    /**
     *  客服(仅用于客服1.0系统。客服2.0系统使用订阅号方式，因此需要使用ConversationType_APPSERVICE会话类型）
     */
    ConversationType_CUSTOMERSERVICE,
    /**
     *  系统会话
     */
    ConversationType_SYSTEM,
    /**
     *  订阅号 Custom
     */
    ConversationType_APPSERVICE, // 7

    /**
     *  订阅号 Public
     */
    ConversationType_PUBLICSERVICE,

    /**
     *  推送服务
     */
    ConversationType_PUSHSERVICE
};

/**
 *  @enum 消息方向枚举。
 */
typedef NS_ENUM(NSUInteger, RCMessageDirection) {
    /**
     * 发送
     */
    MessageDirection_SEND = 1, // false

    /**
     * 接收
     */
    MessageDirection_RECEIVE // true
};
/**
 *  @enum 媒体文件类型枚举。
 */
typedef NS_ENUM(NSUInteger, RCMediaType) {
    /**
     * 图片。
     */
    MediaType_IMAGE = 1,

    /**
     * 声音。
     */
    MediaType_AUDIO,

    /**
     * 视频。
     */
    MediaType_VIDEO,

    /**
     * 通用文件。
     */
    MediaType_FILE = 100
};

/**
 *  @enum 消息记录状态
 */
typedef NS_OPTIONS(NSUInteger, RCMessagePersistent) {
    /** 不记录消息 */
    MessagePersistent_NONE = 0,
    /** 记录消息 */
    MessagePersistent_ISPERSISTED = 1 << 0,
    /** 需要计数 */
    MessagePersistent_ISCOUNTED = 1 << 1
};

/**
 * @enum RCSentStatus 发送出的消息的状态。
 */
typedef NS_ENUM(NSUInteger, RCSentStatus) {
    /**
     * 发送中。
     */
    SentStatus_SENDING = 10,

    /**
     * 发送失败。
     */
    SentStatus_FAILED = 20,

    /**
     * 已发送。
     */
    SentStatus_SENT = 30,

    /**
     * 对方已接收。
     */
    SentStatus_RECEIVED = 40,

    /**
     * 对方已读。
     */
    SentStatus_READ = 50,

    /**
     * 对方已销毁。
     */
    SentStatus_DESTROYED = 60
};

/*!
 @enum RCReceivedStatus 消息阅读状态
 */
typedef NS_ENUM(NSUInteger, RCReceivedStatus) {
    /**
     * 未读。
     */
    ReceivedStatus_UNREAD = 0,
    /**
     * 已读。
     */
    ReceivedStatus_READ = 1,
    /**
     * 已收听（语音消息）。
     */
    ReceivedStatus_LISTENED = 2,

    /**
     已下载
     */
    ReceivedStatus_DOWNLOADED = 4,

};

/**
 @enum   RCErrorCode 错误码
 */
typedef NS_ENUM(NSInteger, RCErrorCode) {
    /** 未知错误 */
    ERRORCODE_UNKNOWN = -1,
    /** 超时错误 */
    ERRORCODE_TIMEOUT = 5004,
    /**
     *  被对方加入黑名单时发送消息的状态
     */
    REJECTED_BY_BLACKLIST = 405,
    /**
     *  不在讨论组中。
     */
    NOT_IN_DISCUSSION = 21406,
    /**
     *  不在群组中。
     */
    NOT_IN_GROUP = 22406,
    /**
     *  在群组中被禁言。
     */
    FORBIDDEN_IN_GROUP = 22408,
    /**
     *  不在聊天室中。
     */
    NOT_IN_CHATROOM = 23406,
    
    /**
     *  从服务器获取历史消息服务未开通
     */
    MSG_ROAMING_SERVICE_UNAVAILABLE = 33007,
};

/**
 @enum RCConversationNotificationStatus  会话通知状态
 */
typedef NS_ENUM(NSUInteger, RCConversationNotificationStatus) {
    /** 免打扰 */
    DO_NOT_DISTURB = 0,
    /** 接收新消息通知 */
    NOTIFY = 1,
};
/**
 *  当前连接状态
 */
typedef NS_ENUM(NSUInteger, RCCurrentConnectionStatus) {
    /**
     *  断开连接
     */
    RC_DISCONNECTED = 9,
    /**
     *  连接成功
     */
    RC_CONNECTED = 0,
    /**
     *  连接中
     */
    RC_CONNECTING = 2
};

/**
 *  查询方式
 */
typedef NS_ENUM(NSUInteger, RCSearchType) {
    /**
     *  精确查询
     */
    RC_SEARCH_TYPE_EXACT = 0,
    /**
     *  模糊查询
     */
    RC_SEARCH_TYPE_FUZZY = 1,

};

/**
 *  公众服务号类型
 */
typedef NS_ENUM(NSUInteger, RCPublicServiceType) {
    /**
     *  App服务号
     */
    RC_APP_PUBLIC_SERVICE = 7,
    /**
     *  公众服务号
     */
    RC_PUBLIC_SERVICE = 8,
    
};

/**
 *  公众服务号菜单项类型
 */
typedef NS_ENUM(NSUInteger, RCPublicServiceMenuItemType) {
    /**
     *  公众账号菜单组，内含有子菜单
     */
    RC_PUBLIC_SERVICE_MENU_ITEM_GROUP = 0,
    /**
     *  公众账号菜单项, 响应查看事件
     */
    RC_PUBLIC_SERVICE_MENU_ITEM_VIEW = 1,
    /**
     *  公众账号菜单项, 响应点击事件
     */
    RC_PUBLIC_SERVICE_MENU_ITEM_CLICK = 2,

};

#endif