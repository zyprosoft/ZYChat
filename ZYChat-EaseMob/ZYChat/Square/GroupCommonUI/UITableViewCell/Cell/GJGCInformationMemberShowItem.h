//
//  GJGCInformationMemberShowItem.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-21.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJGCInformationMemberShowItem : UIButton

@property (nonatomic,strong)GJGCCommonHeadView *headView;

- (void)setHeadUrl:(NSString *)url isMemeber:(BOOL)isMember;

@end
