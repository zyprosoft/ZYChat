//
//  BTUploadMemberBaseCell.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCCreateGroupContentModel.h"
#import "GJGCCreateGroupCellDelegate.h"

@interface GJGCCreateGroupBaseCell : UITableViewCell

@property (nonatomic,weak)id<GJGCCreateGroupCellDelegate> delegate;

@property (nonatomic,strong)UILabel *tagLabel;

@property (nonatomic,strong)UIImageView *arrowImageView;

@property (nonatomic,strong)UIImageView *seprateLine;

@property (nonatomic,strong)UIImageView *bottomLine;

@property (nonatomic,assign)NSInteger maxInputLength;

- (NSString *)contentValue;

- (void)setContentModel:(GJGCCreateGroupContentModel *)contentModel;

- (CGFloat)cellHeight;

- (void)resignInputFirstResponse;

@end
