//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKThemeManager.h"
#import "VKFoundation.h"

@interface VKThemeManager()
@property (nonatomic, assign, getter=isFixed) BOOL fixed;
@end

@implementation VKThemeManager

+ (instancetype)sharedThemeManager {
  static VKThemeManager *_sharedThemeManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedThemeManager = [[VKThemeManager alloc] init];
  });
  return _sharedThemeManager;
}

- (id)init {
  self = [super init];
  if (self) {
    self.style = VKThemeManagerStyleLight;
    self.database = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"VKFoundation_themes" ofType:@"plist"]];
  }
  return self;
}

- (void)appendThemes:(NSDictionary*)newThemes fix:(BOOL)fix {
  if (self.isFixed) {
    return;
  }

  NSMutableDictionary *themes = (self.database ? self.database : @{}).mutableCopy;
  for (id key in newThemes) {
    id obj = [newThemes objectForKey:key];
    [themes setValue:obj forKey:key];
  }
  self.database = [NSDictionary dictionaryWithDictionary:themes];

  if (fix) {
    self.fixed = fix;
  }
}

- (NSString*)themeName {
  switch (self.style) {
    case VKThemeManagerStyleDark:
      return @"dark";
      break;
    case VKThemeManagerStyleLight:
      return @"light";
      break;
    default:
      return @"dark";
      break;
  }
}

- (NSString*)value:(NSString*)key {
  return [self.database valueForKeyPathWithNilCheck:[NSString stringWithFormat:@"%@.%@", key, [self themeName]]];
}

- (UIColor*)color:(NSString*)key {

  return DTColorCreateWithHexString([self value:key]);
}

- (UIFont*)font:(NSString*)key size:(CGFloat)size {
  NSString* fontName = [self value:key];
  UIFont* font = [UIFont fontWithName:fontName size:size];
  return font;
}

@end

@implementation NSString (ThemeSupport)

- (NSAttributedString*)attributedStringWithFontFamily:(NSString*)fontFamily fontSize:(NSNumber*)fontSize fontHexString:(NSString*)fontHexString {
  return [self attributedStringWithFontFamily:fontFamily fontSize:fontSize fontHexString:fontHexString options:nil];
}

- (NSAttributedString*)attributedStringWithFontFamily:(NSString*)fontFamily fontSize:(NSNumber*)fontSize fontHexString:(NSString*)fontHexString options:(NSMutableDictionary*)options {
  NSMutableDictionary* defaultOptions = [NSMutableDictionary dictionaryWithDictionary:@{
    @"DTDefaultFontFamily": fontFamily,
    @"DTDefaultFontSize": fontSize,
    @"DTDefaultTextColor": [NSString stringWithFormat:@"#%@", fontHexString]
  }];
  
  [defaultOptions addEntriesFromDictionary:options];

  return [[NSAttributedString alloc] initWithHTMLData:[self dataUsingEncoding:NSUTF8StringEncoding] options:defaultOptions documentAttributes:NULL];
}

- (NSAttributedString*)attributedStringWithFontSize:(NSNumber*)fontSize fontHexString:(NSString*)fontHexString {
  return [self attributedStringWithFontFamily:THEMEMAN(@"fontLight") fontSize:fontSize fontHexString:fontHexString options:nil];
}

@end

@implementation UIColor (ThemeSupport)

- (NSString*)hexString {
  const CGFloat *components = CGColorGetComponents(self.CGColor);
  CGFloat r = components[0];
  CGFloat g = components[1];
  CGFloat b = components[2];
  NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
  return hexString;
}

@end
