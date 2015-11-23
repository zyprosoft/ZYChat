//
//  HAPersonProfileHeadInfoCell.m
//  HelloAsk
//
//  Created by ZYVincent QQ:1003081775 on 15-9-3.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "HAPersonProfileHeadInfoCell.h"
#import "GJGCInformationCellContentModel.h"

@interface HAPersonProfileHeadInfoCell ()

@property (nonatomic,strong)GJCUAsyncImageView *backgroundImageView;

@property (nonatomic,strong)GJCUAsyncImageView *headView;

@property (nonatomic,strong)UIImageView *headBackView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *lastTimeLabel;

@property (nonatomic,assign)CGFloat contentMargin;

@end

@implementation HAPersonProfileHeadInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headView = [[GJCUAsyncImageView alloc]init];
        self.headView.gjcf_size = CGSizeMake(66, 66);
        self.headView.gjcf_centerX = GJCFSystemScreenWidth/2;
        self.headView.layer.cornerRadius = self.headView.gjcf_width/2;
        self.headView.layer.masksToBounds = YES;
        self.headView.layer.borderColor = [GJGCCommonFontColorStyle mainThemeColor].CGColor;
        self.headView.layer.borderWidth = 1.f;
        self.headView.contentMode = UIViewContentModeScaleAspectFit;
        [self.baseContentView addSubview:self.headView];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.nameLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        [self.baseContentView addSubview:self.nameLabel];
        
    }
    return self;
}

- (void)setContentInformationModel:(GJGCInformationBaseModel *)contentModel
{
    [super setContentInformationModel:contentModel];
    
    GJGCInformationCellContentModel *informationModel = (GJGCInformationCellContentModel *)contentModel;
    
    self.headView.gjcf_top = 10.f;
    self.headView.gjcf_left = 13.f;
    [self.headView setUrl:informationModel.groupHeadUrl];
    
    self.nameLabel.text = informationModel.groupName;
    [self.nameLabel sizeToFit];
    self.nameLabel.gjcf_left = self.headView.gjcf_right + 8.f;
    self.nameLabel.gjcf_centerY = self.headView.gjcf_centerY;
    
    self.baseContentView.gjcf_height = self.headView.gjcf_bottom + 10.f;
    
    self.topSeprateLine.gjcf_top = contentModel.topLineMargin;
    self.baseContentView.gjcf_top = self.topSeprateLine.gjcf_bottom-0.5;
    self.baseSeprateLine.gjcf_bottom = self.baseContentView.gjcf_bottom;
}

@end
