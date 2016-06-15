//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VKFoundation)

- (NSString*)substringWithMinLength:(NSInteger)length;
- (BOOL)isEmpty;
- (NSString*)stripHtml;
@end
