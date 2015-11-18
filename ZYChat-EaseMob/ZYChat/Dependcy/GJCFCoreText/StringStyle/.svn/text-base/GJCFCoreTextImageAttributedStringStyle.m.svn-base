//
//  GJCFCoreTextImageAttributedString.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-23.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import "GJCFCoreTextImageAttributedStringStyle.h"
#import <CoreText/CoreText.h>

@implementation GJCFCoreTextImageAttributedStringStyle

static void RunDelegateDeallocCallback( void* refCon ){
    
}

static CGFloat RunDelegateGetAscentCallback( void *refCon ){
    
    NSString *imageName = (__bridge NSString *)refCon;

    UIImage *image = [UIImage imageNamed:imageName];

    return image.size.height - RunDelegateGetDescentCallback(refCon);
}

static CGFloat RunDelegateGetDescentCallback(void *refCon){
    
    return 3;
}

static CGFloat RunDelegateGetWidthCallback(void *refCon){
    
    NSString *imageName = (__bridge NSString *)refCon;

    UIImage *image = [UIImage imageNamed:imageName];
    
    return image.size.width + 2.f;
}

- (CTRunDelegateCallbacks)callbacks
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = RunDelegateDeallocCallback;
    callbacks.getAscent = RunDelegateGetAscentCallback;
    callbacks.getDescent = RunDelegateGetDescentCallback;
    callbacks.getWidth = RunDelegateGetWidthCallback;
    
    return callbacks;
}

- (NSAttributedString *)imageAttributedString
{
    if (!self.imageName || !self.imageTag) {
        return nil;
    }
    
    CTRunDelegateCallbacks rCallBacks = self.callbacks;
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&rCallBacks, (__bridge void *)self.imageName);
    
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"\uFFFC"];//这个占位才能让它正确换行
    
    [imageAttributedString addAttributes:@{(id)kCTRunDelegateAttributeName:(__bridge id)runDelegate} range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    
    [imageAttributedString addAttribute:self.imageTag value:self.imageName range:NSMakeRange(0, 1)];    

    return imageAttributedString;
    
}

@end
