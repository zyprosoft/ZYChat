//
//  ZFProgressView.h
//  ZFProgressView
//
//  Created by macOne on 15/9/23.
//  Copyright © 2015年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFProgressViewStyle) {
    ZFProgressViewStyleNone = 0,
    ZFProgressViewStyleSquareSegment,
    ZFProgressViewStyleRoundSegment,
    ZFProgressViewStyleImageSegment,

};

IB_DESIGNABLE
@interface ZFProgressView : UIView

//进度线条宽度
@property (nonatomic,assign) IBInspectable CGFloat progressLineWidth;
//背景线条宽度
@property (nonatomic,assign) IBInspectable CGFloat backgourndLineWidth;
//进度百分比
@property (nonatomic,assign) IBInspectable CGFloat Percentage;
//背景填充颜色
@property (nonatomic,strong) IBInspectable UIColor *backgroundStrokeColor;
//进度条填充颜色
@property (nonatomic,strong) IBInspectable UIColor *progressStrokeColor;
//距离边框边距偏移量
@property (nonatomic,assign) IBInspectable CGFloat offset;
//步长
@property (nonatomic,assign) IBInspectable CGFloat step;

//数字字体颜色
@property (nonatomic,strong) IBInspectable UIColor *digitTintColor;

//设置图片
@property (nonatomic,strong) IBInspectable UIImage *image;

//动画持续时间。 单位：秒
@property (nonatomic) CGFloat timeDuration;

/*
 设置每个格子的宽度与线条宽度要注意
 由于使用原点画圆弧的原因，距离原点越近，弧长越短
 
 要求：
 设置的线条宽度lineWidth < GapWidth
 */


//格子之间的宽度
@property (nonatomic,assign) IBInspectable CGFloat GapWidth;
//设置线条宽度 （进度条宽度 = 背景线条宽度）
@property (nonatomic,assign) IBInspectable CGFloat lineWidth;

//style
- (instancetype) initWithFrame:(CGRect)frame style:(ZFProgressViewStyle)style;

- (instancetype) initWithFrame:(CGRect)frame style:(ZFProgressViewStyle)style withImage:(UIImage *)image;

-(void)setProgress:(CGFloat)Percentage Animated:(BOOL)animated;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com