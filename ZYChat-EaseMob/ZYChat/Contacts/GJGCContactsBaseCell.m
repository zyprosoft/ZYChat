//
//  GJGCContactsCell.m
//  ZYChat
//
//  Created by ZYVincent on 16/8/8.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCContactsBaseCell.h"

@interface GJGCContactsBaseCell ()


@end

@implementation GJGCContactsBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];

        self.bottomLine = [[UIImageView alloc]init];
        self.bottomLine.gjcf_height = 0.5f;
        self.bottomLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        self.bottomLine.gjcf_width = GJCFSystemScreenWidth - 15.f;
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}


- (void)setContentModel:(GJGCContactsContentModel *)contentModel
{
    self.bottomLine.gjcf_left = 15.f;
}

- (CGFloat)cellHeight
{
    return self.bottomLine.gjcf_bottom;
}

- (void)downloadImageWithConententModel:(GJGCContactsContentModel *)contentModel
{
    
}

@end
