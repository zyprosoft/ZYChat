//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "UIImage+VKFoundation.h"

@implementation UIImage (VKFoundation)

+ (UIImage *)imageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

- (UIImage *)imageTintedWithColor:(UIColor *)color {
	// This method is designed for use with template images, i.e. solid-coloured mask-like images.
	return [self imageTintedWithColor:color fraction:0.0]; // default to a fully tinted mask of the image.
}


- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction {
	if (color) {
		// Construct new image the same size as this one.
		UIImage *image;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
		if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
			UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f); // 0.f for scale means "scale for device's main screen".
		} else {
			UIGraphicsBeginImageContext([self size]);
		}
#else
		UIGraphicsBeginImageContext([self size]);
#endif
		CGRect rect = CGRectZero;
		rect.size = [self size];

		// Composite tint color at its own opacity.
		[color set];
		UIRectFill(rect);

		// Mask tint color-swatch to this image's opaque mask.
		// We want behaviour like NSCompositeDestinationIn on Mac OS X.
		[self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];

		// Finally, composite this image over the tinted mask at desired opacity.
		if (fraction > 0.0) {
			// We want behaviour like NSCompositeSourceOver on Mac OS X.
			[self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
		}
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		return image;
	}

	return self;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);

    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

    CGContextSetAlpha(ctx, alpha);

    CGContextDrawImage(ctx, area, self.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius) {
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
  CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
  CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
  CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
  CGPathCloseSubpath(path);

  return path;        
}

+ (UIImage*)roundedRectCutOutWithSize:(CGSize)size borderColor:(UIColor*)borderColor backgroundColor:(UIColor*)backgroundColor radius:(CGFloat)radius {

  UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGRect outerRect = CGRectMake(0, 0, size.width, size.height);
  CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, radius);

  CGContextSaveGState(context);
  CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
  CGContextAddPath(context, outerPath);
  CGContextEOClip(context);
  CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
  CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
  CGContextRestoreGState(context);
  
  CGContextSaveGState(context);
  CGContextSetLineWidth(context, 2.0);
  CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
  CGContextAddPath(context, outerPath);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
  
  CGFloat innerMargin = -1.0f;
  CGRect innerRect = CGRectInset(outerRect, innerMargin, innerMargin);
  CGMutablePathRef innerPath = createRoundedRectForRect(innerRect, radius);
  
  CGContextSaveGState(context);
  CGContextSetLineWidth(context, 2.0);
  CGContextSetStrokeColorWithColor(context, backgroundColor.CGColor);
  CGContextAddPath(context, innerPath);
  CGContextClip(context);
  CGContextAddPath(context, innerPath);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
  
  CFRelease(outerPath);
  CFRelease(innerPath);

  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  
  return image;
}

@end
