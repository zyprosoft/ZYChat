//
//  BTActionSheetBaseCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetBaseCell.h"

@interface BTActionSheetBaseCell ()


@end

@implementation BTActionSheetBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bottomLine = [[UIImageView alloc]init];
        self.bottomLine.gjcf_width = GJCFSystemScreenWidth;
        self.bottomLine.gjcf_height = 0.5f;
        self.bottomLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (void)setContentModel:(BTActionSheetBaseContentModel *)contentModel
{
    
}

- (CGFloat)cellHeight
{
    return self.bottomLine.gjcf_bottom;
}

@end
