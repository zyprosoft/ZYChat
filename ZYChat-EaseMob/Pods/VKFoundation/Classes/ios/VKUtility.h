//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#define VKSharedUtility [VKUtility sharedInstance]

@class Reachability;

@interface VKUtility : NSObject

@property (nonatomic, strong) Reachability* wifiReach;
@property (nonatomic, strong) Reachability* internetReach;


+ (instancetype)sharedInstance;

- (UIWindow *)deviceWindow;
- (NSString *)shortDeviceModel;
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id<UIAlertViewDelegate>)delegate;

- (NSString *)shorten:(NSString *)str;

- (id)setting:(NSString *)key;
- (void)setSetting:(id)setting forKey:(NSString *)key;
- (id)settingCustomObject:(NSString *)key;
- (void)setSettingCustomObject:(id)setting forKey:(NSString *)key;
- (void)setDefaultSettings:(NSDictionary *)dictionary;
- (NSRunLoop *)mainRunLoop;
- (BOOL)isConnected;
- (BOOL)isConnectedViaWiFi;
- (BOOL)isPad;
- (BOOL)isIos5;
- (NSString *)platform;
- (NSString *)floatToIntString:(float)num;
- (NSString *)doubleToIntString:(double)num;
- (NSString *)readableValueWithBytes:(id)bytes;
- (NSAttributedString*)attributedStringWithHTML:(NSString*)html styleBlock:(NSString*)styleBlock;

- (NSString *)defaultUserAgentString;
- (NSDictionary*)parseURLParams:(NSString *)query;
- (NSString *)timeStringFromSecondsValue:(int)seconds;
- (void)logMessage:(NSString *)log, ...;

- (CGRect)statusBarFrameViewRect:(UIView*)view;
- (CGFloat)statusBarHeight:(UIView*)view;
@end

@interface VKUtility (MemoryHogging)
- (void)eatUpAllThatMemory:(NSInteger)MB;
@end
