//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerCaptionSRT.h"

@implementation VKVideoPlayerCaptionSRT

#pragma mark - VKVideoPlayerCaptionParserProtocol
- (void)parseSubtitleRaw:(NSString *)srt completion:(void (^)(NSMutableArray* segments, NSMutableArray* invalidSegments))completion {

  NSMutableArray* segments = [NSMutableArray array];
  NSMutableArray* invalidSegments = [NSMutableArray array];
  NSScanner *scanner = [NSScanner scannerWithString:srt];
  while (![scanner isAtEnd]) {
    NSString *indexString;
    NSString *startString;
    NSString *endString;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&indexString];
    [scanner scanUpToString:@" --> " intoString:&startString];
    [scanner scanString:@"-->" intoString:NULL];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&endString];
    
    NSString *textString;
    [scanner scanUpToString:@"\r\n\r\n" intoString:&textString];
    textString = [textString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
    textString = [textString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    // Addresses trailing space added if CRLF is on a line by itself at the end of the SRT file
    textString = [textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSNumber *start = [NSNumber numberWithInteger:[self millisecondsFromTimecodeString:startString]];
    NSNumber *end = [NSNumber numberWithInteger:[self millisecondsFromTimecodeString:endString]];
    BOOL isNegativeTime = [start integerValue] > [self millisecondsFromTimecodeString:@"20:00:00,000"] || [end integerValue] > [self millisecondsFromTimecodeString:@"20:00:00,000"];
    BOOL isOverlappingSegment = segments.count > 0 && [segments.lastObject[@"end_time"] integerValue] > [start integerValue];
    BOOL isNextSegment = segments.count == 0 || [indexString integerValue] > [segments.lastObject[@"index"] integerValue];
    BOOL isValidSegment = [start compare:end] == NSOrderedAscending;
    if (!isNegativeTime && isValidSegment && isNextSegment && !isOverlappingSegment) {
      NSMutableDictionary* segment = [NSMutableDictionary dictionary];
      [segment setValue:[NSNumber numberWithInteger:[indexString integerValue]] forKey:@"index"];
      [segment setValue:start forKey:@"start_time"];
      [segment setValue:end forKey:@"end_time"];
      [segment setValue:textString forKey:@"content"];
      [segments addObject:segment];
    } else {
//      DDLogVerbose(@"\nInvalid segment: %@\nPrevious Endtime: %@\nstarttime %@\nendtime %@", textString, segments.lastObject[@"end_time"] ? segments.lastObject[@"end_time"] : @"unknown", start, end);
      [invalidSegments addObject:textString];
    }
  }
  
//  self.segments = segments;
//  self.invalidSegments = invalidSegments;
//  [self processSegments:self.segments];
//  return self;
  
  completion(segments, invalidSegments);
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

@end
