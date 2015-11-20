//
//  BTActionSheetDatePicker.h
//  ZYChat
//
//  Created by ZYVincent on 15/9/9.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTActionSheetDatePicker : UIView

@property (nonatomic,strong)NSDate *selectedDate;

- (instancetype)initWithFrame:(CGRect)frame withSelectedDate:(NSDate *)aDate withStartDate:(NSDate *)sDate withEndDate:(NSDate *)eDate;

@end
