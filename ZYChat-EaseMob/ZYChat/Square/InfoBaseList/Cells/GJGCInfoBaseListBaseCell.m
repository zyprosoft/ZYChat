//
//  GJGCInfoBaseListBaseCell.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCInfoBaseListBaseCell.h"

@interface GJGCInfoBaseListBaseCell ()


@end

@implementation GJGCInfoBaseListBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithRed:97/255.f green:60/255.f blue:140/255.f alpha:0.6];

        self.bottomLine = [[UIImageView alloc]init];
        self.bottomLine.gjcf_width = GJCFSystemScreenWidth;
        self.bottomLine.gjcf_height = 0.5f;
        self.bottomLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (void)setContentModel:(GJGCInfoBaseListContentModel *)contentModel
{
    
}

- (void)downloadImageWithContentModel:(GJGCInfoBaseListContentModel *)contentModel
{
    
}

- (CGFloat)cellHeight
{
    return self.bottomLine.gjcf_bottom;
}

@end
