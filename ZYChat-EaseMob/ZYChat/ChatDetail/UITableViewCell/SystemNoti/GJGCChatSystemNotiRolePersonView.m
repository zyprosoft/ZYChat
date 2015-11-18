//
//  GJGCChatSystemNotiRolePersonView.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatSystemNotiRolePersonView.h"

@interface GJGCChatSystemNotiRolePersonView ()

/**
 *  性别
 */
@property (nonatomic,strong)UIImageView *sexImageView;

/**
 *  年龄
 */
@property (nonatomic,strong)GJCFCoreTextContentView *ageLabel;

/**
 *  星座
 */
@property (nonatomic,strong)GJCFCoreTextContentView *starLabel;

/**
 *  内容间隔
 */
@property (nonatomic,assign)CGFloat contentInnerMargin;

@end

@implementation GJGCChatSystemNotiRolePersonView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initSubViews];
    }
    return self;
}

- (instancetype )initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViews];
    }
    return self;
}

#pragma mark - 内部接口

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.sex == 1) {
        
        self.sexImageView.image = GJCFQuickImage(@"男-icon");

    }else{
        
        self.sexImageView.image = GJCFQuickImage(@"女-icon");

    }
    
    self.sexImageView.gjcf_centerY = self.gjcf_height/2;
    
}

- (void)initSubViews
{
    self.sexImageView = [[UIImageView alloc]init];
    self.sexImageView.frame = (CGRect){0,0,15,15};
    self.sexImageView.gjcf_centerY = self.gjcf_centerY;
    [self addSubview:self.sexImageView];
    
    self.ageLabel = [[GJCFCoreTextContentView alloc]init];
    self.ageLabel.backgroundColor = [UIColor clearColor];
    self.ageLabel.gjcf_left = self.sexImageView.gjcf_right + 8.f;
    self.ageLabel.gjcf_top = 0;
    self.ageLabel.gjcf_width = 60;
    self.ageLabel.contentBaseWidth = self.ageLabel.gjcf_width;
    self.ageLabel.gjcf_height = 20;
    self.ageLabel.contentBaseHeight = self.gjcf_height;
    [self addSubview:self.ageLabel];
    
    self.starLabel = [[GJCFCoreTextContentView alloc]init];
    self.starLabel.gjcf_left = self.ageLabel.gjcf_right + 8.f;
    self.starLabel.backgroundColor = [UIColor clearColor];
    self.starLabel.gjcf_top = 0;
    self.starLabel.gjcf_width = 60;
    self.starLabel.gjcf_height = 20;
    self.starLabel.contentBaseWidth = self.starLabel.gjcf_width;
    self.starLabel.contentBaseHeight = self.starLabel.gjcf_height;
    [self addSubview:self.starLabel];
    
}

#pragma mark - 公开接口

- (void)setSex:(NSInteger )sex
{    
    if (_sex == sex) {
        return;
    }
    _sex = sex;
    
    [self setNeedsLayout];
}

- (void)setAge:(NSAttributedString *)age
{
    if ([self.ageLabel.contentAttributedString isEqualToAttributedString:age]) {
        return;
    }
    
    self.ageLabel.contentAttributedString = age;
    self.ageLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:age forBaseContentSize:self.ageLabel.contentBaseSize];

    self.starLabel.gjcf_left = self.ageLabel.gjcf_right + 8.f;
    self.gjcf_width = self.sexImageView.gjcf_width + 2*8 + self.starLabel.gjcf_width + self.ageLabel.gjcf_width;
    [self setNeedsLayout];
}

- (void)setStarName:(NSAttributedString *)starName
{
    if ([self.starLabel.contentAttributedString isEqualToAttributedString:starName]) {
        return;
    }
    
    self.starLabel.contentAttributedString = starName;
    self.starLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:starName forBaseContentSize:self.starLabel.contentBaseSize];

    self.gjcf_height = self.starLabel.gjcf_height;
    self.gjcf_width = self.sexImageView.gjcf_width + 2*8 + self.starLabel.gjcf_width + self.ageLabel.gjcf_width;
    [self setNeedsLayout];
}

@end
