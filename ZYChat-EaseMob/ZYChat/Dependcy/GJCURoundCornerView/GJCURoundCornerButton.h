//
//  GJCURoundCornerButton.h
//  GJCoreUserInterface
//
//  Created by ZYVincent on 14-11-4.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKRoundedView.h"
#import "GJCFCoreTextContentView.h"

@class GJCURoundCornerButton;

typedef void (^GJCURoundCornerButtonDidTapActionBlock) (GJCURoundCornerButton *button);

@interface GJCURoundCornerButton : UIView

@property (nonatomic,strong)TKRoundedView *cornerBackView;

@property (nonatomic,strong)GJCFCoreTextContentView *titleView;

@property (nonatomic,strong)UIColor *highlightBackColor;

@property (nonatomic,strong)UIColor *normalBackColor;

- (void)configureButtonDidTapAction:(GJCURoundCornerButtonDidTapActionBlock)tapAction;

@end
