//
//  GJGCCommonHeadView.m
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCCommonHeadView.h"

@interface GJGCCommonHeadView ()

@property (nonatomic,strong)GJCUAsyncImageView *contentImageView;

@end

@implementation GJGCCommonHeadView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentImageView.frame = self.bounds;
    self.contentImageView.layer.cornerRadius = self.bounds.size.width/2;
    self.contentImageView.layer.masksToBounds = YES;
}

- (void)initSubViews
{
    self.backgroundColor = [UIColor clearColor];
    self.contentImageView = [[GJCUAsyncImageView alloc]initWithFrame:self.bounds];
    self.contentImageView.image = GJCFQuickImage(@"好友头像占位-bg-列表.png");
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.clipsToBounds = YES;
    
    GJCFWeakSelf weakSelf = self;
    [self.contentImageView configDownloadTaskCompletionBlock:^(GJCUAsyncImageView *imageView, BOOL completion) {
        if (completion) {
            [weakSelf completionTask:completion withImage:imageView.image];
        }
    }];
    [self addSubview:self.contentImageView];
}

- (void)setHeadUrl:(NSString *)url {
    [self setHeadUrl:url headViewType:GJGCCommonHeadViewTypeContact];
}

- (void)setHeadUrl:(NSString *)url headViewType:(GJGCCommonHeadViewType)headViewType
{
    switch (headViewType) {
        case GJGCCommonHeadViewTypePGGroup: {
            [self.contentImageView setImage:GJCFQuickImage(@"群组头像占位-bg-3行列表")];
            break;
        }
        case GJGCCommonHeadViewTypeContact: {
            [self.contentImageView setImage:GJCFQuickImage(@"好友头像占位-bg-列表")];
            break;
        }
        case GJGCCommonHeadViewTypePostContact: {
            [self.contentImageView setImage:GJCFQuickImage(@"IM头像")];
            break;
        }
        default:
            break;
    }
    
    [self.contentImageView setUrl:url];
}

- (void)setHeadImage:(UIImage *)image
{
    [self.contentImageView setImage:image];
}

- (void)setHiddenImageView:(BOOL)hidden
{
    self.contentImageView.hidden = hidden;
}

- (void)completionTask:(BOOL)completion  withImage:(UIImage *)image
{
    self.contentImageView.image = image;
}

@end
