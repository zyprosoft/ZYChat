//
//  GJGCContactsUserCell.m
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCContactsUserCell.h"

@interface GJGCContactsUserCell ()

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *descpLabel;

@property (nonatomic,strong)UIImageView *headView;

@end

@implementation GJGCContactsUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headView = [[UIImageView alloc]init];
        self.headView.frame = CGRectMake(13, 7, 30, 30);
        [self.contentView addSubview:self.headView];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.frame = CGRectMake(50, 7, 100, 25);
        self.nameLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColorWhite];
        self.nameLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        [self.contentView addSubview:self.nameLabel];
        
        self.descpLabel = [[UILabel alloc]init];
        self.descpLabel.frame = CGRectMake(50, 7, 100, 25);
        self.descpLabel.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
        self.descpLabel.textColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColorWhite];
        [self.contentView addSubview:self.descpLabel];
        
    }
    return self;
}

- (void)setContentModel:(GJGCContactsContentModel *)contentModel
{
    self.headView.gjcf_top = 8.f;
    self.headView.gjcf_height = 48.f;
    self.headView.gjcf_width = self.headView.gjcf_height;
    self.bottomLine.gjcf_top = self.headView.gjcf_bottom + 8.f;
    self.bottomLine.gjcf_left = self.headView.gjcf_left;
    self.nameLabel.gjcf_width = GJCFSystemScreenWidth - self.headView.gjcf_right - 8.f - 15.f;
    self.nameLabel.text = contentModel.nickname;
    self.nameLabel.gjcf_left = self.headView.gjcf_right + 8.f;
    self.descpLabel.frame = self.nameLabel.frame;
    self.descpLabel.gjcf_top = self.nameLabel.gjcf_bottom + 4.f;
    self.descpLabel.text = contentModel.summary;
    self.bottomLine.gjcf_left = self.descpLabel.gjcf_left;
}

- (void)downloadImageWithConententModel:(GJGCContactsContentModel *)contentModel
{
    [self.headView sd_setImageWithURL:[NSURL URLWithString:contentModel.headThumb]];
}

@end
