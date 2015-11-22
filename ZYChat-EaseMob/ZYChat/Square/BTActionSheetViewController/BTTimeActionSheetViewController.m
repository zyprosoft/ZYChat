//
//  BTTimeActionSheetViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTTimeActionSheetViewController.h"
#import "BTActionSheetTimePicker.h"


@interface BTTimeActionSheetViewController ()

@property (nonatomic,strong)BTActionSheetTimePicker *timePicker;

@end

@implementation BTTimeActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.contentView.backgroundColor = [UIColor whiteColor];
    self.timePicker = [[BTActionSheetTimePicker alloc]initWithFrame:self.listTable.frame withStartHour:self.startHour withStartMin:self.startMin];
    [self.contentView addSubview:self.timePicker];
    [self.listTable removeFromSuperview];

    self.doneButton.hidden = NO;
    self.contentHeight = 216 + 40;
}

- (void)doneAction
{
    if (GJCFStringIsNull(self.timePicker.selectedTime)) {
        [self  cancelAction];
        return;
    }
    
    if (self.resultBlock) {
        
        BTActionSheetBaseContentModel *contentModel = [[BTActionSheetBaseContentModel alloc]init];
        contentModel.userInfo = @{
                                  @"data":self.timePicker.selectedTime,
                                  @"hour":@(self.timePicker.selectedHour),
                                  @"min":@(self.timePicker.selectedMin),
                                  };
        self.resultBlock(contentModel);
    }
    [self cancelAction];
}

@end
