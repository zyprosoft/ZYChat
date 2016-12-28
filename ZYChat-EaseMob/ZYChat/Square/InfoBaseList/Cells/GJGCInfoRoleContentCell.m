//
//  GJGCInfoRoleContentCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCInfoRoleContentCell.h"

@interface GJGCInfoRoleContentCell ()


@end

@implementation GJGCInfoRoleContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headView = [[GJGCCommonHeadView alloc]init];
        self.headView.gjcf_size = CGSizeMake(55, 55);
        self.headView.gjcf_left = 13.f;
        self.headView.gjcf_top = 10.f;
        self.headView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.headView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        self.titleLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColorWhite];
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColorWhite];
        self.timeLabel.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
        [self.contentView addSubview:self.timeLabel];
        
        self.descLabel = [[UILabel alloc]init];
        self.descLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.descLabel.textColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColorWhite];
        [self.contentView addSubview:self.descLabel];
        
    }
    return self;
}

- (void)setContentModel:(GJGCInfoBaseListContentModel *)contentModel
{
    self.titleLabel.text = contentModel.title;
    [self.titleLabel sizeToFit];
    self.titleLabel.gjcf_top = self.headView.gjcf_top + 6.f;
    self.titleLabel.gjcf_left = self.headView.gjcf_right + 6.f;
    
    self.descLabel.text = contentModel.summary;
    [self.descLabel sizeToFit];
    self.descLabel.gjcf_width = GJCFSystemScreenWidth - 10.f - self.headView.gjcf_right - 6.f;
    self.descLabel.gjcf_left = self.titleLabel.gjcf_left;
    self.descLabel.gjcf_top = self.titleLabel.gjcf_bottom + 5.f;
    
    self.timeLabel.text = contentModel.time;
    [self.timeLabel sizeToFit];
    self.timeLabel.gjcf_centerY = self.titleLabel.gjcf_centerY;
    self.timeLabel.gjcf_right = GJCFSystemScreenWidth - 10.f;
    self.titleLabel.gjcf_width = self.timeLabel.gjcf_left - 5.f - self.headView.gjcf_right - 5.f;

    self.bottomLine.gjcf_bottom = self.headView.gjcf_bottom + self.headView.gjcf_top;
}

- (void)downloadImageWithContentModel:(GJGCInfoBaseListContentModel *)contentModel
{
    [self.headView setHeadUrl:contentModel.headUrl];
}


@end
