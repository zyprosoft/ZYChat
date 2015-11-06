//
//  GJGCChatInputExpandMenuPanelItem.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatInputConst.h"

@class GJGCChatInputExpandMenuPanelItem;

typedef void (^GJGCChatInputExpandMenuPanelItemDidTapedBlock) (GJGCChatInputExpandMenuPanelItem *item);

@interface GJGCChatInputExpandMenuPanelItem : UIControl

@property (nonatomic,assign)NSInteger index;

@property (nonatomic,strong)NSDictionary *userInfo;

@property (nonatomic,assign)GJGCChatInputMenuPanelActionType actionType;

+ (GJGCChatInputExpandMenuPanelItem *)itemWithTitle:(NSString *)title withIconImageNormal:(UIImage *)iconImageNormal withIconImageHighlight:(UIImage *)iconImageHighlight withActionType:(GJGCChatInputMenuPanelActionType)actionType withTapBlock:(GJGCChatInputExpandMenuPanelItemDidTapedBlock)tapBlock;

@end
