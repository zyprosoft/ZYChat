//
//  BTUploadMemberBaseCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCCreateGroupBaseCell.h"

@interface GJGCCreateGroupBaseCell ()

@property (nonatomic,strong)UIImageView *topLine;

@end

@implementation GJGCCreateGroupBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.tagLabel = [[UILabel alloc]init];
        self.tagLabel.backgroundColor = [UIColor clearColor];
        self.tagLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.tagLabel.textColor = GJCFQuickHexColor(@"777d7f");
        [self.contentView addSubview:self.tagLabel];
        
        self.arrowImageView = [[UIImageView alloc]init];
        self.arrowImageView.gjcf_size = CGSizeMake(8, 8);
        self.arrowImageView.image = [UIImage imageNamed:@"right"];
        [self.contentView addSubview:self.arrowImageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.topLine = [[UIImageView alloc]init];
        self.topLine.gjcf_width = GJCFSystemScreenWidth;
        self.topLine.gjcf_height = 0.5f;
        self.topLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.contentView addSubview:self.topLine];
        
        self.bottomLine = [[UIImageView alloc]init];
        self.bottomLine.gjcf_width = GJCFSystemScreenWidth;
        self.bottomLine.gjcf_height = 0.5f;
        self.bottomLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.contentView addSubview:self.bottomLine];
        
        self.seprateLine = [[UIImageView alloc]init];
        self.seprateLine.gjcf_width = 0.5f;
        self.seprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.contentView addSubview:self.seprateLine];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.contentView.backgroundColor = [GJGCCommonFontColorStyle tapHighlightColor];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setContentModel:(GJGCCreateGroupContentModel *)contentModel
{
    self.tagLabel.text = contentModel.tagName;
    [self.tagLabel sizeToFit];
    self.tagLabel.gjcf_left = 13.f;
    self.tagLabel.gjcf_centerY = contentModel.contentHeight/2;
    self.seprateLine.gjcf_left = 70 + 6.f;
    
    [self setSeprateStyle:contentModel.seprateStyle];
    if (contentModel.contentHeight > 0) {
        self.bottomLine.gjcf_bottom = contentModel.contentHeight;
    }
    
    if (contentModel.isMutilContent) {
        self.tagLabel.gjcf_top = 8.f;
    }
    
    self.seprateLine.gjcf_height = self.tagLabel.gjcf_height;
    self.seprateLine.gjcf_centerY = self.tagLabel.gjcf_centerY;
    
    if (contentModel.isShowDetailIndicator) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.arrowImageView.hidden = NO;
        self.arrowImageView.gjcf_right = GJCFSystemScreenWidth - 13.f;
        self.arrowImageView.gjcf_centerY = contentModel.contentHeight/2;
        
    }else{
        self.arrowImageView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)setSeprateStyle:(GJGCCreateGroupCellSeprateLineStyle)seprateStyle
{
    switch (seprateStyle) {
        case GJGCCreateGroupCellSeprateLineStyleTopNoneBottomNone:
        {
            self.topLine.hidden = YES;
            self.bottomLine.hidden = YES;
        }
            break;
        case GJGCCreateGroupCellSeprateLineStyleTopNoneBottomShow:
        {
            self.topLine.hidden = YES;
            self.bottomLine.hidden = NO;
        }
            break;
        case GJGCCreateGroupCellSeprateLineStyleTopShowBottomNone:
        {
            self.topLine.hidden = NO;
            self.bottomLine.hidden = YES;
        }
            break;
        case GJGCCreateGroupCellSeprateLineStyleTopShowBottomShow:
        {
            self.topLine.hidden = NO;
            self.bottomLine.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (CGFloat)cellHeight
{
    return self.bottomLine.gjcf_bottom;
}

- (void)resignInputFirstResponse
{
    
}

@end
