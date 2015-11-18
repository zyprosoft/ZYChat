//
//  GJAssetsPickerCell.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAssetsPickerCell.h"

#define GJAssetsBaseTag 22334455

@implementation GJCFAssetsPickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setAssets:(NSArray *)assets
{
    if (!assets) {
        return;
    }
        
    for (int idx = 0; idx<assets.count; idx++) {
        
        GJCFAsset *asset = [assets objectAtIndex:idx];
        
        GJCFAssetsView *currentAssetView = (GJCFAssetsView*)[self.contentView viewWithTag:GJAssetsBaseTag+idx];
        currentAssetView.hidden = NO;
        
        if (!currentAssetView) {
            
            CGFloat totalWidth = [UIScreen mainScreen].bounds.size.width;
        
            CGFloat itemWidth = 0.f;
            if (self.colums==0) {
                
                CGFloat useWidth = totalWidth-((assets.count-1) * self.columSpace);
                
                itemWidth = useWidth/assets.count;
            }else{
                
                CGFloat useWidth = totalWidth-((self.colums-1) * self.columSpace);
                
                itemWidth = useWidth/self.colums;
            }
            
            GJCFAssetsView *assetView = [[GJCFAssetsView alloc]initWithFrame:(CGRect){idx*itemWidth+idx*self.columSpace,self.columSpace,itemWidth,itemWidth}];
            assetView.tag = GJAssetsBaseTag + idx;
            
            [self.contentView addSubview:assetView];
            
            [assetView setAsset:asset];
            
            //如果没有查看大图模式响应，那么仍然采用原来的方式来反馈
            if (!self.enableBigImageShowAction) {
                
                //点击图片改变状态
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnAssetsView:)];
                [assetView addGestureRecognizer:tapGesture];
                
                GJCFAssetsPickerOverlayView *overlayView = [[self.overlayViewClass alloc]init];
                overlayView.userInteractionEnabled = NO;
                [assetView setOverlayView:overlayView];
                
            }else{
                
                GJCFAssetsPickerOverlayView *overlayView = [[self.overlayViewClass alloc]init];
                overlayView.userInteractionEnabled = YES;
                overlayView.enableChooseToSeeBigImageAction = self.enableBigImageShowAction;
                [assetView setOverlayView:overlayView];
                assetView.overlayView.delegate = self;
            }
            
        }else{
            
            [currentAssetView setAsset:asset];
            
        }
        
    }
    
    //隐藏用不到
    for (NSInteger i = assets.count; i<self.colums; i++) {
        GJCFAssetsView *currentAssetView = (GJCFAssetsView*)[self.contentView viewWithTag:GJAssetsBaseTag+i];
        currentAssetView.hidden = YES;
    }
}

#pragma mark - pickerOverlayView delegate
- (void)pickerOverlayViewResponseToShowBigImage:(GJCFAssetsPickerOverlayView *)overlayView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsPickerCell:shouldBeginBigImageShowAtIndex:)]) {
        
        [self.delegate assetsPickerCell:self shouldBeginBigImageShowAtIndex:overlayView.tag-GJAssetsBaseTag];
    }
}

- (void)pickerOverlayView:(GJCFAssetsPickerOverlayView *)overlayView responseToChangeSelectedState:(BOOL)state
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsPickerCell:didChangeStateAtIndex:withState:)]) {
        
        [self.delegate assetsPickerCell:self didChangeStateAtIndex:overlayView.tag-GJAssetsBaseTag withState:overlayView.selected];
        
    }
}

- (BOOL)pickerOverlayViewCanChangeToSelectedState:(GJCFAssetsPickerOverlayView *)overlayView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsPickerCell:shouldChangeToSelectedStateAtIndex:)]) {
        
        return [self.delegate assetsPickerCell:self shouldChangeToSelectedStateAtIndex:overlayView.tag-GJAssetsBaseTag];
        
    }else{
        
        return YES;
    }
}

/* 不支持大图查看模式的时候走这个响应点击事件 */
- (void)didTapOnAssetsView:(UITapGestureRecognizer*)aTapR
{
    GJCFAssetsView *currentAssetView = (GJCFAssetsView*)aTapR.view;
    
    //如果是想变成选中状态，那么我们需要检测一下是否超过限定的数量
    if (currentAssetView.overlayView.selected == NO) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(assetsPickerCell:shouldChangeToSelectedStateAtIndex:)]) {
            BOOL canChangeState = [self.delegate assetsPickerCell:self shouldChangeToSelectedStateAtIndex:currentAssetView.tag-GJAssetsBaseTag];
            if (!canChangeState) {
                return;
            }
        }
        
    }
    
    //改变状态
    currentAssetView.overlayView.selected = !currentAssetView.overlayView.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsPickerCell:didChangeStateAtIndex:withState:)]) {
        [self.delegate assetsPickerCell:self didChangeStateAtIndex:currentAssetView.tag-GJAssetsBaseTag withState:currentAssetView.overlayView.selected];
    }
}


@end
