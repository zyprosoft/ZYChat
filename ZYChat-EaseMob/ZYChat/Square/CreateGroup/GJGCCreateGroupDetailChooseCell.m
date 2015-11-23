//
//  BTUploadMemberSingleChooseCell.m
//  ZYChat
//
//  Created by ZYVincent on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCCreateGroupDetailChooseCell.h"

@interface GJGCCreateGroupDetailChooseCell ()

@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic,strong)UIImageView *headView;

@end

@implementation GJGCCreateGroupDetailChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        self.contentLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        self.headView = [[UIImageView alloc]init];
        self.headView.gjcf_size = (CGSize){36,36};
        [self.contentView addSubview:self.headView];
        
    }
    return self;
}

- (void)setContentModel:(GJGCCreateGroupContentModel *)contentModel
{
    [super setContentModel:contentModel];
    
    self.contentLabel.gjcf_width = GJCFSystemScreenWidth - self.seprateLine.gjcf_right - 8.f - 13.f - 10.f;
    if (GJCFStringIsNull(contentModel.content)) {
        self.contentLabel.text = contentModel.placeHolder;
    }else{
        self.contentLabel.text = contentModel.content;
    }
    [self.contentLabel sizeToFit];
    self.contentLabel.gjcf_right = self.arrowImageView.gjcf_left - 5.f;
    if (contentModel.isMutilContent) {
        self.contentLabel.gjcf_top = 6.f;
    }else{
        self.contentLabel.gjcf_centerY = self.tagLabel.gjcf_centerY;
    }
    
    if (contentModel.contentType == GJGCCreateGroupContentTypeHeadThumb) {
        
        self.contentLabel.hidden = YES;
        self.contentLabel.text = @"";
        self.headView.hidden = NO;
        self.headView.gjcf_right = self.arrowImageView.gjcf_left - 10.f;
        self.headView.gjcf_centerY = self.arrowImageView.gjcf_centerY;
        [self.headView sd_setImageWithURL:[NSURL URLWithString:contentModel.content]];
        
    }else{
        
        self.headView.hidden = YES;
        self.contentLabel.hidden = NO;
    }
    
    if (contentModel.isMutilContent) {
        
        CGFloat minHeight = self.contentLabel.gjcf_bottom + 6.f;
        
        if (self.contentLabel.gjcf_bottom + 6.f < 40.f) {
            
            minHeight = 40.f;
            
            self.contentLabel.gjcf_centerY = minHeight/2;
            
            self.tagLabel.gjcf_centerY = self.contentLabel.gjcf_centerY;
            self.seprateLine.gjcf_centerY = self.tagLabel.gjcf_centerY;
        }
        
        self.bottomLine.gjcf_bottom = minHeight;
    }
}

@end
