//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerCaption.h"
#import "VKVideoPlayerTrack.h"
#import "VKVideoPlayerConfig.h"

#define kMinGapDurationInSeconds 7
#define kDurationThresholdInMinutes 5

@implementation VKVideoPlayerCaption
@synthesize languageCode;
@synthesize segments = _segments;
@synthesize boundryTimes = _boundryTimes;
@synthesize preferredAdSlotTimes = _preferredAdSlotTimes;
@synthesize invalidSegments = _invalidSegments;

- (id)initWithRawString:(NSString *)subtitleRawData {
  self = [super init];
  if (self) {
    
    __weak __typeof(self) weakSelf = self;
    [self parseSubtitleRaw:subtitleRawData completion:^(NSMutableArray *segments, NSMutableArray *invalidSegments) {
      weakSelf.segments = segments;
      weakSelf.invalidSegments = invalidSegments;
      [weakSelf processSegments:weakSelf.segments];
    }];
  }
  return self;
}

- (void)parseSubtitleRaw:(NSString *)string completion:(void (^)(NSMutableArray *segments, NSMutableArray *invalidSegments))completion {
  completion(nil, nil);
}



- (NSInteger)millisecondsFromTimecodeString:(NSString *)timecodeString {
  NSArray *timeComponents = [timecodeString componentsSeparatedByString:@":"];
  
  NSInteger hours = 0;
  NSInteger minutes = 0;
  NSArray *secondsComponents;
  NSInteger seconds = 0;
  NSInteger milliseconds = 0;
  
  if (timeComponents.count > 0) hours = [(NSString *)[timeComponents objectAtIndex:0] integerValue];
  if (timeComponents.count > 1) minutes = [(NSString *)[timeComponents objectAtIndex:1] integerValue];
  
  if (timeComponents.count > 2) {
    secondsComponents = [(NSString *)[timeComponents objectAtIndex:2] componentsSeparatedByString:@","];
    if (secondsComponents.count > 0) seconds = [(NSString *)[secondsComponents objectAtIndex:0] integerValue];
    if (secondsComponents.count > 1) milliseconds = [(NSString *)[secondsComponents objectAtIndex:1] integerValue];
  }
  
  NSInteger totalNumSeconds = (hours * 3600) + (minutes * 60) + seconds;
  return totalNumSeconds * 1000 + milliseconds;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
//  self = [super initWithAttributes:(NSDictionary *)attributes];
  self = [super init];
  if (!self) return nil;
  self.languageCode = [attributes valueForKeyPathWithNilCheck:@"language_code"];
  self.segments = [attributes valueForKeyPathWithNilCheck:@"subtitles"];
  
  [self processSegments:self.segments];
  return self;
}

- (NSNumber*)closestPreferredAdSlotTimeInMilliseconds:(NSNumber*)timeInMilliseconds {
  if (self.preferredAdSlotTimes.count == 0) return nil;
  
  NSUInteger index = [self.preferredAdSlotTimes indexOfObject:timeInMilliseconds inSortedRange:NSMakeRange(0, self.preferredAdSlotTimes.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
    NSNumber* n1 = obj1;
    NSNumber* n2 = obj2;
    return [n1 compare:n2];
  }];
  
  if (index >= self.preferredAdSlotTimes.count) index = self.preferredAdSlotTimes.count - 1;
  CGFloat preferredAdSlotTime = [self.preferredAdSlotTimes[index] floatValue];
  
  BOOL isLessThanDurationThreshold = preferredAdSlotTime < ([timeInMilliseconds floatValue] + (kDurationThresholdInMinutes * 60 * 1000));
  BOOL isMoreThanCurrentTime = preferredAdSlotTime > [timeInMilliseconds floatValue];
  
  if (isMoreThanCurrentTime && isLessThanDurationThreshold) {
    return self.preferredAdSlotTimes[index];
  } else {
    return nil;
  }
}

- (NSString*)contentAtTime:(NSInteger)timeInMilliseconds {
  NSDictionary* time = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"", @"content",
                        [NSNumber numberWithInteger:timeInMilliseconds], @"start_time",
                        @"", @"end_time",
                        nil];
  
  NSUInteger index = [self.segments indexOfObject:time inSortedRange:NSMakeRange(0, self.segments.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
    NSNumber* n1 = [obj1 valueForKeyPath:@"start_time"];
    NSNumber* n2 = [obj2 valueForKeyPath:@"start_time"];
    if (!n1) n1 = [NSNumber numberWithInt:0];
    if (!n2) n2 = [NSNumber numberWithInt:0];
    return [n1 compare:n2];
  }];
  
  if (index >= self.segments.count) {
    index = self.segments.count - 1;
  }
  
  NSInteger segmentStartTime = [[[self.segments objectAtIndex:index] valueForKeyPath:@"start_time"] integerValue];
  NSInteger segmentEndTime = [[[self.segments objectAtIndex:index] valueForKeyPath:@"end_time"] integerValue];
  
  if (index == 0 && timeInMilliseconds < segmentStartTime) {
    //case when before any segments
    return @"";
  }
  
  if (segmentStartTime == timeInMilliseconds) { //case when exactly the start of a new segment, so use that segment
  } else {
    //use the segment just before but check for edgecase when only 1 segment and index is already 0
    if (index > 0) index--;
    segmentStartTime = [[[self.segments objectAtIndex:index] valueForKeyPath:@"start_time"] integerValue];
    segmentEndTime = [[[self.segments objectAtIndex:index] valueForKeyPath:@"end_time"] integerValue];
  }
  
  if (timeInMilliseconds >= segmentStartTime && timeInMilliseconds < segmentEndTime) {
    return [[self.segments objectAtIndex:index] valueForKeyPath:@"content"];
  } else return @"";
}

- (void)processSegments:(NSArray*)segments {
  NSMutableArray* times = [NSMutableArray array];
  NSMutableArray* adSlotTimes = [NSMutableArray array];
  
  for (int i=0; i < segments.count; i++) {
    NSNumber* startTime = [segments[i] valueForKeyPath:@"start_time"];
    NSNumber* endTime = [segments[i] valueForKeyPath:@"end_time"];
    [times addObject:[NSValue valueWithCMTime:CMTimeMake([startTime integerValue], 1000)]];
    [times addObject:[NSValue valueWithCMTime:CMTimeMake([endTime integerValue], 1000)]];
    
    if (i+1 < segments.count) {
      NSNumber* gapStartTime = [segments[i] valueForKeyPath:@"end_time"];
      NSNumber* gapEndTime = [segments[i+1] valueForKeyPath:@"start_time"];
      CGFloat gap = [gapEndTime floatValue] - [gapStartTime floatValue];
      if (gap >= kMinGapDurationInSeconds * 1000) {
        [adSlotTimes addObject:[NSNumber numberWithFloat:[gapStartTime floatValue] + gap/2]];
      }
    }
  }
  
  self.boundryTimes = times;
  self.preferredAdSlotTimes = adSlotTimes;
}

+ (NSString*)captionType { return @"subtitles"; }


@end
