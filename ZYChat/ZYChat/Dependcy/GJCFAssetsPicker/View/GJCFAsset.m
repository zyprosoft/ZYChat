//
//  GJAsset.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAsset.h"
#import <CoreImage/CoreImage.h>

@implementation GJCFAsset


- (id)initWithAsset:(ALAsset *)asset
{
    if (self = [super init]) {
        
        self.containtAsset = asset;
        self.selected = NO;

    }
    return self;
}

- (BOOL)isEqual:(GJCFAsset *)asset
{
    if (![asset isKindOfClass:[GJCFAsset class]]) {
        return NO;
    }
    
    if (!asset) {
        return NO;
    }
    
    if (!self.containtAsset || !asset.containtAsset) {
        return NO;
    }
    
    /*
     * 如果要考虑，判断已经选中过的图片的时候，可以用这个来做对比，但是效率也不是很高，暂时不做图片对比
     *
     * return [[self fileName] isEqual:[asset fileName]];
     */
    
    
    /* 这个URL 每次访问的时候都在变，就是ALAssetGroup枚举的Asset的时候，这个每次都在变，
     * 所以不能用来判断已经选择过的图片和刚进入的选择列表的时候，这两张图片是否一样
     * UTI 取到的是public.jpeg, 每次都是一样的，不可以用
     * 用比较缩略图二进制的方法可以，判断是否一样，但是转成二进制再比较，效率很低，导致UI卡死
     * 所以暂时考虑用文件名字来判断是否同一张图片
     *
     * return [self theImage:[self thumbnail] isEqual:[asset thumbnail]];
     */
   

    /* 在同一个ALAssetsGroup实例 枚举出来的实例情况下是可以用来判断是否相等的 */
    return [self.url.absoluteString isEqualToString:asset.url.absoluteString];
}

- (BOOL)theImage:(UIImage*)theImage isEqual:(UIImage*)aImage
{
    NSData *data1 = UIImagePNGRepresentation(theImage);
    NSData *data2 = UIImagePNGRepresentation(aImage);
    
    return [data1 isEqual:data2];
}

- (UIImage*)aspectRatioThumbnail
{
    if (self.containtAsset) {
        return [UIImage imageWithCGImage:[self.containtAsset aspectRatioThumbnail]];
    }else{
        return nil;
    }
}

- (UIImage*)thumbnail
{
    if (self.containtAsset) {
        return [UIImage imageWithCGImage:[self.containtAsset thumbnail]];
    }else{
        return nil;
    }
}

- (CGSize)imageSize
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [representation dimensions];
    }else{
        return CGSizeZero;
    }
}

- (UIImage*)fullResolutionImage
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        /* ALAsset 这张高清图要用这个进行翻转的到才是正的图 */
        return [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1.0 orientation:(UIImageOrientation)[representation orientation]];
    }else{
        return nil;
    }
}

- (UIImage*)fullScreenImage
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [UIImage imageWithCGImage:[representation fullScreenImage]];
    }else{
        return nil;
    }
}

- (NSString*)fileName
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [representation filename];
    }else{
        return nil;
    }
}

- (long long)size
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [representation size];
    }else{
        return 0;
    }
}

- (CGFloat)scale
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [representation scale];
    }else{
        return 0.f;
    }
}

- (ALAssetOrientation)orientation
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [representation orientation];
    }else{
        return ALAssetOrientationUp;
    }
}

- (NSDictionary*)metaData
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [representation metadata];
    }else{
        return nil;
    }
}

- (BOOL)isHaveBeenEdit
{
    if (self.containtAsset) {
        
        CGFloat systemVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
        
        if (systemVersion >= 8.0 || systemVersion <= 5.0) {
            
            CGSize originalImageSize = CGSizeMake([self.containtAsset.defaultRepresentation.metadata[@"PixelWidth"] floatValue],
                                                  [self.containtAsset.defaultRepresentation.metadata[@"PixelHeight"] floatValue]);
            CGFloat originScale = originalImageSize.width/originalImageSize.height;
            originScale = [[NSString stringWithFormat:@"%.2f",originScale]floatValue];
            
            CGFloat fullScreenScale = self.fullScreenImage.size.width/self.fullScreenImage.size.height;
            fullScreenScale = [[NSString stringWithFormat:@"%.2f",fullScreenScale]floatValue];

            return originScale == fullScreenScale? NO:YES;
            
        }else{
            return [[self.containtAsset defaultRepresentation].metadata.allKeys containsObject:@"AdjustmentXMP"];
        }
        
    }else{
        return NO;
    }
    
}

/* 从图片裁剪信息中截取出图片 */
- (UIImage *)getCropImageFromRepresentation:(ALAssetRepresentation*)representation
{
    NSError *error;
    CGSize originalImageSize = CGSizeMake([representation.metadata[@"PixelWidth"] floatValue],
                                          [representation.metadata[@"PixelHeight"] floatValue]);
    NSData *xmpData = [representation.metadata[@"AdjustmentXMP"] dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!xmpData) {
        return nil;
    }
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    CIContext *context = [CIContext contextWithEAGLContext:myEAGLContext
                                                   options:@{ kCIContextWorkingColorSpace : [NSNull null] }];
    
    CGImageRef img = [representation fullResolutionImage];
    CIImage *image = [CIImage imageWithCGImage:img];
    NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
                                                 inputImageExtent:image.extent
                                                            error:&error];
    
    if (error) {
        return nil;
    }
    if ((originalImageSize.width != CGImageGetWidth(img))
        || (originalImageSize.height != CGImageGetHeight(img))) {
        
        CGFloat zoom = MIN(originalImageSize.width / CGImageGetWidth(img),
                           originalImageSize.height / CGImageGetHeight(img));
        
        BOOL translationFound = NO, cropFound = NO;
        for (CIFilter *filter in filterArray) {
            
            if ([filter.name isEqualToString:@"CIAffineTransform"] && !translationFound) {
                translationFound = YES;
                CGAffineTransform t = [[filter valueForKey:@"inputTransform"] CGAffineTransformValue];
                t.tx /= zoom;
                t.ty /= zoom;
                [filter setValue:[NSValue valueWithCGAffineTransform:t] forKey:@"inputTransform"];
            }
            
            if ([filter.name isEqualToString:@"CICrop"] && !cropFound) {
                cropFound = YES;
                CGRect r = [[filter valueForKey:@"inputRectangle"] CGRectValue];
                r.origin.x /= zoom;
                r.origin.y /= zoom;
                r.size.width /= zoom;
                r.size.height /= zoom;
                [filter setValue:[NSValue valueWithCGRect:r] forKey:@"inputRectangle"];
            }
        }
    }
    
    // filter chain
    for (CIFilter *filter in filterArray) {
        [filter setValue:image forKey:kCIInputImageKey];
        image = [filter outputImage];
    }
    
    // render
    CGImageRef editedImageRef = [context createCGImage:image fromRect:image.extent];
    
    UIImage *eidtImage = [UIImage imageWithCGImage:editedImageRef];
    // do something with editedImage
    CGImageRelease(editedImageRef);
    
    
    return eidtImage;
}

- (UIImage *)correctImageOrentation:(UIImage *)originImage
{
    // 正确的方向
    if (originImage.imageOrientation == UIImageOrientationUp){
        
        CGSize scaleSize = CGSizeMake(originImage.size.width, originImage.size.height);
        
        UIGraphicsBeginImageContext(scaleSize);
        
        // 绘制改变大小的图片
        [originImage drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
        
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return scaledImage;
    }
    
    // 错误的方向
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (originImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, originImage.size.width, originImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, originImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, originImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (originImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, originImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, originImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, originImage.size.width, originImage.size.height,
                                             CGImageGetBitsPerComponent(originImage.CGImage), 0,
                                             CGImageGetColorSpace(originImage.CGImage),
                                             CGImageGetBitmapInfo(originImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (originImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,originImage.size.height,originImage.size.width), originImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,originImage.size.width,originImage.size.height), originImage.CGImage);
            break;
    }
    
    // 创建一张新图
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);

    return img;
}

/* 被裁剪过的图片 */
- (UIImage *)editImage
{
    if (self.isHaveBeenEdit) {
        
        CGFloat currentIOSVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
        
        if (currentIOSVersion >= 8.0 || currentIOSVersion <= 5.0) {
            
            return self.fullScreenImage;
            
        }else{
            
            return [self getCropImageFromRepresentation:[self.containtAsset defaultRepresentation]]? [self getCropImageFromRepresentation:[self.containtAsset defaultRepresentation]]:self.fullScreenImage;
        }
    }
    return self.fullScreenImage;
}

- (NSURL*)url
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [representation url];
    }else{
        return nil;
    }
}

- (NSString*)uniqueIdentifier
{
    if (self.containtAsset) {
        ALAssetRepresentation *representation = [self.containtAsset defaultRepresentation];
        return [representation UTI];
    }else{
        return nil;
    }
}

@end
