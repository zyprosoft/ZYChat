//
//  GJGCInformationLevelCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationLevelCell.h"

@implementation GJGCInformationLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.levelView = [[GJGCLevelView alloc]init];
        self.levelView.gjcf_left = self.tagLabel.gjcf_right + self.contentMargin;
        self.levelView.gjcf_top = self.topBordMargin;
        self.levelView.gjcf_width = 30;
        self.levelView.gjcf_height = 20;
        [self.baseContentView addSubview:self.levelView];
        
    }
    return self;
}

- (void)setContentInformationModel:(GJGCInformationBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    [super setContentInformationModel:contentModel];
    
    GJGCInformationCellContentModel *informationModel = (GJGCInformationCellContentModel *)contentModel;

    self.contentLabel.hidden = YES;
    
    if (informationModel.seprateStyle == GJGCInformationSeprateLineStyleTopFullBottomFull || informationModel.seprateStyle == GJGCInformationSeprateLineStyleTopNoneBottomFull) {
        self.tagLabel.gjcf_left = 16.f;
    }else{
        self.tagLabel.gjcf_left = self.baseSeprateLine.gjcf_left;
    }
    self.tagLabel.contentAttributedString = informationModel.tag;
    self.tagLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:informationModel.tag forBaseContentSize:self.tagLabel.contentBaseSize];
    
    self.levelView.level = informationModel.level;
    self.levelView.gjcf_left = self.tagLabel.gjcf_right + self.contentMargin;
    
    self.baseContentView.gjcf_height = self.tagLabel.gjcf_bottom + self.contentMargin;
    self.levelView.gjcf_centerY = self.baseContentView.gjcf_height/2;

    self.topSeprateLine.gjcf_top = informationModel.topLineMargin;
    self.baseContentView.gjcf_top = self.topSeprateLine.gjcf_bottom-0.5;
    self.baseSeprateLine.gjcf_bottom = self.baseContentView.gjcf_bottom;
}

@end
