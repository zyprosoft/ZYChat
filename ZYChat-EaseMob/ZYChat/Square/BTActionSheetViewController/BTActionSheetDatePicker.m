//
//  BTActionSheetDatePicker.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetDatePicker.h"

@interface BTActionSheetDatePicker ()

@property (nonatomic,strong)UIDatePicker *datePicker;

@end

@implementation BTActionSheetDatePicker

- (instancetype)initWithFrame:(CGRect)frame withSelectedDate:(NSDate *)aDate withStartDate:(NSDate *)sDate withEndDate:(NSDate *)eDate
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor whiteColor];
        self.datePicker = [[UIDatePicker alloc]init];
        self.datePicker.gjcf_width = self.gjcf_width;
        self.datePicker.gjcf_height = 216.f;
        if (sDate) {
            self.datePicker.minimumDate = sDate;
        }
        self.datePicker.maximumDate = eDate;
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.date = aDate;
        [self addSubview:self.datePicker];
    
    }
    return self;
}

- (NSDate *)selectedDate
{
    return self.datePicker.date;
}

@end
