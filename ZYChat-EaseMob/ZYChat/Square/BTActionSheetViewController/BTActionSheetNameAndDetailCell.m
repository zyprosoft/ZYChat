//
//  BTActionSheetNameAndDetailCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetNameAndDetailCell.h"
@interface BTActionSheetNameAndDetailCell ()

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *detailLabel;

@end

@implementation BTActionSheetNameAndDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        self.nameLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        [self.contentView addSubview:self.nameLabel];
        
        self.detailLabel = [[UILabel alloc]init];
        self.detailLabel.textColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
        self.detailLabel.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.gjcf_width = GJCFSystemScreenWidth - 2*13.f;
        [self.contentView addSubview:self.detailLabel];
        
    }
    return self;
}

- (void)setContentModel:(BTActionSheetBaseContentModel *)contentModel
{
    self.nameLabel.text = contentModel.simpleText;
    [self.nameLabel sizeToFit];
    self.nameLabel.gjcf_top = 5.f;
    self.nameLabel.gjcf_left = 13.f;
    
    self.detailLabel.gjcf_width = GJCFSystemScreenWidth - 2*13.f;
    self.detailLabel.text = contentModel.detailText;
    [self.detailLabel sizeToFit];
    self.detailLabel.gjcf_top = self.nameLabel.gjcf_bottom + 3.f;
    self.detailLabel.gjcf_left = self.nameLabel.gjcf_left;
    
    self.bottomLine.gjcf_bottom = self.detailLabel.gjcf_bottom + 5.f;
}

@end
