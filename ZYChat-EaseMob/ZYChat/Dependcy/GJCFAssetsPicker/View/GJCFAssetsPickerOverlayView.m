//
//  GJAssetsPickerOverlayView.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAssetsPickerOverlayView.h"
#import "GJCFAssetsPickerStyle.h"

@implementation GJCFAssetsPickerOverlayView

#pragma mark - 谨慎覆盖这两个方法

+ (GJCFAssetsPickerOverlayView*)defaultOverlayView
{
    GJCFAssetsPickerOverlayView *defaultView = [[GJCFAssetsPickerOverlayView alloc]init];
    defaultView.selected = NO;
    defaultView.enableChooseToSeeBigImageAction = YES;
    
    return defaultView;
}

- (void)setSelected:(BOOL)selected
{
    if (_selected == selected) {
        return;
    }
    _selected = selected;
    
    if (_selected) {
        [self switchSelectState];
    }else{
        [self switchNormalState];
    }
    
    [self setNeedsLayout];
}

#pragma mark - 自定义选中效果需要覆盖的方法

- (id)init
{
    if (self = [super init]) {
        
        self.selectIconImgView = [[UIImageView alloc]init];
        [self addSubview:self.selectIconImgView];
        
        self.selected = NO;//默认
        self.enableChooseToSeeBigImageAction = YES;
        
        //添加点击事件
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnSelf:)];
        [self addGestureRecognizer:tapR];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.selectIconImgView = [[UIImageView alloc]init];
        [self addSubview:self.selectIconImgView];
        
        self.selected = NO;//默认
        self.enableChooseToSeeBigImageAction = YES;
        
        //添加点击事件
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnSelf:)];
        [self addGestureRecognizer:tapR];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //将标记效果设置在右上角的位置
    CGSize iconSize = self.selectIconImgView.image.size;
    
    if (CGSizeEqualToSize(CGSizeZero, iconSize)) {
        return;
    }
    
    CGRect bounds = self.bounds;
    
    CGFloat xOrigin = bounds.size.width - 5 -iconSize.width;
    CGFloat yOrigin = 5;
    
    self.selectIconImgView.frame = (CGRect){xOrigin,yOrigin,iconSize.width,iconSize.height};
    
    //如果查看大图模式开启，默认将选中效果的响应范围绑定到icon图标大小范围内
    if (self.enableChooseToSeeBigImageAction) {
        
        /**
         *  调整触摸响应范围
         */
        self.frameToShowSelectedWhileBigImageActionEnabled = CGRectMake(self.selectIconImgView.frame.origin.x - 15, self.selectIconImgView.frame.origin.y - 5, self.selectIconImgView.frame.size.width + 20, self.selectIconImgView.frame.size.height + 20);
    }
    
}

- (void)switchNormalState
{
    self.selectIconImgView.image = [GJCFAssetsPickerStyle bundleImage:@"GjAssetsPicker_image_unselect.png"];
}

- (void)switchSelectState
{
    self.selectIconImgView.image = [GJCFAssetsPickerStyle bundleImage:@"GjAssetsPicker_image_selected.png"];
}

/* 设定是否允许查看大图的模式 */
- (void)setEnableChooseToSeeBigImageAction:(BOOL)enableChooseToSeeBigImageAction
{
    if (_enableChooseToSeeBigImageAction == enableChooseToSeeBigImageAction) {
        return;
    }
    
    _enableChooseToSeeBigImageAction = enableChooseToSeeBigImageAction;
    
    __block BOOL hasSetTapGesture = NO;
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            
            hasSetTapGesture = YES;
            
            if (!_enableChooseToSeeBigImageAction) {
                obj.enabled = NO;
                [obj removeTarget:self action:@selector(didTapOnSelf:)];
            }
        }
        
    }];
    
    /*  需要添加点击事件 */
    if (!hasSetTapGesture && _enableChooseToSeeBigImageAction) {
        
        //添加点击事件
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnSelf:)];
        [self addGestureRecognizer:tapR];
        
    }
    
}


#pragma mark - NSCoding

#pragma mark - tapGesture

/* 大图模式下自身才会启用点击交互,否则都是走父视图GJAssetsView直接判断点击事件 */
- (void)didTapOnSelf:(UITapGestureRecognizer *)tapR
{
    //如果不支持查看大图模式，那么直接改变状态就可以了
    if (!self.enableChooseToSeeBigImageAction) {
        
        //当前是非选中状态
        if (self.selected == NO) {
            
            BOOL canChangeToSelected = YES;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(pickerOverlayViewCanChangeToSelectedState:)]) {
                
                canChangeToSelected = [self.delegate pickerOverlayViewCanChangeToSelectedState:self];
            }
            
            if (!canChangeToSelected) {
                return;
            }
        }
        
        self.selected = !self.selected;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerOverlayView:responseToChangeSelectedState:)]) {
            [self.delegate pickerOverlayView:self responseToChangeSelectedState:self.selected];
        }
        
        return;
    }
    
    //如果支持查看大图模式
    if (self.enableChooseToSeeBigImageAction) {
        
        CGPoint tapPoint = [tapR locationInView:self];
        
        //如果是点击在了改变状态的frame范围内,那么响应状态改变代理事件
        if (CGRectContainsPoint(self.frameToShowSelectedWhileBigImageActionEnabled, tapPoint)) {
            
            //当前是非选中状态
            if (self.selected == NO) {
                
                BOOL canChangeToSelected = YES;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(pickerOverlayViewCanChangeToSelectedState:)]) {
                    
                    canChangeToSelected = [self.delegate pickerOverlayViewCanChangeToSelectedState:self];
                }
                
                if (!canChangeToSelected) {
                    return;
                }
            }
            
            self.selected = !self.selected;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(pickerOverlayView:responseToChangeSelectedState:)]) {
                
                [self.delegate pickerOverlayView:self responseToChangeSelectedState:self.selected];
                
            }
            
        }else{
            
            //需要进入大图查看模式
            if (self.delegate && [self.delegate respondsToSelector:@selector(pickerOverlayViewResponseToShowBigImage:)]) {
                
                [self.delegate pickerOverlayViewResponseToShowBigImage:self];
            }
        }
        
    }
}

@end
