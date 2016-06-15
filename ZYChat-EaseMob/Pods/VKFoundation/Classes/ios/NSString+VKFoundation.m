//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "NSString+VKFoundation.h"

@interface VKFoundation_stripHtml_XMLParsee : NSObject<NSXMLParserDelegate> {
@private
  NSMutableArray* strings;
}
- (NSString*)getCharsFound;
@end

@implementation VKFoundation_stripHtml_XMLParsee
- (id)init {
  if((self = [super init])) {
    strings = [[NSMutableArray alloc] init];
  }
  return self;
}
- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
  [strings addObject:string];
}
- (NSString*)getCharsFound {
  return [strings componentsJoinedByString:@""];
}
@end

@implementation NSString (VKFoundation)

- (NSString*)substringWithMinLength:(NSInteger)length {
  // rangeOfComposedCharacterSequencesForRange has a probrem when length is 0
  // refer http://stackoverflow.com/questions/15155913/rangeofcomposedcharactersequencesforrange-transforming-0-character-range-into-1
  
  // define the range you're interested in
//  NSRange stringRange = {0, MIN([self length], length)};

  // adjust the range to include dependent chars
//  stringRange = [self rangeOfComposedCharacterSequencesForRange:stringRange];

  // Now you can create the short string
//  return [self substringWithRange:stringRange];
  return [self substringToIndex:MIN([self length], length)];
}

- (BOOL)isEmpty {
   if([self length] == 0) { //string is empty or nil
       return YES;
   } 

   if(![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
       //string is all whitespace
       return YES;
   }

   return NO;
}

- (NSString*)stripHtml {
  // take this string obj and wrap it in a root element to ensure only a single root element exists
  NSString* string = [NSString stringWithFormat:@"<root>%@</root>", self];
  
  // add the string to the xml parser
  NSStringEncoding encoding = string.fastestEncoding;
  NSData* data = [string dataUsingEncoding:encoding];
  NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
  
  // parse the content keeping track of any chars found outside tags (this will be the stripped content)
  VKFoundation_stripHtml_XMLParsee* parsee = [[VKFoundation_stripHtml_XMLParsee alloc] init];
  parser.delegate = parsee;
  [parser parse];
  
  // log any errors encountered while parsing
  //NSError * error = nil;
  //if((error = [parser parserError])) {
  //    NSLog(@"This is a warning only. There was an error parsing the string to strip HTML. This error may be because the string did not contain valid XML, however the result will likely have been decoded correctly anyway.: %@", error);
  //}
  
  // any chars found while parsing are the stripped content
  NSString* strippedString = [parsee getCharsFound];
  
  // get the raw text out of the parsee after parsing, and return it
  return strippedString;
}
@end
