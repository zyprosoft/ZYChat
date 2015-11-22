//
//  GJGCInfoBaseListBaseCell.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCInfoBaseListContentModel.h"

@interface GJGCInfoBaseListBaseCell : UITableViewCell

@property (nonatomic,strong)UIImageView *bottomLine;

- (void)setContentModel:(GJGCInfoBaseListContentModel *)contentModel;

- (CGFloat)cellHeight;

- (void)downloadImageWithContentModel:(GJGCInfoBaseListContentModel *)contentModel;

@end
