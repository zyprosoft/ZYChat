//
//  GJGCChatFriendGifCell.m
//  ZYChat
//
//  Created by ZYVincent on 15/6/3.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendGifCell.h"
#import "GJGCGIFLoadManager.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface GJGCChatFriendGifCell ()

@property (nonatomic,strong)GJCUProgressView *progressView;

@property (nonatomic,strong)FLAnimatedImageView *gifImgView;

@property (nonatomic,strong)NSString *gifLocalId;

@end

@implementation GJGCChatFriendGifCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.gifImgView = [[FLAnimatedImageView alloc]init];
        self.gifImgView.gjcf_size = (CGSize){120,120};
        [self.bubbleBackImageView addSubview:self.gifImgView];
        
        self.progressView = [[GJCUProgressView alloc]init];
        self.progressView.frame = self.gifImgView.bounds;
        self.progressView.hidden = YES;
        [self.gifImgView addSubview:self.progressView];
        
    }
    return self;
}

- (void)goToShowLongPressMenu:(UILongPressGestureRecognizer *)sender
{
    [super goToShowLongPressMenu:sender];

    if (sender.state == UIGestureRecognizerStateBegan) {
        //
        [self becomeFirstResponder];
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
        NSArray *menuItems = @[item1];
        [popMenu setMenuItems:menuItems];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        
        [popMenu setTargetRect:self.bubbleBackImageView.frame inView:self];
        [popMenu setMenuVisible:YES animated:YES];
        
    }
}


- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    [super setContentModel:contentModel];
    
    /* 重设气泡 */
    self.bubbleBackImageView.gjcf_height = self.gifImgView.gjcf_height;
    self.bubbleBackImageView.gjcf_width = self.gifImgView.gjcf_width;
    self.progressView.progress = 0.f;
    self.progressView.hidden = YES;
    
    GJGCChatFriendContentModel *chatContentModel = (GJGCChatFriendContentModel *)contentModel;
    
    self.gifLocalId = chatContentModel.gifLocalId;
    self.gifImgView.animatedImage = nil;
    
    [self setGifImageContent];

    [self adjustContent];
    
    self.bubbleBackImageView.image = nil;
    self.bubbleBackImageView.highlightedImage = nil;
}

- (void)setGifImageContent
{
    NSData *gifData = [GJGCGIFLoadManager getCachedGifDataById:self.gifLocalId];
    
    if (gifData) {
        
        FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
        
        self.gifImgView.animatedImage = gifImage;
        
    }else{
        
        self.gifImgView.image = [UIImage imageNamed:@"大表情-gif占位图"];
    }
}

- (void)pause
{
    if (self.gifImgView.isAnimating) {
        
        [self.gifImgView stopAnimating];
        
    }
}

- (void)resume
{
    if (!self.gifImgView.isAnimating) {
        
        [self.gifImgView startAnimating];
        
    }
}

- (void)setDownloadProgress:(CGFloat)downloadProgress
{
    if (_downloadProgress == downloadProgress) {
        return;
    }
    self.progressView.hidden = NO;
    _downloadProgress = downloadProgress;
    self.progressView.progress = downloadProgress;
}

- (void)successDownloadGifFile:(NSData *)fileData
{
    self.progressView.hidden = YES;

    if (!fileData) {
        return;
    }
    
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:fileData];
    
    self.gifImgView.animatedImage = gifImage;
}

- (void)faildDownloadGifFile
{
    self.progressView.progress = 0.f;
    self.progressView.hidden = YES;
}

@end
