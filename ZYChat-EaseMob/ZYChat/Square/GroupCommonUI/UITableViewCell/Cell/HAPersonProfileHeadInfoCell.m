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
        
        self.backgroundImageView = [[GJCUAsyncImageView alloc]init];
        self.backgroundImageView.gjcf_width = GJCFSystemScreenWidth;
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.backgroundImageView];
        
        self.headBackView = [[UIImageView alloc]init];
        self.headBackView.gjcf_size = CGSizeMake(90, 90);
        self.headBackView.backgroundColor = [UIColor whiteColor];
//        [self.baseContentView addSubview:self.headBackView];
        
        self.headView = [[GJCUAsyncImageView alloc]init];
        self.headView.gjcf_size = CGSizeMake(45, 45);
        self.headView.gjcf_centerX = GJCFSystemScreenWidth/2;
        self.headView.layer.cornerRadius = self.headView.gjcf_width/2;
        self.headView.layer.masksToBounds = YES;
        self.headView.layer.borderColor = [UIColor redColor].CGColor;
        self.headView.layer.borderWidth = 1.f;
        [self.baseContentView addSubview:self.headView];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.nameLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        [self.baseContentView addSubview:self.nameLabel];
        
    }
    return self;
}

- (void)setContentInformationModel:(GJGCInformationBaseModel *)contentModel
{
    [super setContentInformationModel:contentModel];
    
    GJGCInformationCellContentModel *informationModel = (GJGCInformationCellContentModel *)contentModel;
    
    self.backgroundImageView.gjcf_height = informationModel.contentHeight;
    [self.backgroundImageView setUrl:informationModel.groupHeadUrl];
    
    self.headView.gjcf_centerY = self.backgroundImageView.gjcf_height/2;
    self.headView.gjcf_centerX = GJCFSystemScreenWidth/2;
    [self.headView setUrl:informationModel.groupHeadUrl];
    
    self.nameLabel.text = informationModel.groupName;
    [self.nameLabel sizeToFit];
    self.nameLabel.gjcf_centerX = self.headView.gjcf_centerX;
    self.nameLabel.gjcf_top = self.headView.gjcf_bottom + self.contentMargin;
    
    self.baseContentView.gjcf_height = self.backgroundImageView.gjcf_bottom + self.contentMargin;
    
    self.topSeprateLine.gjcf_top = contentModel.topLineMargin;
    self.baseContentView.gjcf_top = self.topSeprateLine.gjcf_bottom-0.5;
    self.baseSeprateLine.gjcf_bottom = self.baseContentView.gjcf_bottom;
}

@end
