//
//  BTActionSheetTimePicker.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTActionSheetTimePicker : UIView

@property (nonatomic,assign)NSInteger startHour;

@property (nonatomic,assign)NSInteger startMin;

@property (nonatomic,readonly)NSString *selectedTime;

@property (nonatomic,assign)NSInteger selectedHour;

@property (nonatomic,assign)NSInteger selectedMin;

- (instancetype)initWithFrame:(CGRect)frame withStartHour:(NSInteger)aHour withStartMin:(NSInteger)aMin;

@end
