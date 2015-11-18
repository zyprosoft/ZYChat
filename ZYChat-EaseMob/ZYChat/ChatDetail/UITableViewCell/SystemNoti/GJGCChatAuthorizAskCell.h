//
//  GJGCChatAuthorizAskCell.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatSystemNotiBaseCell.h"
#import "GJGCChatSystemNotiModel.h"
#import "GJCURoundCornerButton.h"
#import "GJGCChatSystemNotiRoleGroupView.h"
#import "GJGCChatSystemNotiRolePersonView.h"
#import "GJGCCommonHeadView.h"
@interface GJGCChatAuthorizAskCell : GJGCChatSystemNotiBaseCell

/**
 *  整个角色名片点击时候的效果
 */
@property (nonatomic,strong)GJCURoundCornerButton *roleViewTapBackButton;

@property (nonatomic,strong)GJCURoundCornerButton *applyButton;

@property (nonatomic,strong)GJCURoundCornerButton *rejectButton;

@property (nonatomic,strong)GJGCChatSystemNotiRoleGroupView *groupView;

@property (nonatomic,strong)GJGCChatSystemNotiRolePersonView *personView;

@property (nonatomic,strong)UIImageView *sepreteLine;

@property (nonatomic,strong)GJCFCoreTextContentView *nameLabel;

@property (nonatomic,strong)GJGCCommonHeadView *headView;

@property (nonatomic,strong)GJCFCoreTextContentView *applyAuthorizLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *applyAuthorizReasonLabel;

@property (nonatomic,assign)CGFloat headMargin;

@end
