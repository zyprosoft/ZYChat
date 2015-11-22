//
//  BTActionSheetSimpleTextCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetSimpleTextCell.h"

@interface BTActionSheetSimpleTextCell ()

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIButton *mutilSelectedButton;

@end

@implementation BTActionSheetSimpleTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        self.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        [self.contentView addSubview:self.titleLabel];
        
        self.mutilSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mutilSelectedButton.gjcf_size = CGSizeMake(35, 35);
        self.mutilSelectedButton.userInteractionEnabled = NO;
        [self.mutilSelectedButton setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateSelected];
        [self.mutilSelectedButton setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.mutilSelectedButton];
        
        self.mutilSelectedButton.gjcf_right = GJCFSystemScreenWidth - 8.f;
    }
    return self;
}

- (void)setContentModel:(BTActionSheetBaseContentModel *)contentModel
{
    
    if (contentModel.contentHeight > 0) {
        
        self.titleLabel.text = contentModel.simpleText;
        [self.titleLabel sizeToFit];
        self.titleLabel.gjcf_centerY = contentModel.contentHeight/2;
        self.titleLabel.gjcf_left = 13.f;
        
        
        self.bottomLine.gjcf_bottom = contentModel.contentHeight;
        
    }else{
        
        self.titleLabel.text = contentModel.simpleText;
        [self.titleLabel sizeToFit];
        self.titleLabel.gjcf_top = 5.f;
        self.titleLabel.gjcf_left = 13.f;

        self.bottomLine.gjcf_top = self.titleLabel.gjcf_bottom + 5.f;
    }
    
    self.mutilSelectedButton.gjcf_centerY = self.titleLabel.gjcf_centerY;
    if (contentModel.isMutilSelect) {
        self.mutilSelectedButton.hidden = NO;
        self.mutilSelectedButton.selected = contentModel.selected;
        if (contentModel.disableMutilSelectUserInteract) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }else{
        self.mutilSelectedButton.hidden = YES;
    }
}

@end
