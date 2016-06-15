//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerSettingsManager.h"
#import "VKVideoPlayerConfig.h"
#import "NSString+VKFoundation.h"

@implementation VKVideoPlayerSettingsManager
+ (VKVideoPlayerSettingsManager*)sharedInstance {
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}

- (NSString*)defaultLanguageCode {
  NSString* languageCode = ([[NSLocale preferredLanguages] objectAtIndex:0] == nil) ? @"en" : [[NSLocale preferredLanguages] objectAtIndex:0];
//  DDLogVerbose(@"DEFAULT LANGUAGE CODE: %@", languageCode);
  return [languageCode substringWithMinLength:2];
}

//- (BOOL)isAutoPlayEnabled { return [[VKSharedUtility setting:kVKSettingsAutoPlayEnabledKey] boolValue]; }
//- (BOOL)isPublishToFBTimelineEnabled {
//  return [VKSharedAppSession.user.ogWatch boolValue] && [VKSharedFacebookGateway isAbleToPublish];
//}

- (BOOL)isSubtitlesEnabled { return [[VKSharedUtility setting:kVKSettingsSubtitlesEnabledKey] boolValue]; }
- (BOOL)isTopSubtitlesEnabled { return [[VKSharedUtility setting:kVKSettingsTopSubtitlesEnabledKey] boolValue]; }

- (NSString*)subtitleLanguageCode { return [VKSharedUtility setting:kVKSettingsSubtitleLanguageCodeKey]; }

- (NSArray*)subtitleSizes {
  return @[
           NSLocalizedString(@"subtitleSize.tiny", nil),
           NSLocalizedString(@"subtitleSize.medium", nil),
           NSLocalizedString(@"subtitleSize.large", nil),
           NSLocalizedString(@"subtitleSize.huge", nil),
           ];
}

- (NSString*)subtitleSizeDescription {
  return [self.subtitleSizes objectAtIndex:[[VKSharedUtility setting:kVKSettingsSubtitleSizeKey] intValue]];
}

#pragma mark - Video Quality

- (void)setVideoQuality:(NSString *)videoQuality {
  
  NSUInteger index = [self.videoQualityOptions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    return [videoQuality isEqualToString:obj];
  }];
  
  if (index == NSNotFound) {
    videoQuality = kVKStreamKeyAuto;
  }
  
  NSString* streamKey = [VKSharedUtility setting:kVKVideoQualityKey];
  if ([streamKey isEqualToString:videoQuality]) {
    return;
  }
  
  [VKSharedUtility setSetting:videoQuality forKey:kVKVideoQualityKey];
}

- (NSString*)videoQualityShortDescription:(NSString*)streamKey {
  if ([streamKey isEqualToString:kVKStreamKey240p]) {
    return kVKStreamKey240p;
  } else if ([streamKey isEqualToString:kVKStreamKey360p]) {
    return kVKStreamKey360p;
  } else if ([streamKey isEqualToString:kVKStreamKey480p]) {
    return kVKStreamKey480p;
  } else if ([streamKey isEqualToString:kVKStreamKey720p]) {
    return kVKStreamKey720p;
  } else {
    return @"AUTO";
  }
}

- (NSString*)videoQualityLongDescription:(NSString*)streamKey {
  if ([streamKey isEqualToString:kVKStreamKey240p]) {
    return NSLocalizedString(kVKVideoQuality240p, nil);
  } else if ([streamKey isEqualToString:kVKStreamKey360p]) {
    return NSLocalizedString(kVKVideoQuality360p, nil);
  } else if ([streamKey isEqualToString:kVKStreamKey480p]) {
    return NSLocalizedString(kVKVideoQuality480p, nil);
  } else if ([streamKey isEqualToString:kVKStreamKey720p]) {
    return NSLocalizedString(kVKVideoQuality720p, nil);
  } else {
    return NSLocalizedString(kVKVideoQualityAuto, nil);
  }
}

- (NSString*)streamKey {
  NSString* streamKey = kVKStreamKeyAuto;
  if ([VKSharedUtility isConnectedViaWiFi]) {
    streamKey = [VKSharedUtility setting:kVKVideoQualityKey];
    
    NSUInteger index = [self.videoQualityOptions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
      return [streamKey isEqualToString:obj];
    }];
    
    if (index == NSNotFound) {
      streamKey = kVKStreamKeyAuto;
    }
  }
  
//  if (VKSharedChromeCast.isActive && [streamKey isEqualToString:kVKStreamKeyAuto]) {
//    streamKey = kVKStreamKey480p;
//  }
  
  return streamKey;
}

- (NSString*)streamType {
  if ([[self streamKey] isEqualToString:kVKStreamKeyAuto]) {
    return @"hls";
  } else {
    return @"http";
  }
}

- (NSString*)streamQualityForKey:(NSString*)streamKey {
  if ([streamKey isEqualToString:kVKStreamKeyAuto]) {
    return @"variable";
  } else {
    return streamKey;
  }
}
@end
