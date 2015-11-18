//
//  GJGCChatBaseCell.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCChatContentBaseModel.h"
#import "GJGCChatBaseCellDelegate.h"

@interface GJGCChatBaseCell : UITableViewCell

@property (nonatomic,weak)id<GJGCChatBaseCellDelegate> delegate;

@property (nonatomic,assign)CGFloat cellMargin;

@property (nonatomic,assign)CGSize contentSize;

/* 虚方法 */
- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel;

/* 虚方法 */
- (CGFloat)heightForContentModel:(GJGCChatContentBaseModel *)contentModel;

- (void)pause;

- (void)resume;

@end
