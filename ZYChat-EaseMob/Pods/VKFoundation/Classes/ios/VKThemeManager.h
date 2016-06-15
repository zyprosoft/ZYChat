//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#define VKSharedThemeManager [VKThemeManager sharedThemeManager]
#define THEMEMAN(key) [VKSharedThemeManager value:key]
#define THEMECOLOR(key) [VKSharedThemeManager color:key]
#define THEMEFONT(key, fontSize) [VKSharedThemeManager font:key size:fontSize]
#define DEVICEVALUE(ipadValue, iphoneValue) ([VKSharedUtility isPad] ? (ipadValue) : (iphoneValue))

typedef enum {
  VKThemeManagerStyleDark,
  VKThemeManagerStyleLight
} VKThemeManagerStyle;

#import <Foundation/Foundation.h>

@interface VKThemeManager : NSObject

@property (nonatomic, assign) VKThemeManagerStyle style;
@property (nonatomic, strong) NSDictionary* database;

+ (instancetype)sharedThemeManager;
- (void)appendThemes:(NSDictionary*)newThemes fix:(BOOL)fix;
- (NSString*)value:(NSString*)key;
- (UIColor*)color:(NSString*)key;
- (UIFont*)font:(NSString*)key size:(CGFloat)size;

@end

@interface NSString (ThemeSupport)
- (NSAttributedString*)attributedStringWithFontFamily:(NSString*)fontFamily fontSize:(NSNumber*)fontSize fontHexString:(NSString*)fontHexString;
- (NSAttributedString*)attributedStringWithFontSize:(NSNumber*)fontSize fontHexString:(NSString*)fontHexString;
- (NSAttributedString*)attributedStringWithFontFamily:(NSString*)fontFamily fontSize:(NSNumber*)fontSize fontHexString:(NSString*)fontHexString options:(NSMutableDictionary*)options;

@end

@interface UIColor (ThemeSupport)
- (NSString*)hexString;
@end