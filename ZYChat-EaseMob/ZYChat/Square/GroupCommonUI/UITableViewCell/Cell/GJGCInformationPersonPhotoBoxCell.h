//
//  GJGCInformationPersonPhotoBoxCell.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationBaseCell.h"
#import "GJGCInformationPhotoBox.h"
#import "GJGCInformationCellContentModel.h"
#import "GJGCTagView.h"
@interface GJGCInformationPersonPhotoBoxCell : GJGCInformationBaseCell

@property (nonatomic,strong)GJGCInformationPhotoBox *photoBox;

@property (nonatomic,strong)GJCFCoreTextContentView *nameLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *distanceLabel;

@property (nonatomic,strong)UIImageView *distanceTimeSeprateLine;

@property (nonatomic,strong)UIImageView *sexImgView;

@property (nonatomic,strong)GJCFCoreTextContentView *timeLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *ageLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *starNameLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *helloCountLabel;

@property (nonatomic,assign)CGFloat contentBordMargin;

@property (nonatomic,strong)GJGCTagView *personAttrView;
@end
