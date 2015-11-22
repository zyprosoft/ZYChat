//
//  BTActionSheetDatePicker.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTActionSheetDatePicker : UIView

@property (nonatomic,strong)NSDate *selectedDate;

- (instancetype)initWithFrame:(CGRect)frame withSelectedDate:(NSDate *)aDate withStartDate:(NSDate *)sDate withEndDate:(NSDate *)eDate;

@end
