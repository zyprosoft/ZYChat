/*!
 @header EaseMobHeaders.h
 @abstract 引入SDK的所有需要的头文件
 @author EaseMob Inc.
 @version 1.0
 */

#ifndef demoApp_EaseMobHeaders_h
#define demoApp_EaseMobHeaders_h

//defs
#define kSDKAppKey @"EASEMOB_APPKEY"
#define kSDKApnsCertName @"EASEMOB_APNSCERTNAME"
#define kSDKConfigEnableConsoleLogger @"EASEMOB_CONFIG_ENABLECONSOLELOGGER"

//private server
#define kSDKServerApi @"EASEMOB_API_ADDRESS"
#define kSDKServerChat @"EASEMOB_IM_ADDRESS"
#define kSDKServerChatPort @"EASEMOB_IM_PORT"
#define kSDKServerGroupDomain @"EASEMOB_GROUP_DOMAIN"
#define kSDKServerChatDomain @"EASEMOB_CHAT_DOMAIN"
#define kSDKConfigUseHttps @"EASEMOB_CONFIG_USEHTTPS"
#define kSDKConfigEnableIPAccess @"EASEMOB_ENABLE_IP_ACCESS"
#define kSDKConfigPingIntervalWifi @"EASEMOB_PING_INTERVAL_WIFI"
#define kSDKConfigPingIntervalWwan @"EASEMOB_PING_INTERVAL_WWAN"

//defs headers
#import "EMChatManagerDefs.h"
#import "EMDeviceManagerDefs.h"
#import "EMErrorDefs.h"

//managers & delegates
#import "IChatManager.h"
#import "IDeviceManager.h"
#import "IChatManagerDelegate.h"
#import "IDeviceManagerDelegate.h"

//messages
#import "EMMessage.h"

//message bodies
#import "IEMMessageBody.h"
#import "EMVideoMessageBody.h"
#import "EMVoiceMessageBody.h"
#import "EMTextMessageBody.h"
#import "EMLocationMessageBody.h"
#import "EMImageMessageBody.h"
#import "EMCommandMessageBody.h"
#import "EMFileMessageBody.h"

//chat types
#import "EMChatVideo.h"
#import "EMChatVoice.h"
#import "EMChatText.h"
#import "EMChatLocation.h"
#import "EMChatImage.h"
#import "EMChatFile.h"
#import "EMChatCommand.h"

//user types
#import "EMBuddy.h"

//chat sessions
#import "EMGroup.h"
#import "EMGroupStyleSetting.h"
#import "IChatImageOptions.h"
#import "EMConversation.h"
#import "EMReceipt.h"

//error
#import "EMError.h"

//push
#import "EMPushNotificationOptions.h"

//chat progress
#import "IEMChatProgressDelegate.h"

//cryptor
#import "IEMChatCryptor.h"

#endif
