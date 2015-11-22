//
//  BTDateActionSheetViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTDateActionSheetViewController.h"
#import "BTActionSheetDatePicker.h"


@interface BTDateActionSheetViewController ()

@property (nonatomic,strong)BTActionSheetDatePicker *timePicker;

@end

@implementation BTDateActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.timePicker = [[BTActionSheetDatePicker alloc]initWithFrame:self.listTable.frame withSelectedDate:self.selectedDate withStartDate:self.startDate withEndDate:self.endDate];
    [self.contentView addSubview:self.timePicker];
    [self.listTable removeFromSuperview];
    
    self.doneButton.hidden = NO;
    self.contentHeight = 216 + 40;
}

- (void)doneAction
{    
    if (self.resultBlock) {
        
        BTActionSheetBaseContentModel *contentModel = [[BTActionSheetBaseContentModel alloc]init];
        contentModel.userInfo = @{
                                  @"date":self.timePicker.selectedDate,
                                  };
        self.resultBlock(contentModel);
    }
    [self cancelAction];
}

@end
