//
//  GJGCInformationPhotoBox.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJGCInformationPhotoBox;

@protocol GJGCInformationPhotoBoxDelegate <NSObject>

- (void)photoBoxDidTapAtIndex:(NSInteger)index;

@end

@interface GJGCInformationPhotoBox : UIView

@property (nonatomic,weak)id<GJGCInformationPhotoBoxDelegate> delegate;

@property (nonatomic,assign)CGFloat contentMargin;

- (void)setContentPhotoBoxUrls:(NSArray *)photoUrls;

@end
