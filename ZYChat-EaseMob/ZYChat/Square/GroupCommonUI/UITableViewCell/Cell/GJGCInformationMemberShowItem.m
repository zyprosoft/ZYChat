//
//  GJGCInformationMemberShowItem.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-21.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationMemberShowItem.h"

@implementation GJGCInformationMemberShowItem

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.headView = [[GJGCCommonHeadView alloc]init];
    [self addSubview:self.headView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headView.frame = self.bounds;
    
}

- (void)setHeadUrl:(NSString *)url isMemeber:(BOOL)isMember
{
    if (isMember) {
        self.headView.hidden = YES;
    }else{
        self.headView.hidden = NO;
        [self.headView setHeadUrl:url headViewType:GJGCCommonHeadViewTypeContact];
        [self.headView setNeedsDisplay];
    }
}

@end
