//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

@interface UIImage (VKFoundation)

+ (UIImage*)imageWithColor:(UIColor *)color;
- (UIImage *)imageTintedWithColor:(UIColor *)color;
- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

+ (UIImage*)roundedRectCutOutWithSize:(CGSize)size borderColor:(UIColor*)borderColor backgroundColor:(UIColor*)backgroundColor radius:(CGFloat)radius;

@end
