//
//  GJGCRecentChatTitleView.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/19.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  链接状态
 */
typedef NS_ENUM(NSUInteger, GJGCRecentChatConnectState) {
    /**
     *  未链接到服务器
     */
    GJGCRecentChatConnectStateFaild,
    /**
     *  已链接
     */
    GJGCRecentChatConnectStateSuccess,
    /**
     *  正在链接
     */
    GJGCRecentChatConnectStateConnecting,
};

@interface GJGCRecentChatTitleView : UIView

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;

@property (nonatomic,assign)GJGCRecentChatConnectState connectState;

@end
