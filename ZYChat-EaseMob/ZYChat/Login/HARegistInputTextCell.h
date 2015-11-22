//
//  HARegistInputTextCell.h
//  HelloAsk
//
//  Created by ZYVincent on 15-9-4.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HARegistContentModel.h"

@class HARegistInputTextCell;
@protocol HARegistInputTextCellDelegate <NSObject>

- (void)inputCell:(HARegistInputTextCell *)inputCell didUpdateContent:(NSString *)content;

@end

@interface HARegistInputTextCell : UITableViewCell

@property (nonatomic,weak)id<HARegistInputTextCellDelegate> delegate;

- (void)setContentModel:(HARegistContentModel *)contentModel;

@end
