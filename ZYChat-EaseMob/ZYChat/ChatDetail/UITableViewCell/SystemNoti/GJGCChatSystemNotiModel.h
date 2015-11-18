//
//  GJGCChatSystemNotiModel.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatContentBaseModel.h"
#import "GJGCChatSystemNotiConstans.h"

/**
 *  助手消息类型
 */
typedef NS_ENUM(NSUInteger, GJGCChatSystemNotiAssistType) {
    /**
     *  群助手
     */
    GJGCChatSystemNotiAssistTypeGroup,
    /**
     *  好友助手
     */
    GJGCChatSystemNotiAssistTypeFriend,
    /**
     *  推荐
     */
    GJGCChatSystemNotiAssistTypeTemplate,
    /**
     *  普通系统消息
     */
    GJGCChatSystemNotiAssistTypeNormal
};

@interface GJGCChatSystemNotiModel : GJGCChatContentBaseModel

#pragma mark - 消息类型

/**
 *  这个很重要，最终会根据这个来调用相应样式的cell
 */
@property (nonatomic,assign)GJGCChatSystemNotiType notiType;

@property (nonatomic,assign)GJGCChatSystemGroupAssistNotiType groupAssistNotiType;

/**
 *  是否可以启用选中状态
 */
@property (nonatomic,assign)BOOL canShowHighlightState;

#pragma mark - 通用属性绑定

@property (nonatomic,assign)GJGCChatSystemNotiAssistType assistType;

/**
 *  申请信息
 */
@property (nonatomic,strong)NSAttributedString *applyTip;

/**
 *  申请理由,也可以用来作为自己曾经历史操作状态展示的文本
 */
@property (nonatomic,strong)NSAttributedString *applyReason;

#pragma mark - 群组绑定

@property (nonatomic,strong)NSAttributedString *name;

/**
 *  用户昵称
 */
@property (nonatomic,strong)NSAttributedString *nickName;

@property (nonatomic,strong)NSString *headUrl;

@property (nonatomic,strong)NSAttributedString *groupLevel;

@property (nonatomic,strong)NSAttributedString *groupMemberCount;

/* 名片是否显示群组内容 */
@property (nonatomic,assign)BOOL      isGroupContent;

@property (nonatomic,assign)long long groupId;

#pragma mark - 个人绑定

@property (nonatomic,strong)NSString *userSex;

@property (nonatomic,strong)NSAttributedString *userAge;

@property (nonatomic,strong)NSAttributedString *userStarName;

/* 名片是否显示用户内容 */
@property (nonatomic,assign)BOOL isUserContent;

@property (nonatomic,assign)long long userId;

#pragma mark - 群组操作信息内容

@property (nonatomic,strong)NSAttributedString *groupOperationTip;

#pragma mark - 系统信息内容

@property (nonatomic,strong)NSAttributedString *systemNotiTitle;

@property (nonatomic,strong)NSAttributedString *systemOperationTip;

@property (nonatomic,strong)NSString *systemActiveImageUrl;

/**
 *  用于创建用户消息和创建简历的消息跳转
 */
@property (nonatomic,assign)NSInteger systemJumpType;

/**
 *  用于创建用户消息和创建简历的消息跳转，这是服务器传来的请求接口参数
 */
@property (nonatomic,strong)NSString *systemJumpUrl;

/**
 *  引导card的title
 */
@property (nonatomic,strong)NSAttributedString *systemGuideButtonTitle;

#pragma mark - 帖子系统消息

@property (nonatomic,strong)NSAttributedString *postSystemContent;

@property (nonatomic,strong)NSDictionary *postSystemAppendType;

@property (nonatomic,assign)NSInteger postSystemJumpType;

@end
