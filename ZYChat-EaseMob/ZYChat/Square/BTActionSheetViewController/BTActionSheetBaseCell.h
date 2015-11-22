//
//  BTActionSheetBaseCell.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTActionSheetBaseContentModel.h"

@interface BTActionSheetBaseCell : UITableViewCell

@property (nonatomic,strong)UIImageView *bottomLine;

- (void)setContentModel:(BTActionSheetBaseContentModel *)contentModel;

- (CGFloat)cellHeight;

@end
