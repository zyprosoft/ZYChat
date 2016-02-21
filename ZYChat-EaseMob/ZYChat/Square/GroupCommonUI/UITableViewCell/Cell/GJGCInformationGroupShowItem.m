//
//  GJGCGroupShowItem.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationGroupShowItem.h"

@implementation GJGCInformationGroupShowItemModel



@end

@implementation GJGCInformationGroupShowItem

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
    
    self.seprateLine.gjcf_width = self.gjcf_width;
    self.seprateLine.gjcf_bottom = self.gjcf_height;
    self.seprateLine.hidden = !self.showBottomSeprateLine;
    
}

#pragma mark  - 内部接口

- (void)initSubViews
{
    self.headView = [[GJGCCommonHeadView alloc]init];
    self.headView.gjcf_left = 0;
    self.headView.gjcf_top = 7;
    self.headView.gjcf_width = 32;
    self.headView.gjcf_height = 32;
    [self addSubview:self.headView];
    
    self.nameLabel = [[GJCFCoreTextContentView alloc]init];
    self.nameLabel.gjcf_top = 0;
    self.nameLabel.gjcf_left = self.headView.gjcf_right + 8;
    self.nameLabel.gjcf_width = GJCFSystemScreenWidth - 2*13 - 16 - 64;
    self.nameLabel.gjcf_height = 20;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.contentBaseWidth = self.nameLabel.gjcf_width;
    self.nameLabel.contentBaseHeight = self.nameLabel.gjcf_height;
    [self addSubview:self.nameLabel];
    
    self.seprateLine = [[UIImageView alloc]init];
    self.seprateLine.gjcf_height = 0.5;
    self.seprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
    [self addSubview:self.seprateLine];
}

- (void)setGroupItem:(GJGCInformationGroupShowItemModel *)contentModel
{
    [self.headView setHeadUrl:contentModel.headUrl headViewType:GJGCCommonHeadViewTypeContact];
    
    self.nameLabel.contentAttributedString = contentModel.name;
    self.nameLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:contentModel.name forBaseContentSize:self.nameLabel.contentBaseSize];
    self.nameLabel.gjcf_centerY = self.gjcf_height/2;
    
}

@end
