//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

@interface UILabel (VKFoundation)
- (void)alignTop;
- (void)alignBottom;
- (void)sizeToFitMaxSize:(CGSize)size;
- (void)sizeToFitMaxHeight:(CGFloat)maxHeight;
- (void)sizeToFitMaxLines:(NSInteger)lines;
@end
