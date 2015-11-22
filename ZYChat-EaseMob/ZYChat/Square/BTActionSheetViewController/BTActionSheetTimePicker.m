//
//  BTActionSheetTimePicker.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetTimePicker.h"

@interface BTActionSheetTimePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)UIPickerView *pickerView;

@end

@implementation BTActionSheetTimePicker

- (instancetype)initWithFrame:(CGRect)frame withStartHour:(NSInteger)aHour withStartMin:(NSInteger)aMin;
{
    if (self = [super initWithFrame:frame]) {
     
        self.backgroundColor = [UIColor whiteColor];
        if (aHour > 0) {
            self.startHour = aHour + 1;
        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.pickerView = [[UIPickerView alloc]init];
        self.pickerView.gjcf_width = self.gjcf_width;
        self.pickerView.gjcf_height = 216.f;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
        
        NSInteger midHourIndex = [self hourRowsCount]/2;
        NSInteger midMinIndex = [self minRowsCount]/2;
        
        [self.pickerView selectRow:midHourIndex inComponent:0 animated:NO];
        [self.pickerView selectRow:midMinIndex inComponent:1 animated:NO];
        
        [self updateSelectedTime];
        
    }
    return self;
}

- (NSInteger)hourRowsCount
{
    //自动推后一个小时
    NSInteger itemCount = 24 - self.startHour;
    
    return itemCount;
}

- (NSInteger)minRowsCount
{
    NSInteger itemCount = 60;
    
    return itemCount;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        
        return [self hourRowsCount];
    }
    
    if (component == 1) {
        
        return [self minRowsCount];
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.gjcf_width = 50;
    titleLabel.gjcf_height = 30.f;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *resultString = nil;
    
    if (component == 0) {
        
        resultString = [NSString stringWithFormat:@"%d",self.startHour + row];
        
    }
    
    if (component == 1) {
        
        resultString = [NSString stringWithFormat:@"%ld",(long)row];
    }
    
    titleLabel.text = resultString;
    
    return titleLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateSelectedTime];
}

- (void)updateSelectedTime
{
    NSInteger hour = [self.pickerView selectedRowInComponent:0];
    NSInteger min = [self.pickerView selectedRowInComponent:1];
    
    self.selectedHour = hour;
    
    UILabel *hourLabel = (UILabel *)[self.pickerView viewForRow:hour forComponent:0];
    UILabel *minLabel = (UILabel *)[self.pickerView viewForRow:min forComponent:1];
    
    _selectedTime = [NSString stringWithFormat:@"%@:%@",hourLabel.text,minLabel.text];
    
    NSDateFormatter *formtte = GJCFDateShareFormatter;
    [formtte setTimeStyle:NSDateFormatterShortStyle];
    [formtte setDateFormat:@"HH:mm"];
    
    NSDate *date = [formtte dateFromString:_selectedTime];
    _selectedTime = GJCFDateToStringByFormat(date, kNSDateHelperFormatTime);
}

@end
