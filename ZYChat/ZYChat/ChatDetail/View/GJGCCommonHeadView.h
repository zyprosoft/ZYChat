//
//  GJGCCommonHeadView.h
//  ZYChat
//
//  Created by ZYVincent on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GJGCCommonHeadViewTypeNone,//未定义
    GJGCCommonHeadViewTypePGGroup,//群
    GJGCCommonHeadViewTypeContact,//联系人
    GJGCCommonHeadViewTypePostContact,//帖子联系人
} GJGCCommonHeadViewType;

@interface GJGCCommonHeadView : UIButton

@property (nonatomic,strong)NSString *userId;

- (void)setHeadUrl:(NSString *)url;

- (void)setHeadUrl:(NSString *)url headViewType:(GJGCCommonHeadViewType)headViewType;

- (void)setHeadImage:(UIImage *)image;

- (void)setHiddenImageView:(BOOL)hidden;

@end
