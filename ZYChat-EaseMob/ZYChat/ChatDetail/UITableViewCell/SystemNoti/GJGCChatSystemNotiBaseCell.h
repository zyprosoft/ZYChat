//
//  GJGCChatBaseCell.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCCommonFontColorStyle.h"
#import "GJGCChatBaseCell.h"
#import "GJCFCoreTextContentView.h"
@interface GJGCChatSystemNotiBaseCell : GJGCChatBaseCell

@property (nonatomic,strong)GJCFCoreTextContentView *timeLabel;

@property (nonatomic,assign)CGFloat timeContentMargin;

@property (nonatomic,strong)GJCFCoreTextContentView *contentLabel;

@property (nonatomic,strong)UIImageView *accessoryIndicator;

@property (nonatomic,strong)UIImageView *stateContentView;

@property (nonatomic,assign)BOOL showAccesoryIndicator;

@property (nonatomic,assign)CGFloat contentBordMargin;

@property (nonatomic,assign)CGFloat contentInnerMargin;

- (CGFloat)cellHeight;

@end
