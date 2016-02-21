//
//  GJGCInformationGroupPhotoBoxCell.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationBaseCell.h"
#import "GJGCInformationPhotoBox.h"
#import "GJGCInformationCellContentModel.h"

@interface GJGCInformationGroupPhotoBoxCell : GJGCInformationBaseCell

@property (nonatomic,strong)GJGCInformationPhotoBox *photoBox;

@property (nonatomic,strong)GJCFCoreTextContentView *nameLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *distanceLabel;

@property (nonatomic,assign)CGFloat contentBordMargin;

@end
