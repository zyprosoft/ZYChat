//
//  GJGCInfoGroupRoleContentCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCInfoGroupRoleContentCell.h"

@interface GJGCInfoGroupRoleContentCell ()

@property (nonatomic,strong)UILabel *groupLabels;

@property (nonatomic,strong)UILabel *addressLabel;

@end

@implementation GJGCInfoGroupRoleContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.groupLabels = [[UILabel alloc]init];
        self.groupLabels.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.groupLabels.textColor = [GJGCCommonFontColorStyle mainThemeColor];
        self.groupLabels.numberOfLines = 0;
        [self.contentView addSubview:self.groupLabels];
        
        self.addressLabel = [[UILabel alloc]init];
        self.addressLabel.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
        self.addressLabel.textColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
        [self.contentView addSubview:self.addressLabel];
    }
    return self;
}

- (void)setContentModel:(GJGCInfoBaseListContentModel *)contentModel
{
    [super setContentModel:contentModel];
}


@end
