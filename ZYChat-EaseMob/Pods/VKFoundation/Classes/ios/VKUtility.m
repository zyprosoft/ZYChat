//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKUtility.h"
#import "Reachability.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "VKFoundation.h"

#ifdef DEBUG
  static const int ddLogLevel = LOG_LEVEL_WARN;
#else
  static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface VKUtility ()
@property (nonatomic, strong) UIColor *cachedBackgroundColor;
@end

@implementation VKUtility

@synthesize cachedBackgroundColor;
@synthesize wifiReach = _wifiReach;
@synthesize internetReach = _internetReach;

+ (instancetype)sharedInstance {
   static id sharedInstance = nil;

   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
   });

   return sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    self.internetReach = [Reachability reachabilityForInternetConnection];
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
  }
  return self;
}

- (void)dealloc {
  [self.wifiReach stopNotifier];
}

- (UIWindow *)deviceWindow {
  UIApplication *app = [UIApplication sharedApplication];
  UIWindow* window = app.keyWindow;
  if (!window) window = [app.windows objectAtIndex:0];
  return window;
}


- (NSString *)shortDeviceModel {
  NSArray *deviceModelStrTokens = [[[UIDevice currentDevice] model] componentsSeparatedByString:@" "];
  return (deviceModelStrTokens.count > 0) ? [deviceModelStrTokens objectAtIndex:0] : nil;
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
  [self showAlertViewWithTitle:title message:message tag:0 delegate:nil];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id<UIAlertViewDelegate>)delegate {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil
                                                cancelButtonTitle:@"Okay" otherButtonTitles:nil];
  alertView.tag = tag;
  alertView.delegate = delegate;
  [alertView show];
}

- (NSString *)shorten:(NSString *)str {
  int n = 250;
  if (str.length > n) return [[str substringToIndex:n] stringByAppendingString:@"..."];
  return str;
}

- (id)setting:(NSString *)key {
  id setting = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  //DDLogVerbose(@"Setting for %@: %@", key, setting);
  return setting;
}

- (void)setSetting:(id)setting forKey:(NSString *)key {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (setting == nil) {
    [defaults removeObjectForKey:key];
  }
  DDLogVerbose(@"Setting %@ to %@", key, setting);
  [defaults setValue:setting forKey:key];
  [defaults synchronize];
}

- (id)settingCustomObject:(NSString *)key {
  NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  id setting = encodedObject ? [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject] : nil;
  //DDLogVerbose(@"Setting for %@: %@", key, setting);
  return setting;
}

- (void)setSettingCustomObject:(id)setting forKey:(NSString *)key {
  DDLogVerbose(@"Setting %@ to %@", key, setting);
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:setting];
  [defaults setValue:encodedObject forKey:key];
  [defaults synchronize];
}


- (void)setDefaultSettings:(NSDictionary *)dictionary {
  [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (NSRunLoop *)mainRunLoop {
  return [NSRunLoop mainRunLoop];
}

- (id)appDelegate {
  return (id)[UIApplication sharedApplication].delegate;
}

- (BOOL)isConnected {
  return [self.internetReach currentReachabilityStatus] != NotReachable;
}

- (BOOL)isConnectedViaWiFi {
  return [self.wifiReach isReachableViaWiFi];
}

- (BOOL)isPad {
  return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (BOOL)isIos5 {
  float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
  return deviceVersion >= 5.0;
}

- (NSString *)platform {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString *platform = [NSString stringWithUTF8String:machine];
  free(machine);
  return platform;
}

- (NSString *)defaultUserAgentString {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];

  // Attempt to find a name for this application
  NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
  if (!appName) {
    appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
  }

  NSData *latin1Data = [appName dataUsingEncoding:NSUTF8StringEncoding];
  appName = [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];

  // If we couldn't find one, we'll give up (and ASIHTTPRequest will use the standard CFNetwork user agent)
  if (!appName) {
    return nil;
  }

  NSString *appVersion = [self appVersion];
  NSString *deviceName;
  NSString *OSName;
  NSString *OSVersion;
  NSString *locale = [[NSLocale currentLocale] localeIdentifier];

#if TARGET_OS_IPHONE
  UIDevice *device = [UIDevice currentDevice];
  deviceName = [device model];
  OSName = [device systemName];
  OSVersion = [device systemVersion];

#else
  deviceName = @"Macintosh";
  OSName = @"Mac OS X";

  // From http://www.cocoadev.com/index.pl?DeterminingOSVersion
  // We won't bother to check for systems prior to 10.4, since ASIHTTPRequest only works on 10.5+
  OSErr err;
  SInt32 versionMajor, versionMinor, versionBugFix;
  err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
  if (err != noErr) return nil;
  err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
  if (err != noErr) return nil;
  err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
  if (err != noErr) return nil;
  OSVersion = [NSString stringWithFormat:@"%u.%u.%u", versionMajor, versionMinor, versionBugFix];
#endif

  // Takes the form "My Application 1.0 (Macintosh; Mac OS X 10.5.7; en_GB)"
  NSString *bundleIdentifier = [bundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
  return [NSString stringWithFormat:@"ViKiMobile %@ %@ %@ (%@; %@ %@; %@)", bundleIdentifier, appName, appVersion, deviceName, OSName, OSVersion, locale];
}

- (NSString *)floatToIntString:(float)num {
  return [NSString stringWithFormat:@"%ld", (long)[[NSNumber numberWithFloat:num] integerValue]];
}

- (NSString *)doubleToIntString:(double)num {
  return [NSString stringWithFormat:@"%ld", (long)[[NSNumber numberWithDouble:num] integerValue]];
}

- (NSString *)readableValueWithBytes:(id)bytes{
  NSString *readable = @"";
  //round bytes to one kilobyte, if less than 1024 bytes
  if (([bytes longLongValue] < 1024)){
    readable = [NSString stringWithFormat:@"1 KB"];
  }
  //kilobytes
  if (([bytes longLongValue]/1024)>=1){
    readable = [NSString stringWithFormat:@"%lld KB", ([bytes longLongValue]/1024)];
  }
  //megabytes
  if (([bytes longLongValue]/1024/1024)>=1){
    readable = [NSString stringWithFormat:@"%lld MB", ([bytes longLongValue]/1024/1024)];
  }
  //gigabytes
  if (([bytes longLongValue]/1024/1024/1024)>=1){
    readable = [NSString stringWithFormat:@"%lld GB", ([bytes longLongValue]/1024/1024/1024)];
  }
  //terabytes
  if (([bytes longLongValue]/1024/1024/1024/1024)>=1){
    readable = [NSString stringWithFormat:@"%lld TB", ([bytes longLongValue]/1024/1024/1024/1024)];
  }
  //petabytes
  if (([bytes longLongValue]/1024/1024/1024/1024/1024)>=1){
    readable = [NSString stringWithFormat:@"%lld PB", ([bytes longLongValue]/1024/1024/1024/1024/1024)];
  }
  return readable;
}

- (NSAttributedString*)attributedStringWithHTML:(NSString*)html styleBlock:(NSString*)styleBlock {
  return [[NSAttributedString alloc] initWithHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding] options:[NSDictionary dictionaryWithObject:[[DTCSSStylesheet alloc] initWithStyleBlock:styleBlock] forKey:DTDefaultStyleSheet] documentAttributes:NULL];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
  NSArray *pairs = [query componentsSeparatedByString:@"&"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  for (NSString *pair in pairs) {
      NSArray *kv = [pair componentsSeparatedByString:@"="];
      NSString *val = @"";
      if (kv.count > 1) {
        val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      }
      if (kv.count > 0) {
        [params setObject:val forKey:kv[0]];
      }
  }
  return params;
}

- (NSString *)timeStringFromSecondsValue:(int)seconds {
  NSString *retVal;
  int hours = seconds / 3600;
  int minutes = (seconds / 60) % 60;
  int secs = seconds % 60;
  if (hours > 0) {
    retVal = [NSString stringWithFormat:@"%01d:%02d:%02d", hours, minutes, secs];
  } else {
    retVal = [NSString stringWithFormat:@"%02d:%02d", minutes, secs];
  }
  return retVal;
}

- (void)logMessage:(NSString *)log, ... {
  va_list args;
  va_start(args, log);
  NSString *s =
      [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@\n", log]
                             arguments:args];
  DDLogWarn(@"%@", s);
  va_end(args);
}

- (CGRect)statusBarFrameViewRect:(UIView*)view  {
  CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
  CGRect statusBarWindowRect = [view.window convertRect:statusBarFrame fromWindow: nil];
  CGRect statusBarViewRect = [view convertRect:statusBarWindowRect fromView: nil];
  return statusBarViewRect;
}

- (CGFloat)statusBarHeight:(UIView*)view {
  CGRect statusBarFrame = [self statusBarFrameViewRect:view];
  CGFloat statusBarHeight = MIN(CGRectGetHeight(statusBarFrame), CGRectGetWidth(statusBarFrame));
  if (statusBarHeight < 1.0f) {
    statusBarHeight = 20.0f;
  }
  return statusBarHeight;
}

- (NSString *)appVersion {
  NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
  NSString* CFBundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
  NSString* CFBundleShortVersionString = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  if ([CFBundleVersion isEqualToString:CFBundleShortVersionString]) {
    return [NSString stringWithFormat:@"%@", CFBundleShortVersionString];
  } else {
    return [NSString stringWithFormat:@"%@.%@", CFBundleShortVersionString, CFBundleVersion];
  }
}

@end

@implementation VKUtility (MemoryHogging)

- (void)eatUpAllThatMemory:(NSInteger)MB {
  Byte *p[10000];
  for (int i = 0; i < MB; i++) {
    p[i] = malloc(1048576);
    memset(p[i], 0, 1048576);
  }
}

@end
