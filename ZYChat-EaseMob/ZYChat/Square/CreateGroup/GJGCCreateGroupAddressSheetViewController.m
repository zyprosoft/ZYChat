//
//  GJGCCreateGroupAddressSheetViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/23.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCCreateGroupAddressSheetViewController.h"
#import "sqlService.h"

@interface GJGCCreateGroupAddressSheetViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)UIPickerView *cityPicker;
@property (nonatomic,strong)NSMutableArray *proviceArray,*cityArray,*regionArray;
@property (nonatomic,strong)sqlService *service;
@property (nonatomic,strong)NSString *proviceStr,*cityStr,*regionStr;


@end

@implementation GJGCCreateGroupAddressSheetViewController

- (void)doneAction
{
    if (self.resultBlock) {
        
        BTActionSheetBaseContentModel *contentModel = [[BTActionSheetBaseContentModel alloc]init];
        contentModel.userInfo = @{
                                  @"data":[NSString stringWithFormat:@"%@ - %@ - %@",self.proviceStr,self.cityStr,self.regionStr],
                                  };
        self.resultBlock(contentModel);
    }
    [self cancelAction];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,20, 320, 216)];
    self.cityPicker.dataSource = self;
    self.cityPicker.delegate = self;
    self.cityPicker.showsSelectionIndicator = YES;      // 这个弄成YES, picker中间就会有个条, 被选中的样子
    self.cityPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.cityPicker];
    
    [self.listTable removeFromSuperview];
    
    self.doneButton.hidden = NO;
    self.contentHeight = 216 + 40;
    
    self.service = [[sqlService alloc]init];
    self.proviceArray = [self.service getCityListByProvinceCode:@"0"];
    self.cityArray = [self.service getCityListByProvinceCode:[[self.proviceArray objectAtIndex:0] objectForKey:@"sCode"]];
    self.regionArray = [self.service getCityListByProvinceCode:[[self.cityArray objectAtIndex:0] objectForKey:@"sCode"]];
    self.proviceStr = [[self.proviceArray objectAtIndex:0] objectForKey:@"sName"];
    self.cityStr = [[self.cityArray objectAtIndex:0] objectForKey:@"sName"];
    self.regionStr = [[self.regionArray objectAtIndex:0] objectForKey:@"sName"];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = @"";
    if (component == 0) {
        return [[self.proviceArray objectAtIndex:row] objectForKey:@"sName"];
    }
    if (component == 1) {
        return [[self.cityArray objectAtIndex:row]objectForKey:@"sName"];
    }
    if (component == 2) {
        if ([self.regionArray count]>0) {
            return self.regionStr = [[self.regionArray objectAtIndex:row] objectForKey:@"sName"];
        }
        else{
            return @"";
        }
    }
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.cityArray = [self.service getCityListByProvinceCode:[[self.proviceArray objectAtIndex:row] objectForKey:@"sCode"]];
        [self.cityPicker reloadComponent:1];
        self.regionArray = [self.service getCityListByProvinceCode:[[self.cityArray objectAtIndex:0] objectForKey:@"sCode"]];
        [self.cityPicker reloadComponent:2];
        
        self.proviceStr = [[self.proviceArray objectAtIndex:row] objectForKey:@"sName"];
        self.cityStr = [[self.cityArray objectAtIndex:0] objectForKey:@"sName"];
        
        [self.cityPicker selectRow:0 inComponent:1 animated:YES];
        if ([self.cityArray count]>1) {
            [self.cityPicker selectRow:0 inComponent:2 animated:YES];
        }
        if ([self.regionArray count]>0) {
            self.regionStr = [[self.regionArray objectAtIndex:0] objectForKey:@"sName"];
        }
        else{
            self.regionStr = @"";
        }
    }
    else if (component == 1) {
        self.regionArray = [self.service getCityListByProvinceCode:[[self.cityArray objectAtIndex:row] objectForKey:@"sCode"]];
        [self.cityPicker reloadComponent:2];
        self.cityStr = [[self.cityArray objectAtIndex:row] objectForKey:@"sName"];
        if ([self.cityArray count]>1) {
            [self.cityPicker selectRow:0 inComponent:2 animated:YES];
        }
        if ([self.regionArray count]>0) {
            self.regionStr = [[self.regionArray objectAtIndex:0] objectForKey:@"sName"];
        }
        
    }
    else{
        if ([self.regionArray count]>0) {
            self.regionStr = [[self.regionArray objectAtIndex:row] objectForKey:@"sName"];
        }
        
        //第三栏可能没有数据
        
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.proviceArray count];
    }
    if (component == 1) {
        return [self.cityArray count];
    }
    if (component == 2) {
        return [self.regionArray count];
    }
    return 0;
}

@end
