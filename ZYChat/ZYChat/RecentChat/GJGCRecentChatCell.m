//
//  GJGCRecentChatCell.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCRecentChatCell.h"

@interface GJGCRecentChatCell ()

@property (nonatomic,strong)GJGCCommonHeadView *headView;

@property (nonatomic,strong)GJCFCoreTextContentView *nameLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *timeLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *contentLabel;

@end

@implementation GJGCRecentChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headView = [[GJGCCommonHeadView alloc]init];
        self.headView.gjcf_size = CGSizeMake(55, 55);
        self.headView.gjcf_left = 13.f;
        self.headView.gjcf_top = 10.f;
        self.headView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.headView];
        
        
        self.nameLabel = [[GJCFCoreTextContentView alloc]init];
        self.nameLabel.contentBaseWidth = GJCFSystemScreenWidth - self.headView.gjcf_width - 3*13.f - 40.f;
        self.nameLabel.contentBaseHeight = 10.f;
        [self.contentView addSubview:self.nameLabel];
        
        
        self.timeLabel = [[GJCFCoreTextContentView alloc]init];
        self.timeLabel.contentBaseWidth = 100.f;
        self.timeLabel.contentBaseHeight = 10.f;
        [self.contentView addSubview:self.timeLabel];
        
        self.contentLabel = [[GJCFCoreTextContentView alloc]init];
        self.contentLabel.contentBaseWidth = self.nameLabel.contentBaseWidth + 40.f;
        self.contentLabel.contentBaseHeight = 10.f;
        [self.contentView addSubview:self.contentLabel];
        
    }
    return self;
}

- (void)setContentModel:(GJGCRecentChatModel *)contentModel
{
    [self.headView setHeadUrl:contentModel.headUrl];
    
    CGSize nameSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:contentModel.name forBaseContentSize:self.nameLabel.contentBaseSize];
    self.nameLabel.gjcf_size = nameSize;
    self.nameLabel.gjcf_left = self.headView.gjcf_right + 13.f;
    self.nameLabel.gjcf_top = 16.f;
    self.nameLabel.contentAttributedString = contentModel.name;
    
    CGSize timeSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:contentModel.time forBaseContentSize:self.timeLabel.contentBaseSize];
    self.timeLabel.gjcf_size = timeSize;
    self.timeLabel.gjcf_right = GJCFSystemScreenWidth - 13.f;
    self.timeLabel.gjcf_top = self.nameLabel.gjcf_top;
    self.timeLabel.contentAttributedString = contentModel.time;
    
    CGSize contentSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:contentModel.content forBaseContentSize:self.contentLabel.contentBaseSize];
    self.contentLabel.gjcf_size = contentSize;
    self.contentLabel.gjcf_left = self.nameLabel.gjcf_left;
    self.contentLabel.gjcf_top = self.nameLabel.gjcf_bottom + 15.f;
    self.contentLabel.contentAttributedString = contentModel.content;
    
}

@end
