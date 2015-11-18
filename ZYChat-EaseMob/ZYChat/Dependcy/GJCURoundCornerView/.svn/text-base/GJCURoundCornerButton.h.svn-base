//
//  GJCURoundCornerButton.h
//  GJCoreUserInterface
//
//  Created by ZYVincent on 14-11-4.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJCURoundCornerView.h"
#import "GJCFCoreTextContentView.h"

@class GJCURoundCornerButton;

typedef void (^GJCURoundCornerButtonDidTapActionBlock) (GJCURoundCornerButton *button);

@interface GJCURoundCornerButton : UIView

@property (nonatomic,strong)GJCURoundCornerView *cornerBackView;

@property (nonatomic,strong)GJCFCoreTextContentView *titleView;

@property (nonatomic,strong)UIColor *highlightBackColor;

@property (nonatomic,strong)UIColor *normalBackColor;

- (void)configureButtonDidTapAction:(GJCURoundCornerButtonDidTapActionBlock)tapAction;

@end
