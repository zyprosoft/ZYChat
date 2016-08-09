//
//  GJGCContactsCell.h
//  ZYChat
//
//  Created by ZYVincent on 16/8/8.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCContactsContentModel.h"

@interface GJGCContactsBaseCell : UITableViewCell

@property (nonatomic,strong)UIImageView *bottomLine;

- (void)setContentModel:(GJGCContactsContentModel *)contentModel;

- (CGFloat)cellHeight;

- (void)downloadImageWithConententModel:(GJGCContactsContentModel *)contentModel;

@end
