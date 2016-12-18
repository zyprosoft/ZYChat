//
//  GJGCContactsHeaderView.m
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCContactsHeaderView.h"

@interface GJGCContactsHeaderView ()

@property (nonatomic,strong)UIButton *headerBtn;

@property (nonatomic,strong)UILabel *countOnline;


@end

@implementation GJGCContactsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:97/255.f green:60/255.f blue:140/255.f alpha:0.8];

        //头视图  按钮
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headerBtn = headerBtn;
        [self.headerBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self.headerBtn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:0];
        self.headerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.headerBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.headerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        [self.headerBtn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:0];
//        [self.headerBtn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:1];
        self.headerBtn.imageView.contentMode = UIViewContentModeCenter;
        self.headerBtn.imageView.clipsToBounds = NO;
        [self.headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:headerBtn];

        UILabel *countOnline = [[UILabel alloc] init];
        self.countOnline = countOnline;
        self.countOnline.textAlignment = NSTextAlignmentRight;
        self.countOnline.font = [UIFont  systemFontOfSize:14.0];
        self.countOnline.textColor = [UIColor whiteColor];
        [self addSubview:countOnline];

    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.headerBtn.frame = self.bounds;
    
    CGFloat countX = self.bounds.size.width - 160;
    
    self.countOnline.frame = CGRectMake(countX, 0, 150, 44);
}

- (void)setTitle:(NSString *)title withCount:(NSString *)count isExpand:(BOOL)isExpand
{
    [self.headerBtn setTitle:title forState:0];
    self.countOnline.text = count;
    
    if (isExpand) {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)headerBtnClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactsHeaderViewDidTapped:)]) {
        [self.delegate contactsHeaderViewDidTapped:self];
    }
}

@end
