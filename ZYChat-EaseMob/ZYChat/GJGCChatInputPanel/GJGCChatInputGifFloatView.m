//
//  GJGCChatInputGifFloatView.m
//  ZYChat
//
//  Created by ZYVincent on 15/6/3.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatInputGifFloatView.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface GJGCChatInputGifFloatView ()

@property (nonatomic,strong)UIImageView *bubbleBackView;

@property (nonatomic,strong)FLAnimatedImageView *gifImgView;

@end

@implementation GJGCChatInputGifFloatView

- (instancetype)initWithPosition:(GJGCChatInputGifFloatViewPosition)position withGifName:(NSString *)gifName
{
    if (self = [super init]) {
        
        self.gjcf_size = (CGSize){124,130};
        
        self.bubbleBackView = [[UIImageView alloc]init];
        self.bubbleBackView.gjcf_size = self.gjcf_size;
        [self addSubview:self.bubbleBackView];
        self.bubbleBackView.image = [self bubbleImageWithPosition:position];
        
        self.gifImgView = [[FLAnimatedImageView alloc]init];
        self.gifImgView.gjcf_size = (CGSize){100,100};
        self.gifImgView.gjcf_centerX = self.gjcf_width/2;
        self.gifImgView.gjcf_centerY = (self.gjcf_height - 10)/2;
        [self addSubview:self.gifImgView];
        
        NSString *gifFilePath = GJCFMainBundlePath(gifName);
        NSData *gifData = [NSData dataWithContentsOfFile:gifFilePath];
        
        FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
        self.gifImgView.animatedImage = gifImage;
        
    }
    return self;
}

- (void)showWithPosition:(GJGCChatInputGifFloatViewPosition)position withGifName:(NSString *)gifName
{
    self.bubbleBackView.image = [self bubbleImageWithPosition:position];

    NSString *gifFilePath = GJCFMainBundlePath(gifName);
    NSData *gifData = [NSData dataWithContentsOfFile:gifFilePath];
    
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    self.gifImgView.animatedImage = gifImage;

}

- (UIImage *)bubbleImageWithPosition:(GJGCChatInputGifFloatViewPosition)position
{
    UIImage *originImage = [UIImage imageNamed:@"大表情-bg-预览"];
    CGSize imageSize = originImage.size;
    
    CGFloat top = 10;
    CGFloat bottom = 24;
    
    CGFloat left = 0.f;
    CGFloat right = 0.f;
    
    switch (position) {
        case GJGCChatInputGifFloatViewPositionLeft:
        {
            left = 35.f;
            right = 15.f;

        }
            break;
        case GJGCChatInputGifFloatViewPositionCenter:
        {
            originImage = [UIImage imageNamed:@"大表情-bg-预览-居中"];
            left = 70.f;
            right = 15.f;
        }
            break;
        case GJGCChatInputGifFloatViewPositionRight:
        {
            left = 15.f;
            right = 35.f;
        }
            break;
        default:
            break;
    }
    
    return GJCFImageResize(originImage, top, bottom, left, right);
}

@end
